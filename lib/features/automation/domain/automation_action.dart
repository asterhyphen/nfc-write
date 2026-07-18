import 'package:freezed_annotation/freezed_annotation.dart';

part 'automation_action.freezed.dart';
part 'automation_action.g.dart';

@freezed
class AutomationAction with _$AutomationAction {
  const factory AutomationAction.openUrl({required String url}) = OpenUrlAction;
  const factory AutomationAction.showNotification({
    required String title,
    required String body,
  }) = ShowNotificationAction;
  const factory AutomationAction.launchApp({required String packageName}) =
      LaunchAppAction;
  const factory AutomationAction.setBrightness({required double level}) =
      SetBrightnessAction;

  factory AutomationAction.fromJson(Map<String, dynamic> json) =>
      _$AutomationActionFromJson(json);
}

@freezed
class AutomationProfile with _$AutomationProfile {
  const factory AutomationProfile({
    required String id,
    required String name,
    required List<AutomationAction> actions,
    @Default(false) bool isFavorite,
  }) = _AutomationProfile;

  factory AutomationProfile.fromJson(Map<String, dynamic> json) =>
      _$AutomationProfileFromJson(json);
}
