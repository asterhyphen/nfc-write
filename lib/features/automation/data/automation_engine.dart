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
      );
      // Add a small delay between actions if needed
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _executeOpenUrl(String url) async {
    debugPrint('Opening URL: $url');
    // Implement using url_launcher
  }

  Future<void> _executeNotification(String title, String body) async {
    debugPrint('Showing Notification: $title - $body');
    // Implement using flutter_local_notifications
  }

  Future<void> _executeLaunchApp(String packageName) async {
    debugPrint('Launching App: $packageName');
    // Implement using url_launcher or app_launcher
  }

  Future<void> _executeSetBrightness(double level) async {
    debugPrint('Setting Brightness: $level');
    // Implement using screen_brightness
  }
}

@riverpod
AutomationEngine automationEngine(Ref ref) {
  return AutomationEngine();
}
