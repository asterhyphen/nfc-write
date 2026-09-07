import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../data/timer_preferences.dart';
import '../data/native_timer_service.dart';

part 'timer_notifier.freezed.dart';
part 'timer_notifier.g.dart';

@freezed
abstract class TimerState with _$TimerState {
  const factory TimerState({
    required int duration,
    required int remainingSeconds,
    required bool isRunning,
    required bool isPaused,
    required bool isFinished,
    required String label,
    DateTime? targetEndTime,
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
      isRunning: false,
      isPaused: false,
      isFinished: false,
      label: 'TIMER',
    );
  }

  void start(int seconds, String label) {
    _ticker?.cancel();
    TimerPreferences.saveLastDuration(seconds);
    final targetEndTime = DateTime.now().add(Duration(seconds: seconds));

    state = TimerState(
      duration: seconds,
      remainingSeconds: seconds,
      isRunning: true,
      isPaused: false,
      isFinished: false,
      label: label,
      targetEndTime: targetEndTime,
    );

    NativeTimerService.scheduleAlarm(
      endTime: targetEndTime,
      label: label,
      durationSeconds: seconds,
    );

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
    if (state.targetEndTime == null || !state.isRunning) return;

    final now = DateTime.now();
    final diffMs = state.targetEndTime!.difference(now).inMilliseconds;
    final remaining = (diffMs / 1000).ceil();

    if (remaining > 0) {
      if (state.remainingSeconds != remaining) {
        state = state.copyWith(remainingSeconds: remaining);
      }
    } else {
      _ticker?.cancel();
      state = state.copyWith(
        remainingSeconds: 0,
        isRunning: false,
        isFinished: true,
      );
      FlutterRingtonePlayer().playAlarm(looping: false);
    }
  }

  /// Called when the app resumes from background or screen is unlocked.
  void sync() {
    if (state.isRunning && !state.isPaused && state.targetEndTime != null) {
      _syncTime();
      if (state.isRunning && !state.isFinished) {
        _startTicker();
      }
    }
  }

  void pause() {
    _ticker?.cancel();
    NativeTimerService.cancelAlarm();
    final remaining = state.targetEndTime != null
        ? (state.targetEndTime!.difference(DateTime.now()).inMilliseconds / 1000)
            .ceil()
            .clamp(0, state.duration)
        : state.remainingSeconds;

    state = state.copyWith(
      isPaused: true,
      remainingSeconds: remaining,
      targetEndTime: null,
    );
    FlutterRingtonePlayer().stop();
  }

  void resume() {
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

    _startTicker();
  }

  void reset() {
    _ticker?.cancel();
    FlutterRingtonePlayer().stop();
    NativeTimerService.cancelAlarm();
    state = state.copyWith(
      isRunning: false,
      isPaused: false,
      isFinished: false,
      remainingSeconds: state.duration,
      targetEndTime: null,
    );
  }
}
