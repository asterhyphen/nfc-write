import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ndef_record/ndef_record.dart';

import '../../../core/widgets/glass_card.dart';
import '../data/nfc_repository.dart';

/// What the scan sheet should do when a tag is detected.
enum NfcSheetMode { read, erase, inspect }

/// Thin domain object passed back to the caller after a successful scan.
class ScannedTagResult {
  final String tagType;
  final String content;
  ScannedTagResult({required this.tagType, required this.content});
}

/// A modal bottom sheet that starts an NFC session and reacts to discovered tags.
class NfcScanSheet extends ConsumerStatefulWidget {
  final NfcSheetMode mode;
  final void Function(ScannedTagResult result) onRecordSaved;

  const NfcScanSheet({
    super.key,
    required this.mode,
    required this.onRecordSaved,
  });

  @override
  ConsumerState<NfcScanSheet> createState() => _NfcScanSheetState();
}

class _NfcScanSheetState extends ConsumerState<NfcScanSheet> {
  _ScanState _state = _ScanState.waiting;
  String? _errorMessage;
  ScannedTagResult? _result;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  void dispose() {
    // Always stop the session when the sheet closes
    ref.read(nfcRepositoryProvider).stopSession();
    super.dispose();
  }

  Future<void> _startSession() async {
    final repo = ref.read(nfcRepositoryProvider);

    final available = await repo.isAvailable();
    if (!available) {
      if (mounted) {
        setState(() {
          _state = _ScanState.error;
          _errorMessage = 'NFC is not available on this device.';
        });
      }
      return;
    }

    await repo.startSession(
      onDiscovered: (tag) async {
        if (!mounted) return;
        await _handleTag(tag);
      },
      onError: (msg) {
        if (mounted) {
          setState(() {
            _state = _ScanState.error;
            _errorMessage = msg;
          });
        }
      },
    );
  }

  Future<void> _handleTag(NfcTag tag) async {
    final repo = ref.read(nfcRepositoryProvider);

    switch (widget.mode) {
      case NfcSheetMode.read:
      case NfcSheetMode.inspect:
        final msg = repo.readNdefMessage(tag);
        final result = _parseMessage(msg);
        await repo.stopSession();
        if (mounted) {
          setState(() {
            _state = _ScanState.success;
            _result = result;
          });
          widget.onRecordSaved(result);
        }
        break;

      case NfcSheetMode.erase:
        // Write an empty NDEF message to erase
        final emptyMsg = NdefMessage(records: []);
        bool ok = false;
        try {
          if (Theme.of(context).platform == TargetPlatform.android) {
            ok = await repo.writeNdefMessageAndroid(tag, emptyMsg);
          } else {
            ok = await repo.writeNdefMessageIos(tag, emptyMsg);
          }
        } catch (_) {
          ok = false;
        }
        await repo.stopSession();
        if (mounted) {
          setState(() {
            _state = ok ? _ScanState.success : _ScanState.error;
            if (ok) {
              _result = ScannedTagResult(tagType: 'Erased', content: '(empty)');
            } else {
              _errorMessage = 'Could not erase this tag.';
            }
          });
        }
        break;
    }
  }

  ScannedTagResult _parseMessage(NdefMessage? msg) {
    if (msg == null || msg.records.isEmpty) {
      return ScannedTagResult(tagType: 'Empty', content: '(no NDEF data)');
    }

    final record = msg.records.first;
    final tnf = record.typeNameFormat;

    if (tnf == TypeNameFormat.wellKnown) {
      final typeStr = String.fromCharCodes(record.type);
      if (typeStr == 'T') {
        // Text record
        final payload = record.payload;
        final langLen = payload[0] & 0x3F;
        final text = String.fromCharCodes(payload.sublist(1 + langLen));
        return ScannedTagResult(tagType: 'Text', content: text);
      } else if (typeStr == 'U') {
        // URI record
        final prefix = _uriPrefixes[record.payload[0]] ?? '';
        final uri = prefix + String.fromCharCodes(record.payload.sublist(1));
        return ScannedTagResult(tagType: 'URL', content: uri);
      }
    } else if (tnf == TypeNameFormat.media) {
      final mimeType = String.fromCharCodes(record.type);
      return ScannedTagResult(
        tagType: mimeType,
        content: String.fromCharCodes(record.payload),
      );
    }

    // Fallback: raw hex
    final hex = record.payload
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(' ');
    return ScannedTagResult(tagType: 'Raw', content: hex);
  }

  static const _uriPrefixes = {
    0x00: '',
    0x01: 'http://www.',
    0x02: 'https://www.',
    0x03: 'http://',
    0x04: 'https://',
    0x05: 'tel:',
    0x06: 'mailto:',
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: ctrl,
                padding: const EdgeInsets.all(24),
                child: _body(cs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(ColorScheme cs) {
    switch (_state) {
      case _ScanState.waiting:
        return _WaitingState(mode: widget.mode);
      case _ScanState.success:
        return _SuccessState(result: _result!);
      case _ScanState.error:
        return _ErrorState(
          message: _errorMessage ?? 'Unknown error',
          onRetry: () {
            setState(() {
              _state = _ScanState.waiting;
              _errorMessage = null;
            });
            _startSession();
          },
        );
    }
  }
}

enum _ScanState { waiting, success, error }

class _WaitingState extends StatelessWidget {
  final NfcSheetMode mode;
  const _WaitingState({required this.mode});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (label, icon) = switch (mode) {
      NfcSheetMode.read => ('Waiting to read tag…', Icons.nfc_rounded),
      NfcSheetMode.erase => ('Waiting to erase tag…', Icons.delete_sweep_rounded),
      NfcSheetMode.inspect => ('Waiting to inspect tag…', Icons.search_rounded),
    };

    return Column(
      children: [
        const SizedBox(height: 20),
        Icon(icon, size: 80, color: cs.primary)
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1500.ms)
            .then()
            .scaleXY(
              begin: 1,
              end: 1.08,
              duration: 700.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scaleXY(
              begin: 1.08,
              end: 1,
              duration: 700.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 24),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Hold your phone near an NFC tag.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  final ScannedTagResult result;
  const _SuccessState({required this.result});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.check_circle, color: Colors.green, size: 40),
        ).animate().scale(begin: const Offset(0.5, 0.5)).fadeIn(),
        const SizedBox(height: 20),
        Text(
          'Tag ${result.tagType == 'Erased' ? 'Erased' : 'Read'} Successfully',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(result.tagType, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),
              Text(
                'Content',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                result.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        const SizedBox(height: 20),
        Text(
          'Saved to history.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 36,
          backgroundColor: cs.errorContainer,
          child: Icon(Icons.error_outline, color: cs.error, size: 40),
        ).animate().scale(begin: const Offset(0.5, 0.5)).fadeIn(),
        const SizedBox(height: 20),
        Text(
          'Something went wrong',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Try Again'),
        ),
      ],
    );
  }
}
