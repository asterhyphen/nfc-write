import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfc_repository.g.dart';

class NfcRepository {
  Future<bool> isAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  Future<void> startSession({
    required Function(NfcTag tag) onDiscovered,
    required Function(String error) onError,
  }) async {
    try {
      bool isAvail = await isAvailable();
      if (!isAvail) {
        onError('NFC is not available on this device');
        return;
      }

      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          onDiscovered(tag);
        },
        onError: (NfcError error) async {
          onError(error.message);
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> stopSession() async {
    try {
      await NfcManager.instance.stopSession();
    } catch (e) {
      debugPrint('Error stopping NFC session: $e');
    }
  }

  Future<bool> writeNdefMessage(NfcTag tag, NdefMessage message) async {
    final ndef = Ndef.from(tag);
    if (ndef == null) {
      return false; // Tag is not NDEF formatted
    }

    if (!ndef.isWritable) {
      return false;
    }

    try {
      await ndef.write(message);
      return true;
    } catch (e) {
      debugPrint('Error writing to tag: $e');
      return false;
    }
  }
}

@riverpod
NfcRepository nfcRepository(NfcRepositoryRef ref) {
  return NfcRepository();
}
