import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service that interacts with native Android/iOS alarm managers to ensure
/// timers wake the device and fire notifications even when the app is in the
/// background or the device screen is locked.
class NativeTimerService {
  static const _channel = MethodChannel('dev.aster.nfc_write/timer');

  /// Requests notification permission on modern Android versions (Android 13+).
  static Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }
  }

  /// Schedules a hardware exact alarm on Android to trigger when timer reaches 0.
  static Future<void> scheduleAlarm({
    required DateTime endTime,
    required String label,
    required int durationSeconds,
  }) async {
    try {
      if (Platform.isAndroid) {
        await requestNotificationPermission();
        await _channel.invokeMethod('scheduleTimerAlarm', {
          'triggerAtMillis': endTime.millisecondsSinceEpoch,
          'title': 'Timer Finished',
          'label': label,
        });
      }
    } catch (_) {}
  }

  /// Shows a live ticking Android chronometer countdown notification.
  static Future<void> showOngoingNotification({
    required DateTime whenTime,
    required String label,
    required bool isCountdown,
  }) async {
    try {
      if (Platform.isAndroid) {
        await requestNotificationPermission();
        await _channel.invokeMethod('showOngoingNotification', {
          'whenMillis': whenTime.millisecondsSinceEpoch,
          'label': label,
          'isCountdown': isCountdown,
        });
      }
    } catch (_) {}
  }

  /// Hides the live ongoing notification.
  static Future<void> hideOngoingNotification() async {
    try {
      if (Platform.isAndroid) {
        await _channel.invokeMethod('hideOngoingNotification');
      }
    } catch (_) {}
  }

  /// Cancels any scheduled native hardware alarms.
  static Future<void> cancelAlarm() async {
    try {
      if (Platform.isAndroid) {
        await _channel.invokeMethod('cancelTimerAlarm');
      }
    } catch (_) {}
  }
}
