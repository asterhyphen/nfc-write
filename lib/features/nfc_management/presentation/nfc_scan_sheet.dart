import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndef_record/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/glass_card.dart';
import '../../automation/presentation/flip_clock_timer_screen.dart';
import '../../automation/presentation/timer_notifier.dart';
import '../data/nfc_repository.dart';
import '../data/tag_registry_repository.dart';

/// What the scan sheet should do when a tag is detected.
enum NfcSheetMode { read, erase, inspect }

/// Domain result object for a scanned NFC tag with custom name and action.
class ScannedTagResult {
  final String tagType;
  final String content;
  String? tagName;
  final String actionLabel;
  final IconData actionIcon;

  ScannedTagResult({
    required this.tagType,
    required this.content,
    this.tagName,
    required this.actionLabel,
    required this.actionIcon,
  });
}

/// Modal bottom sheet for reading, inspecting, and executing NFC tag actions.
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
  final TextEditingController _nameEditCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  void dispose() {
    _nameEditCtrl.dispose();
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

        // Fetch assigned tag name from registry if any
        final tagRegistry = await ref.read(
          tagRegistryRepositoryProvider.future,
        );
        final savedName = tagRegistry.getTagName(result.content);
        if (savedName != null && savedName.isNotEmpty) {
          result.tagName = savedName;
        }

        await repo.stopSession();
        if (mounted) {
          setState(() {
            _state = _ScanState.success;
            _result = result;
            _nameEditCtrl.text = result.tagName ?? '';
          });
          widget.onRecordSaved(result);
        }
        break;

      case NfcSheetMode.erase:
        final emptyMsg = const NdefMessage(records: []);
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
              _result = ScannedTagResult(
                tagType: 'Erased',
                content: '(empty)',
                actionLabel: 'Tag Cleared',
                actionIcon: Icons.cleaning_services_rounded,
              );
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
      return ScannedTagResult(
        tagType: 'Empty',
        content: '(no NDEF data)',
        actionLabel: 'No Action Available',
        actionIcon: Icons.help_outline_rounded,
      );
    }

    final record = msg.records.first;
    final tnf = record.typeNameFormat;

    if (tnf == TypeNameFormat.wellKnown) {
      final typeStr = String.fromCharCodes(record.type);
      if (typeStr == 'T') {
        final payload = record.payload;
        final langLen = payload[0] & 0x3F;
        final text = String.fromCharCodes(payload.sublist(1 + langLen));

        // Check if content is a timer payload
        if (text.startsWith('timer://')) {
          final secs = int.tryParse(text.replaceFirst('timer://', '')) ?? 300;
          return ScannedTagResult(
            tagType: 'Timer',
            content: text,
            actionLabel: 'Launch ${secs ~/ 60} Min Timer',
            actionIcon: Icons.timer_rounded,
          );
        } else if (text.startsWith('notification://')) {
          final uri = Uri.parse(text);
          final title = uri.queryParameters['title'] ?? 'Notification';
          return ScannedTagResult(
            tagType: 'Notification',
            content: text,
            actionLabel: 'Trigger Notification "$title"',
            actionIcon: Icons.notifications_active_rounded,
          );
        } else if (text.startsWith('dnd://')) {
          final uri = Uri.parse(text);
          final state = uri.queryParameters['state'] ?? 'toggle';
          return ScannedTagResult(
            tagType: 'Do Not Disturb',
            content: text,
            actionLabel: 'Switch DND: ${state.toUpperCase()}',
            actionIcon: Icons.do_not_disturb_on_rounded,
          );
        }

        return ScannedTagResult(
          tagType: 'Text',
          content: text,
          actionLabel: 'Copy Text',
          actionIcon: Icons.copy_rounded,
        );
      } else if (typeStr == 'U') {
        final prefix = _uriPrefixes[record.payload[0]] ?? '';
        final uri = prefix + String.fromCharCodes(record.payload.sublist(1));

        if (uri.startsWith('mailto:')) {
          return ScannedTagResult(
            tagType: 'Email',
            content: uri.replaceFirst('mailto:', ''),
            actionLabel: 'Compose Email',
            actionIcon: Icons.email_rounded,
          );
        } else if (uri.startsWith('tel:')) {
          return ScannedTagResult(
            tagType: 'Phone',
            content: uri.replaceFirst('tel:', ''),
            actionLabel: 'Call Phone Number',
            actionIcon: Icons.phone_rounded,
          );
        } else if (uri.startsWith('sms:')) {
          return ScannedTagResult(
            tagType: 'SMS',
            content: uri.replaceFirst('sms:', ''),
            actionLabel: 'Send SMS Message',
            actionIcon: Icons.sms_rounded,
          );
        }

        return ScannedTagResult(
          tagType: 'URL',
          content: uri,
          actionLabel: 'Open Link in Browser',
          actionIcon: Icons.open_in_browser_rounded,
        );
      }
    } else if (tnf == TypeNameFormat.media) {
      final mimeType = String.fromCharCodes(record.type);
      return ScannedTagResult(
        tagType: mimeType,
        content: String.fromCharCodes(record.payload),
        actionLabel: 'View Data',
        actionIcon: Icons.file_present_rounded,
      );
    }

    final hex = record.payload
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(' ');
    return ScannedTagResult(
      tagType: 'Raw Data',
      content: hex,
      actionLabel: 'Copy Bytes',
      actionIcon: Icons.data_object_rounded,
    );
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

  Future<void> _saveTagName(String newName) async {
    if (_result == null) return;
    final tagRegistry = await ref.read(tagRegistryRepositoryProvider.future);
    if (newName.trim().isEmpty) {
      await tagRegistry.removeTagName(_result!.content);
      setState(() {
        _result!.tagName = null;
      });
    } else {
      await tagRegistry.setTagName(_result!.content, newName);
      setState(() {
        _result!.tagName = newName.trim();
      });
    }
  }

  Future<void> _executeAction() async {
    if (_result == null) return;
    final res = _result!;
    final cs = Theme.of(context).colorScheme;

    if (res.tagType == 'URL' ||
        res.content.startsWith('http://') ||
        res.content.startsWith('https://')) {
      final url = Uri.parse(
        res.content.startsWith('http') ? res.content : 'https://${res.content}',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else if (res.tagType == 'Timer' || res.content.startsWith('timer://')) {
      final secs =
          int.tryParse(res.content.replaceFirst('timer://', '')) ?? 300;
      if (mounted) {
        Navigator.pop(context);
        ref
            .read(timerProvider.notifier)
            .start(secs, res.tagName ?? 'NFC Timer Action');
        Navigator.push(context, FlipClockTimerScreen.route());
      }
    } else if (res.content.startsWith('notification://')) {
      final uri = Uri.parse(res.content);
      final title = uri.queryParameters['title'] ?? 'NFC Notification';
      final body =
          uri.queryParameters['body'] ?? 'Automation Action Completed!';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: cs.primary,
            content: Row(
              children: [
                const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else if (res.content.startsWith('dnd://')) {
      final uri = Uri.parse(res.content);
      final state = uri.queryParameters['state'] ?? 'toggle';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: cs.secondary,
            content: Row(
              children: [
                const Icon(
                  Icons.do_not_disturb_on_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Text(
                  'Do Not Disturb: ${state.toUpperCase()} Activated!',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else if (res.tagType == 'Email') {
      final url = Uri.parse('mailto:${res.content}');
      if (await canLaunchUrl(url)) await launchUrl(url);
    } else if (res.tagType == 'Phone') {
      final url = Uri.parse('tel:${res.content}');
      if (await canLaunchUrl(url)) await launchUrl(url);
    } else if (res.tagType == 'SMS') {
      final url = Uri.parse('sms:${res.content}');
      if (await canLaunchUrl(url)) await launchUrl(url);
    } else {
      // Default: copy content to clipboard
      await Clipboard.setData(ClipboardData(text: res.content));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copied "${res.content}" to clipboard')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
    switch (_state) {
      case _ScanState.waiting:
        return _WaitingState(mode: widget.mode);
      case _ScanState.success:
        return _buildSuccessView(cs);
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

  Widget _buildSuccessView(ColorScheme cs) {
    final res = _result!;
    final hasCustomName = res.tagName != null && res.tagName!.isNotEmpty;

    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF22C55E), width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF22C55E),
                size: 40,
              ),
            )
            .animate()
            .scale(
              duration: 400.ms,
              curve: Curves.easeOutBack, // overshoot spring easing
              begin: const Offset(0.5, 0.5),
            )
            .fadeIn(),

        const SizedBox(height: 16),
        Text(
          'Tag Read Successfully',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        // Custom Tag Name / Identifier Badge & Edit Button
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sell_rounded, size: 18, color: cs.primary),
                      const SizedBox(width: 8),
                      Text(
                        'TAG IDENTIFIER',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded, size: 20),
                    tooltip: 'Assign Name / Alias',
                    onPressed: _showAssignNameDialog,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                hasCustomName
                    ? res.tagName!
                    : 'Unnamed Tag (Tap edit to assign name)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: hasCustomName ? cs.onSurface : cs.outline,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.15),

        const SizedBox(height: 14),

        // Content & Type Card
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TYPE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(res.tagType, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),
              Text(
                'CONTENT',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                res.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.15),

        const SizedBox(height: 24),

        // Action Trigger Button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _executeAction,
            icon: Icon(res.actionIcon),
            label: Text(
              'Action: ${res.actionLabel}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 350.ms).scale(),

        const SizedBox(height: 12),
        Text(
          'Saved to history.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  void _showAssignNameDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.sell_rounded),
            SizedBox(width: 10),
            Text('Assign Tag Name'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign a custom identifier or alias for this NFC tag:'),
            const SizedBox(height: 16),
            TextField(
              controller: _nameEditCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Tag Name / Identifier',
                hintText: 'e.g. Desk NFC, Bedroom Lamp, Wifi Tag',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _saveTagName(_nameEditCtrl.text);
            },
            child: const Text('Save Identifier'),
          ),
        ],
      ),
    );
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
      NfcSheetMode.erase => (
        'Waiting to erase tag…',
        Icons.delete_sweep_rounded,
      ),
      NfcSheetMode.inspect => ('Waiting to inspect tag…', Icons.search_rounded),
    };

    return Column(
      children: [
        const SizedBox(height: 32),
        PulsingScanRing(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: cs.primary.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Icon(icon, size: 40, color: cs.primary),
          ),
        ),
        const SizedBox(height: 48), // Spacing for expanding pulsing ring
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

class PulsingScanRing extends StatefulWidget {
  final Widget child;
  const PulsingScanRing({super.key, required this.child});

  @override
  State<PulsingScanRing> createState() => _PulsingScanRingState();
}

class _PulsingScanRingState extends State<PulsingScanRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer expanding ring
            Container(
              width: 100 + (_controller.value * 100),
              height: 100 + (_controller.value * 100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cs.primary.withValues(
                    alpha: 0.25 * (1.0 - _controller.value),
                  ),
                  width: 3,
                ),
              ),
            ),
            // Inner expanding ring
            Container(
              width: 100 + (_controller.value * 50),
              height: 100 + (_controller.value * 50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cs.primary.withValues(
                    alpha: 0.15 * (1.0 - _controller.value),
                  ),
                  width: 2,
                ),
              ),
            ),
            widget.child,
          ],
        );
      },
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
        Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEF4444), width: 2),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Color(0xFFEF4444),
                size: 40,
              ),
            )
            .animate()
            .shake(hz: 8, offset: const Offset(3, 0), duration: 200.ms)
            .fadeIn(),
        const SizedBox(height: 20),
        Text(
          'Something went wrong',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
