import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../history/data/history_repository.dart';
import '../../history/domain/scan_record.dart';
import '../../nfc_management/data/tag_registry_repository.dart';

part 'backup_service.g.dart';

class BackupService {
  final HistoryRepository _historyRepo;
  final TagRegistryRepository _tagRegistryRepo;

  BackupService(this._historyRepo, this._tagRegistryRepo);

  /// Exports all app data (scan history & tag registry) into a JSON string.
  Future<String> exportBackupJson() async {
    final history = _historyRepo.getAll().map((r) => r.toJson()).toList();
    final tagNames = _tagRegistryRepo.getAllTagNames();

    final backupData = {
      'app': 'TapFlow',
      'version': '1.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'history': history,
      'tagRegistry': tagNames,
    };

    return const JsonEncoder.withIndent('  ').convert(backupData);
  }

  /// Restores app data from a backup JSON string.
  ///
  /// Returns `true` on success, throws [FormatException] if invalid JSON.
  Future<bool> restoreBackupJson(String jsonStr) async {
    final Map<String, dynamic> data = jsonDecode(jsonStr);

    if (data['app'] != 'TapFlow') {
      throw const FormatException(
        'Invalid backup file. App signature mismatch.',
      );
    }

    // Restore history
    if (data.containsKey('history') && data['history'] is List) {
      final List<dynamic> list = data['history'];
      final records = list
          .map((e) => ScanRecord.fromJson(e as Map<String, dynamic>))
          .toList();

      final existing = _historyRepo.getAll();
      final existingIds = existing.map((r) => r.id).toSet();

      for (final r in records) {
        if (!existingIds.contains(r.id)) {
          await _historyRepo.add(
            tagType: r.tagType,
            content: r.content,
            profileName: r.profileName,
          );
        }
      }
    }

    // Restore tag registry
    if (data.containsKey('tagRegistry') && data['tagRegistry'] is Map) {
      final Map<String, dynamic> reg = data['tagRegistry'];
      for (final entry in reg.entries) {
        await _tagRegistryRepo.setTagName(entry.key, entry.value.toString());
      }
    }

    return true;
  }
}

@riverpod
Future<BackupService> backupService(Ref ref) async {
  final historyRepo = await ref.watch(historyRepositoryProvider.future);
  final tagRegistryRepo = await ref.watch(tagRegistryRepositoryProvider.future);
  return BackupService(historyRepo, tagRegistryRepo);
}
