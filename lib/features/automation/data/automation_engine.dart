import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/automation_action.dart';

part 'automation_engine.g.dart';

class AutomationEngine {
  Future<void> executeProfile(AutomationProfile profile) async {
    debugPrint('Executing profile: ${profile.name}');
  }
}

@riverpod
AutomationEngine automationEngine(Ref ref) {
  return AutomationEngine();
}
