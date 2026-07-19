import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';
import 'package:ndef_record/ndef_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfc_repository.g.dart';

/// Repository that wraps the [NfcManager] plugin API (v4.x).
///
/// Handles session lifecycle, NDEF reading, and NDEF writing using
/// platform-specific [NdefAndroid] and [NdefIos] classes.
class NfcRepository {
  /// Returns `true` when NFC hardware is present and enabled.
  Future<bool> isAvailable() async {
    final availability = await NfcManager.instance.checkAvailability();
    return availability == NfcAvailability.enabled;
  }

  /// Starts an NFC polling session.
  ///
  /// [onDiscovered] is called with every detected [NfcTag].
  /// Any errors during session setup are forwarded via [onError].
  Future<void> startSession({
    required void Function(NfcTag tag) onDiscovered,
    required void Function(String error) onError,
  }) async {
    try {
      final avail = await isAvailable();
      if (!avail) {
        onError('NFC is not available on this device');
        return;
      }

      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
        onDiscovered: (NfcTag tag) async {
          onDiscovered(tag);
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  /// Stops the current NFC polling session.
  Future<void> stopSession() async {
    try {
      await NfcManager.instance.stopSession();
    } catch (e) {
      debugPrint('Error stopping NFC session: $e');
    }
  }

  /// Writes an [NdefMessage] to [tag] on Android.
  ///
  /// Returns `false` if the tag is not NDEF-compatible or is read-only.
  Future<bool> writeNdefMessageAndroid(
    NfcTag tag,
    NdefMessage message,
  ) async {
    final ndef = NdefAndroid.from(tag);
    if (ndef == null) return false; // Not NDEF-compatible
    if (!ndef.isWritable) return false; // Read-only

    try {
      await ndef.writeNdefMessage(message);
      return true;
    } catch (e) {
      debugPrint('Error writing to tag (Android): $e');
      return false;
    }
  }

  /// Writes an [NdefMessage] to [tag] on iOS.
  ///
  /// Returns `false` if the tag is not NDEF-compatible.
  Future<bool> writeNdefMessageIos(NfcTag tag, NdefMessage message) async {
    final ndef = NdefIos.from(tag);
    if (ndef == null) return false;

    try {
      await ndef.writeNdef(message);
      return true;
    } catch (e) {
      debugPrint('Error writing to tag (iOS): $e');
      return false;
    }
  }

  /// Reads the cached [NdefMessage] from [tag], if available.
  /// Works on both Android and iOS.
  NdefMessage? readNdefMessage(NfcTag tag) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return NdefAndroid.from(tag)?.cachedNdefMessage;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return NdefIos.from(tag)?.cachedNdefMessage;
    }
    return null;
  }
}

@riverpod
NfcRepository nfcRepository(Ref ref) {
  return NfcRepository();
}
