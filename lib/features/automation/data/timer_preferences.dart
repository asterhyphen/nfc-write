import 'package:shared_preferences/shared_preferences.dart';

const _kLastTimerDurationKey = 'tapflow_last_timer_duration_seconds';

/// Stores and retrieves the user's most recent timer duration.
class TimerPreferences {
  static const int defaultDurationSeconds = 300; // 5 minutes initial fallback

  /// Returns the most recent timer duration in seconds (defaults to 300s if never set).
  static Future<int> getLastDuration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_kLastTimerDurationKey) ?? defaultDurationSeconds;
    } catch (_) {
      return defaultDurationSeconds;
    }
  }

  /// Persists the new timer duration in seconds as the new default.
  static Future<void> saveLastDuration(int seconds) async {
    if (seconds <= 0) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kLastTimerDurationKey, seconds);
    } catch (_) {}
  }
}
