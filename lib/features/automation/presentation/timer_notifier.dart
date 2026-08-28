import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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
    state = TimerState(
      duration: seconds,
      remainingSeconds: seconds,
      isRunning: true,
      isPaused: false,
      isFinished: false,
      label: label,
    );

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      } else {
        timer.cancel();
        state = state.copyWith(
          remainingSeconds: 0,
          isRunning: false,
          isFinished: true,
        );
        FlutterRingtonePlayer().playAlarm(looping: false);
      }
    });
  }

  void pause() {
    _ticker?.cancel();
    state = state.copyWith(isPaused: true);
    FlutterRingtonePlayer().stop();
  }

  void resume() {
    state = state.copyWith(isPaused: false);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      } else {
        timer.cancel();
        state = state.copyWith(
          remainingSeconds: 0,
          isRunning: false,
          isFinished: true,
        );
        FlutterRingtonePlayer().playAlarm(looping: false);
      }
    });
  }

  void reset() {
    _ticker?.cancel();
    FlutterRingtonePlayer().stop();
    state = state.copyWith(
      isRunning: false,
      isPaused: false,
      isFinished: false,
      remainingSeconds: state.duration,
    );
  }
}
