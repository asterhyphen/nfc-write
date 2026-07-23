import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../domain/scan_record.dart';

part 'history_repository.g.dart';

const _kHistoryKey = 'tapflow_scan_history';
const _uuid = Uuid();

/// Local persistence layer for [ScanRecord]s using [SharedPreferences].
class HistoryRepository {
  final SharedPreferences _prefs;
  HistoryRepository(this._prefs);

  // ── Read ─────────────────────────────────────────────────────────────────

  List<ScanRecord> getAll() {
    final raw = _prefs.getStringList(_kHistoryKey) ?? [];
    return raw
        .map((e) => ScanRecord.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
  }

  List<ScanRecord> getFavorites() =>
      getAll().where((r) => r.isFavorite).toList();

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<ScanRecord> add({
    required String tagType,
    required String content,
    String? profileName,
  }) async {
    final record = ScanRecord(
      id: _uuid.v4(),
      scannedAt: DateTime.now(),
      tagType: tagType,
      content: content,
      profileName: profileName,
    );
    final all = getAll();
    all.insert(0, record);
    await _save(all);
    return record;
  }

  Future<void> toggleFavorite(String id) async {
    final all = getAll();
    final idx = all.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    all[idx] = all[idx].copyWith(isFavorite: !all[idx].isFavorite);
    await _save(all);
  }

  Future<void> delete(String id) async {
    final all = getAll()..removeWhere((r) => r.id == id);
    await _save(all);
  }

  Future<void> clearAll() async {
    await _prefs.remove(_kHistoryKey);
  }

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _save(List<ScanRecord> records) async {
    await _prefs.setStringList(
      _kHistoryKey,
      records.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }
}

@riverpod
Future<HistoryRepository> historyRepository(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return HistoryRepository(prefs);
}
