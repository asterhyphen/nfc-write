import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndef_record/ndef_record.dart';

import '../data/nfc_repository.dart';

/// Supported NDEF write record types.
enum WriteType { text, url, email, phone, sms }

/// Bottom sheet for composing and writing an NDEF record to a tag.
class NfcWriteSheet extends ConsumerStatefulWidget {
  const NfcWriteSheet({super.key});

  @override
  ConsumerState<NfcWriteSheet> createState() => _NfcWriteSheetState();
}

class _NfcWriteSheetState extends ConsumerState<NfcWriteSheet> {
  WriteType _type = WriteType.text;
  final _contentCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _WriteState _state = _WriteState.composing;
  String? _errorMessage;

  @override
  void dispose() {
    _contentCtrl.dispose();
    ref.read(nfcRepositoryProvider).stopSession();
    super.dispose();
  }

  Future<void> _startWrite() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _state = _WriteState.waiting);

    final repo = ref.read(nfcRepositoryProvider);
    final available = await repo.isAvailable();
    if (!available) {
      if (mounted) {
        setState(() {
          _state = _WriteState.error;
          _errorMessage = 'NFC is not available on this device.';
        });
      }
      return;
    }

    await repo.startSession(
      onDiscovered: (tag) async {
        if (!mounted) return;
        final message = _buildMessage();
        bool ok = false;
        try {
          if (Theme.of(context).platform == TargetPlatform.android) {
            ok = await repo.writeNdefMessageAndroid(tag, message);
          } else {
            ok = await repo.writeNdefMessageIos(tag, message);
          }
        } catch (e) {
          ok = false;
          _errorMessage = e.toString();
        }
        await repo.stopSession();
        if (mounted) {
          setState(() {
            _state = ok ? _WriteState.success : _WriteState.error;
            if (!ok) _errorMessage ??= 'Failed to write to tag.';
          });
        }
      },
      onError: (msg) {
        if (mounted) {
          setState(() {
            _state = _WriteState.error;
            _errorMessage = msg;
          });
        }
      },
    );
  }

  NdefMessage _buildMessage() {
    final content = _contentCtrl.text.trim();
    NdefRecord record;

    switch (_type) {
      case WriteType.text:
        final langBytes = utf8.encode('en');
        final textBytes = utf8.encode(content);
        final payload = Uint8List.fromList([
          langBytes.length,
          ...langBytes,
          ...textBytes,
        ]);
        record = NdefRecord(
          typeNameFormat: TypeNameFormat.wellKnown,
          type: Uint8List.fromList([0x54]), // 'T'
          identifier: Uint8List(0),
          payload: payload,
        );
        break;

      case WriteType.url:
      case WriteType.email:
      case WriteType.phone:
      case WriteType.sms:
        String uriStr = content;
        if (_type == WriteType.email && !uriStr.startsWith('mailto:')) {
          uriStr = 'mailto:$uriStr';
        } else if (_type == WriteType.phone && !uriStr.startsWith('tel:')) {
          uriStr = 'tel:$uriStr';
        } else if (_type == WriteType.sms && !uriStr.startsWith('sms:')) {
          uriStr = 'sms:$uriStr';
        }
        final uriBytes = utf8.encode(uriStr);
        final payload = Uint8List.fromList([
          0x00, // Prefix code 0x00 = no prefix
          ...uriBytes,
        ]);
        record = NdefRecord(
          typeNameFormat: TypeNameFormat.wellKnown,
          type: Uint8List.fromList([0x55]), // 'U'
          identifier: Uint8List(0),
          payload: payload,
        );
        break;
    }

    return NdefMessage(records: [record]);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
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
    return switch (_state) {
      _WriteState.composing => _ComposingForm(
        formKey: _formKey,
        type: _type,
        contentCtrl: _contentCtrl,
        onTypeChanged: (t) => setState(() => _type = t),
        onSubmit: _startWrite,
      ),
      _WriteState.waiting => _WaitingToWrite(),
      _WriteState.success => _WriteSuccess(onClose: () => Navigator.pop(context)),
      _WriteState.error => _WriteError(
        message: _errorMessage ?? 'Unknown error',
        onRetry: () => setState(() => _state = _WriteState.composing),
      ),
    };
  }
}

enum _WriteState { composing, waiting, success, error }

// ── Composing ─────────────────────────────────────────────────────────────────

class _ComposingForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final WriteType type;
  final TextEditingController contentCtrl;
  final void Function(WriteType) onTypeChanged;
  final VoidCallback onSubmit;

  const _ComposingForm({
    required this.formKey,
    required this.type,
    required this.contentCtrl,
    required this.onTypeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write NFC Tag',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Select a type and enter content to write.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),

          // Type chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: WriteType.values.map((t) {
                final selected = t == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_label(t)),
                    selected: selected,
                    onSelected: (_) => onTypeChanged(t),
                    avatar: Icon(_icon(t), size: 16),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: contentCtrl,
            maxLines: _isMultiline(type) ? 4 : 1,
            decoration: InputDecoration(
              labelText: _fieldLabel(type),
              hintText: _hint(type),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              prefixIcon: Icon(_icon(type)),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter some content'
                : null,
            keyboardType: _keyboardType(type),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.nfc_rounded),
              label: const Text('Write to Tag'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  String _label(WriteType t) => switch (t) {
    WriteType.text => 'Text',
    WriteType.url => 'URL',
    WriteType.email => 'Email',
    WriteType.phone => 'Phone',
    WriteType.sms => 'SMS',
  };

  IconData _icon(WriteType t) => switch (t) {
    WriteType.text => Icons.text_fields,
    WriteType.url => Icons.link,
    WriteType.email => Icons.email,
    WriteType.phone => Icons.phone,
    WriteType.sms => Icons.sms,
  };

  String _fieldLabel(WriteType t) => switch (t) {
    WriteType.text => 'Text content',
    WriteType.url => 'URL',
    WriteType.email => 'Email address',
    WriteType.phone => 'Phone number',
    WriteType.sms => 'Phone number',
  };

  String _hint(WriteType t) => switch (t) {
    WriteType.text => 'Enter your message…',
    WriteType.url => 'https://example.com',
    WriteType.email => 'user@example.com',
    WriteType.phone => '+1 555 000 0000',
    WriteType.sms => '+1 555 000 0000',
  };

  bool _isMultiline(WriteType t) => t == WriteType.text;

  TextInputType _keyboardType(WriteType t) => switch (t) {
    WriteType.url => TextInputType.url,
    WriteType.email => TextInputType.emailAddress,
    WriteType.phone || WriteType.sms => TextInputType.phone,
    _ => TextInputType.text,
  };
}

// ── Waiting ───────────────────────────────────────────────────────────────────

class _WaitingToWrite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 32),
        Icon(Icons.nfc_rounded, size: 80, color: cs.primary)
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1500.ms),
        const SizedBox(height: 24),
        Text(
          'Ready to write…',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Hold your phone near an NFC tag to write.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
      ],
    );
  }
}

// ── Success ───────────────────────────────────────────────────────────────────

class _WriteSuccess extends StatelessWidget {
  final VoidCallback onClose;
  const _WriteSuccess({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.check, color: Colors.green, size: 44),
        ).animate().scale(begin: const Offset(0.4, 0.4)).fadeIn(),
        const SizedBox(height: 20),
        Text(
          'Written Successfully!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 8),
        Text(
          'The NDEF record was written to the tag.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: onClose,
          icon: const Icon(Icons.done),
          label: const Text('Done'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _WriteError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _WriteError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 32),
        CircleAvatar(
          radius: 40,
          backgroundColor: cs.errorContainer,
          child: Icon(Icons.error_outline, color: cs.error, size: 44),
        ).animate().scale(begin: const Offset(0.4, 0.4)).fadeIn(),
        const SizedBox(height: 20),
        Text(
          'Write Failed',
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
          icon: const Icon(Icons.arrow_back),
          label: const Text('Edit & Retry'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
