// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanRecord _$ScanRecordFromJson(Map<String, dynamic> json) => _ScanRecord(
  id: json['id'] as String,
  scannedAt: DateTime.parse(json['scannedAt'] as String),
  tagType: json['tagType'] as String,
  content: json['content'] as String,
  isFavorite: json['isFavorite'] as bool? ?? false,
  profileName: json['profileName'] as String?,
);

Map<String, dynamic> _$ScanRecordToJson(_ScanRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scannedAt': instance.scannedAt.toIso8601String(),
      'tagType': instance.tagType,
      'content': instance.content,
      'isFavorite': instance.isFavorite,
      'profileName': instance.profileName,
    };
