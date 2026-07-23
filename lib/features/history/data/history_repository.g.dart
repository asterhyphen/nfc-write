// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(historyRepository)
final historyRepositoryProvider = HistoryRepositoryProvider._();

final class HistoryRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<HistoryRepository>,
          HistoryRepository,
          FutureOr<HistoryRepository>
        >
    with
        $FutureModifier<HistoryRepository>,
        $FutureProvider<HistoryRepository> {
  HistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<HistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HistoryRepository> create(Ref ref) {
    return historyRepository(ref);
  }
}

String _$historyRepositoryHash() => r'aea552f4f7ca602ec135ceefc8f586a37655be07';
