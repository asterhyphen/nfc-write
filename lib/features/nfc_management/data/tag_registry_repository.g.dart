// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_registry_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tagRegistryRepository)
final tagRegistryRepositoryProvider = TagRegistryRepositoryProvider._();

final class TagRegistryRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<TagRegistryRepository>,
          TagRegistryRepository,
          FutureOr<TagRegistryRepository>
        >
    with
        $FutureModifier<TagRegistryRepository>,
        $FutureProvider<TagRegistryRepository> {
  TagRegistryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagRegistryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagRegistryRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<TagRegistryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TagRegistryRepository> create(Ref ref) {
    return tagRegistryRepository(ref);
  }
}

String _$tagRegistryRepositoryHash() =>
    r'651e549e644332f1c4842003063ec7332a238421';
