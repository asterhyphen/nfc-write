// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfc_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nfcRepository)
final nfcRepositoryProvider = NfcRepositoryProvider._();

final class NfcRepositoryProvider
    extends $FunctionalProvider<NfcRepository, NfcRepository, NfcRepository>
    with $Provider<NfcRepository> {
  NfcRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nfcRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nfcRepositoryHash();

  @$internal
  @override
  $ProviderElement<NfcRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NfcRepository create(Ref ref) {
    return nfcRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NfcRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NfcRepository>(value),
    );
  }
}

String _$nfcRepositoryHash() => r'0761284496ba0358fee04b56434f555993846054';
