// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfc_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NfcTemplate _$NfcTemplateFromJson(Map<String, dynamic> json) => _NfcTemplate(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  payloadType: json['payloadType'] as String,
  defaultPayload: json['defaultPayload'] as String,
  iconName: json['iconName'] as String,
  isCustom: json['isCustom'] as bool? ?? false,
);

Map<String, dynamic> _$NfcTemplateToJson(_NfcTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'payloadType': instance.payloadType,
      'defaultPayload': instance.defaultPayload,
      'iconName': instance.iconName,
      'isCustom': instance.isCustom,
    };
