// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenUrlAction _$OpenUrlActionFromJson(Map<String, dynamic> json) =>
    OpenUrlAction(
      url: json['url'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$OpenUrlActionToJson(OpenUrlAction instance) =>
    <String, dynamic>{'url': instance.url, 'runtimeType': instance.$type};

ShowNotificationAction _$ShowNotificationActionFromJson(
  Map<String, dynamic> json,
) => ShowNotificationAction(
  title: json['title'] as String,
  body: json['body'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$ShowNotificationActionToJson(
  ShowNotificationAction instance,
) => <String, dynamic>{
  'title': instance.title,
  'body': instance.body,
  'runtimeType': instance.$type,
};

LaunchAppAction _$LaunchAppActionFromJson(Map<String, dynamic> json) =>
    LaunchAppAction(
      packageName: json['packageName'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$LaunchAppActionToJson(LaunchAppAction instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'runtimeType': instance.$type,
    };

SetBrightnessAction _$SetBrightnessActionFromJson(Map<String, dynamic> json) =>
    SetBrightnessAction(
      level: (json['level'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SetBrightnessActionToJson(
  SetBrightnessAction instance,
) => <String, dynamic>{'level': instance.level, 'runtimeType': instance.$type};

_AutomationProfile _$AutomationProfileFromJson(Map<String, dynamic> json) =>
    _AutomationProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => AutomationAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$AutomationProfileToJson(_AutomationProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'actions': instance.actions,
      'isFavorite': instance.isFavorite,
    };
