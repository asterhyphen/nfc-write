// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_engine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(automationEngine)
final automationEngineProvider = AutomationEngineProvider._();

final class AutomationEngineProvider
    extends
        $FunctionalProvider<
          AutomationEngine,
          AutomationEngine,
          AutomationEngine
        >
    with $Provider<AutomationEngine> {
  AutomationEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'automationEngineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$automationEngineHash();

  @$internal
  @override
  $ProviderElement<AutomationEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AutomationEngine create(Ref ref) {
    return automationEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AutomationEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AutomationEngine>(value),
    );
  }
}

String _$automationEngineHash() => r'2fa8578718967a65a1506489413b63e989bbfa10';
