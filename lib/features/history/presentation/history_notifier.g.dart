// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the in-memory list of [ScanRecord]s and delegates persistence to
/// [HistoryRepository].

@ProviderFor(HistoryNotifier)
final historyProvider = HistoryNotifierProvider._();

/// Manages the in-memory list of [ScanRecord]s and delegates persistence to
/// [HistoryRepository].
final class HistoryNotifierProvider
    extends $AsyncNotifierProvider<HistoryNotifier, List<ScanRecord>> {
  /// Manages the in-memory list of [ScanRecord]s and delegates persistence to
  /// [HistoryRepository].
  HistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyNotifierHash();

  @$internal
  @override
  HistoryNotifier create() => HistoryNotifier();
}

String _$historyNotifierHash() => r'56d5530b01b60173eafd320dd65708bd25fc324f';

/// Manages the in-memory list of [ScanRecord]s and delegates persistence to
/// [HistoryRepository].

abstract class _$HistoryNotifier extends $AsyncNotifier<List<ScanRecord>> {
  FutureOr<List<ScanRecord>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ScanRecord>>, List<ScanRecord>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ScanRecord>>, List<ScanRecord>>,
              AsyncValue<List<ScanRecord>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
