import 'package:freezed_annotation/freezed_annotation.dart';

part 'automation_action.freezed.dart';
part 'automation_action.g.dart';

/// A sealed union representing all supported automation actions.
///
/// Use [map]/[when]/[maybeMap] to handle each variant exhaustively.
@freezed
sealed class AutomationAction with _$AutomationAction {
  /// Opens a URL in the default browser.
  const factory AutomationAction.openUrl({required String url}) = OpenUrlAction;

  /// Shows a local notification with [title] and [body].
  const factory AutomationAction.showNotification({
    required String title,
    required String body,
  }) = ShowNotificationAction;

  /// Launches an installed app by its [packageName] (Android) or URL scheme (iOS).
  const factory AutomationAction.launchApp({required String packageName}) =
      LaunchAppAction;

  /// Sets screen brightness to the given [level] (0.0 – 1.0).
  const factory AutomationAction.setBrightness({required double level}) =
      SetBrightnessAction;

  factory AutomationAction.fromJson(Map<String, dynamic> json) =>
      _$AutomationActionFromJson(json);
}

/// An automation profile that associates a name with an ordered list of [actions].
@freezed
abstract class AutomationProfile with _$AutomationProfile {
  const factory AutomationProfile({
    required String id,
    required String name,
    required List<AutomationAction> actions,
    @Default(false) bool isFavorite,
  }) = _AutomationProfile;

  factory AutomationProfile.fromJson(Map<String, dynamic> json) =>
      _$AutomationProfileFromJson(json);
}
