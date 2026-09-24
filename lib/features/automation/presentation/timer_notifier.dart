import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../data/timer_preferences.dart';
import '../data/native_timer_service.dart';

part 'timer_notifier.freezed.dart';
part 'timer_notifier.g.dart';

enum TimerMode {
  countdown,
  countup,
}

@freezed
abstract class TimerState with _$TimerState {
  const factory TimerState({
    required int duration,
    required int remainingSeconds,
    @Default(0) int elapsedSeconds,
    required bool isRunning,
    required bool isPaused,
    required bool isFinished,
    required String label,
    @Default(TimerMode.countdown) TimerMode mode,
    DateTime? targetEndTime,
    DateTime? startTime,
    int? countUpLimitSeconds,
  }) = _TimerState;
}

@Riverpod(keepAlive: true)
class TimerNotifier extends _$TimerNotifier {
  Timer? _ticker;

  @override
  TimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      FlutterRingtonePlayer().stop();
      NativeTimerService.cancelAlarm();
    });
    return const TimerState(
      duration: 300,
      remainingSeconds: 300,
      elapsedSeconds: 0,
      isRunning: false,
      isPaused: false,
      isFinished: false,
      label: 'TIMER',
      mode: TimerMode.countdown,
    );
  }

  void start(int seconds, String label) {
    _ticker?.cancel();
    TimerPreferences.saveLastDuration(seconds);
    final targetEndTime = DateTime.now().add(Duration(seconds: seconds));

    state = TimerState(
      duration: seconds,
      remainingSeconds: seconds,
      elapsedSeconds: 0,
      isRunning: true,
      isPaused: false,
      isFinished: false,
      label: label,
      mode: TimerMode.countdown,
      targetEndTime: targetEndTime,
    );

    NativeTimerService.scheduleAlarm(
      endTime: targetEndTime,
      label: label,
      durationSeconds: seconds,
    );

    _startTicker();
  }

  void startCountUp({String label = 'FOCUS FLOW', int? limitSeconds}) {
    _ticker?.cancel();
    final now = DateTime.now();

    state = TimerState(
      duration: limitSeconds ?? 0,
      remainingSeconds: limitSeconds ?? 0,
      elapsedSeconds: 0,
      isRunning: true,
      isPaused: false,
      isFinished: false,
      label: label,
      mode: TimerMode.countup,
      startTime: now,
      countUpLimitSeconds: limitSeconds,
      targetEndTime: limitSeconds != null && limitSeconds > 0
          ? now.add(Duration(seconds: limitSeconds))
          : null,
    );

    if (limitSeconds != null && limitSeconds > 0) {
      NativeTimerService.scheduleAlarm(
        endTime: state.targetEndTime!,
        label: label,
        durationSeconds: limitSeconds,
      );
    } else {
      NativeTimerService.cancelAlarm();
    }

    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!state.isRunning || state.isPaused) {
        timer.cancel();
        return;
      }
      _syncTime();
    });
  }

  void _syncTime() {
    if (!state.isRunning || state.isPaused) return;

    final now = DateTime.now();

    if (state.mode == TimerMode.countup) {
      if (state.startTime == null) return;
      final elapsed = now.difference(state.startTime!).inSeconds;

      if (state.countUpLimitSeconds != null && state.countUpLimitSeconds! > 0) {
        if (elapsed >= state.countUpLimitSeconds!) {
          _ticker?.cancel();
          NativeTimerService.hideOngoingNotification();
          state = state.copyWith(
            elapsedSeconds: state.countUpLimitSeconds!,
            remainingSeconds: 0,
            isRunning: false,
            isFinished: true,
          );
          FlutterRingtonePlayer().playAlarm(looping: false);
          return;
        }
      }

      if (state.elapsedSeconds != elapsed) {
        state = state.copyWith(elapsedSeconds: elapsed);
      }
    } else {
      // Countdown mode
      if (state.targetEndTime == null) return;
      final diffMs = state.targetEndTime!.difference(now).inMilliseconds;
      final remaining = (diffMs / 1000).ceil();

      if (remaining > 0) {
        if (state.remainingSeconds != remaining) {
          state = state.copyWith(remainingSeconds: remaining);
        }
      } else {
        _ticker?.cancel();
        NativeTimerService.hideOngoingNotification();
        state = state.copyWith(
          remainingSeconds: 0,
          isRunning: false,
          isFinished: true,
        );
        FlutterRingtonePlayer().playAlarm(looping: false);
      }
    }
  }

  /// Called when the app resumes from background or screen is unlocked.
  void sync() {
    if (state.isRunning && !state.isPaused) {
      _syncTime();
      if (state.isRunning && !state.isFinished) {
        _startTicker();
      }
    }
  }

  void pause() {
    _ticker?.cancel();
    NativeTimerService.cancelAlarm();
    NativeTimerService.hideOngoingNotification();

    if (state.mode == TimerMode.countup) {
      final elapsed = state.startTime != null
          ? DateTime.now().difference(state.startTime!).inSeconds
          : state.elapsedSeconds;
      state = state.copyWith(
        isPaused: true,
        elapsedSeconds: elapsed,
      );
    } else {
      final remaining = state.targetEndTime != null
          ? (state.targetEndTime!.difference(DateTime.now()).inMilliseconds /
                  1000)
              .ceil()
              .clamp(0, state.duration)
          : state.remainingSeconds;

      state = state.copyWith(
        isPaused: true,
        remainingSeconds: remaining,
        targetEndTime: null,
      );
    }
    FlutterRingtonePlayer().stop();
  }

  void resume() {
    if (state.mode == TimerMode.countup) {
      final newStartTime =
          DateTime.now().subtract(Duration(seconds: state.elapsedSeconds));
      final newTargetEndTime = state.countUpLimitSeconds != null &&
              state.countUpLimitSeconds! > 0
          ? newStartTime.add(Duration(seconds: state.countUpLimitSeconds!))
          : null;

      state = state.copyWith(
        isPaused: false,
        startTime: newStartTime,
        targetEndTime: newTargetEndTime,
      );

      if (newTargetEndTime != null) {
        final remaining =
            newTargetEndTime.difference(DateTime.now()).inSeconds;
        if (remaining > 0) {
          NativeTimerService.scheduleAlarm(
            endTime: newTargetEndTime,
            label: state.label,
            durationSeconds: remaining,
          );
        }
      }
    } else {
      if (state.remainingSeconds <= 0) return;
      final targetEndTime =
          DateTime.now().add(Duration(seconds: state.remainingSeconds));

      state = state.copyWith(
        isPaused: false,
        targetEndTime: targetEndTime,
      );

      NativeTimerService.scheduleAlarm(
        endTime: targetEndTime,
        label: state.label,
        durationSeconds: state.remainingSeconds,
      );
    }

    _startTicker();
  }

  void reset() {
    _ticker?.cancel();
    FlutterRingtonePlayer().stop();
    NativeTimerService.cancelAlarm();
    NativeTimerService.hideOngoingNotification();
    state = state.copyWith(
      isRunning: false,
      isPaused: false,
      isFinished: false,
      remainingSeconds: state.duration,
      elapsedSeconds: 0,
      targetEndTime: null,
      startTime: null,
    );
  }
}
