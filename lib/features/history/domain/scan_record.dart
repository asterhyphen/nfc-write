import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_record.freezed.dart';
part 'scan_record.g.dart';

/// Represents a single historical NFC scan event stored locally.
@freezed
abstract class ScanRecord with _$ScanRecord {
  const factory ScanRecord({
    required String id,
    required DateTime scannedAt,
    required String tagType,
    required String content,
    @Default(false) bool isFavorite,
    String? profileName,
  }) = _ScanRecord;

  factory ScanRecord.fromJson(Map<String, dynamic> json) =>
      _$ScanRecordFromJson(json);
}
