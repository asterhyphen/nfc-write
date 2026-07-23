import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../history/data/history_repository.dart';
import '../../history/domain/scan_record.dart';

part 'history_notifier.g.dart';

/// Manages the in-memory list of [ScanRecord]s and delegates persistence to
/// [HistoryRepository].
@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  @override
  Future<List<ScanRecord>> build() async {
    final repo = await ref.watch(historyRepositoryProvider.future);
    return repo.getAll();
  }

  Future<ScanRecord> addRecord({
    required String tagType,
    required String content,
    String? profileName,
  }) async {
    final repo = await ref.read(historyRepositoryProvider.future);
    final record = await repo.add(
      tagType: tagType,
      content: content,
      profileName: profileName,
    );
    ref.invalidateSelf();
    return record;
  }

  Future<void> toggleFavorite(String id) async {
    final repo = await ref.read(historyRepositoryProvider.future);
    await repo.toggleFavorite(id);
    ref.invalidateSelf();
  }

  Future<void> deleteRecord(String id) async {
    final repo = await ref.read(historyRepositoryProvider.future);
    await repo.delete(id);
    ref.invalidateSelf();
  }

  Future<void> clearAll() async {
    final repo = await ref.read(historyRepositoryProvider.future);
    await repo.clearAll();
    ref.invalidateSelf();
  }
}
