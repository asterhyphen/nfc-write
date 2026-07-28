import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfc_template.freezed.dart';
part 'nfc_template.g.dart';

/// Pre-built or custom NFC template representation.
@freezed
abstract class NfcTemplate with _$NfcTemplate {
  const factory NfcTemplate({
    required String id,
    required String title,
    required String description,
    required String category, // 'Network', 'Social', 'Contact', 'Utility', 'Automation'
    required String payloadType, // 'wifi', 'vcard', 'url', 'timer', 'text'
    required String defaultPayload,
    required String iconName,
    @Default(false) bool isCustom,
  }) = _NfcTemplate;

  factory NfcTemplate.fromJson(Map<String, dynamic> json) =>
      _$NfcTemplateFromJson(json);
}
