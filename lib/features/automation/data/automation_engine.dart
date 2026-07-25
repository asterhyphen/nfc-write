import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/automation_action.dart';

part 'automation_engine.g.dart';

class AutomationEngine {
  Future<void> executeProfile(AutomationProfile profile) async {
    debugPrint('Executing profile: ${profile.name}');
    for (final action in profile.actions) {
      await action.map(
        openUrl: (a) => _executeOpenUrl(a.url),
        showNotification: (a) => _executeNotification(a.title, a.body),
        launchApp: (a) => _executeLaunchApp(a.packageName),
        setBrightness: (a) => _executeSetBrightness(a.level),
        delayTimer: (a) => _executeDelayTimer(a.seconds, a.label),
      );
      // Add a small delay between actions if needed
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _executeOpenUrl(String url) async {
    debugPrint('Opening URL: $url');
  }

  Future<void> _executeNotification(String title, String body) async {
    debugPrint('Showing Notification: $title - $body');
  }

  Future<void> _executeLaunchApp(String packageName) async {
    debugPrint('Launching App: $packageName');
  }

  Future<void> _executeSetBrightness(double level) async {
    debugPrint('Setting Brightness: $level');
  }

  Future<void> _executeDelayTimer(int seconds, String? label) async {
    debugPrint('Starting Delay Timer (${label ?? "Timer"}): $seconds seconds');
    await Future.delayed(Duration(seconds: seconds));
    debugPrint('Delay Timer Finished: ${label ?? "Timer"}');
  }
}

@riverpod
AutomationEngine automationEngine(Ref ref) {
  return AutomationEngine();
}
