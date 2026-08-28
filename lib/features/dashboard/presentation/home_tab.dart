import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/presentation/history_notifier.dart';
import '../../nfc_management/presentation/nfc_scan_sheet.dart';
import '../../nfc_management/presentation/nfc_write_sheet.dart';
import '../../automation/presentation/timer_notifier.dart';
import '../../automation/presentation/flip_clock_timer_screen.dart';

/// Designer-grade, modern and clean Homepage for scanning & programming NFC.
class HomeDashboardTab extends ConsumerWidget {
  const HomeDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Ambient Glassmorphic Background Blur Lights ────────────────────
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withValues(alpha: 0.16),
              ),
            ),
          ).animate().fadeIn(duration: 900.ms),
          Positioned(
            bottom: 40,
            left: -120,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.tertiary.withValues(alpha: 0.12),
              ),
            ),
          ).animate().fadeIn(duration: 1100.ms),

          // ── Main Page Layout ───────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Designer Welcoming Header ──────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STUDIO WORKSPACE',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'TapFlow NFC',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cs.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: cs.primaryContainer,
                          child: Icon(Icons.bolt, color: cs.primary, size: 20),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05),

                  const SizedBox(height: 28),

                  // ── Premium Pulsating Scan NFC Tag Button ────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: () => _openScanSheet(context, ref),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF4F46E5), const Color(0xFF7C3AED)]
                                : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.35),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Glass shine wave lines
                            Positioned(
                              top: -40,
                              left: -30,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                            ),
                            // Content
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Morphing wave icon
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.16),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.25),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.nfc_rounded,
                                      color: Colors.white,
                                      size: 38,
                                    ),
                                  ).animate(onPlay: (c) => c.repeat()).shimmer(
                                        duration: 1800.ms,
                                        color: Colors.white.withValues(alpha: 0.4),
                                      ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'TAP TO SCAN TAG',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Pulsing status dot
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF10B981),
                                        ),
                                      ).animate(onPlay: (c) => c.repeat()).scale(
                                            begin: const Offset(1, 1),
                                            end: const Offset(1.5, 1.5),
                                            duration: 800.ms,
                                            curve: Curves.easeOut,
                                          ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Ready to Scan',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.96, 0.96)),

                  const SizedBox(height: 36),

                  // ── Section Header ─────────────────────────────────────────
                  Text(
                    'Program Actions to Tag',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 14),

                  // ── Actions Vertical List ──────────────────────────────────
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _DesignerActionTile(
                        index: 0,
                        title: 'Launch Timer Alert',
                        subtitle: 'Starts a custom countdown focus timer',
                        tag: 'TIMER',
                        icon: Icons.timer_rounded,
                        color: const Color(0xFFF59E0B),
                        onTap: () => _programTimer(context, ref),
                      ),
                      _DesignerActionTile(
                        index: 1,
                        title: 'Trigger Notification',
                        subtitle: 'Shows a customizable push text',
                        tag: 'SYSTEM',
                        icon: Icons.notifications_active_rounded,
                        color: const Color(0xFF3B82F6),
                        onTap: () => _programNotification(context),
                      ),
                      _DesignerActionTile(
                        index: 2,
                        title: 'Switch on DND',
                        subtitle: 'Toggle phone sound/vibration status',
                        tag: 'MUTE',
                        icon: Icons.do_not_disturb_on_rounded,
                        color: const Color(0xFFEF4444),
                        onTap: () => _programDnd(context),
                      ),
                      _DesignerActionTile(
                        index: 3,
                        title: 'Open Web URL',
                        subtitle: 'Launch links in system browser',
                        tag: 'NETWORK',
                        icon: Icons.link_rounded,
                        color: const Color(0xFF10B981),
                        onTap: () => _programUrl(context),
                      ),
                      _DesignerActionTile(
                        index: 4,
                        title: 'Share Wi-Fi Network',
                        subtitle: 'Guest login details config',
                        tag: 'NETWORKING',
                        icon: Icons.wifi_rounded,
                        color: const Color(0xFF8B5CF6),
                        onTap: () => _programWifi(context),
                      ),
                      _DesignerActionTile(
                        index: 5,
                        title: 'Share Contact Card',
                        subtitle: 'Write business contact vCard card',
                        tag: 'CONTACT',
                        icon: Icons.badge_rounded,
                        color: const Color(0xFFEC4899),
                        onTap: () => _programContact(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openScanSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NfcScanSheet(
        mode: NfcSheetMode.read,
        onRecordSaved: (r) => ref
            .read(historyProvider.notifier)
            .addRecord(tagType: r.tagType, content: r.content),
      ),
    );
  }

  // ── Dialog Action Logic ────────────────────────────────────────────────────

  void _programTimer(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _TimerProgramDialog(
        onWriteTag: (seconds) {
          Navigator.pop(ctx);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => NfcWriteSheet(
              initialType: WriteType.text,
              initialContent: 'timer://$seconds',
            ),
          );
        },
        onStartNow: (seconds) {
          Navigator.pop(ctx);
          ref.read(timerProvider.notifier).start(seconds, 'TIMER');
          Navigator.push(context, FlipClockTimerScreen.route());
        },
      ),
    );
  }

  void _programNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _NotificationProgramDialog(
        onConfirm: (title, body) {
          Navigator.pop(ctx);
          final encodedTitle = Uri.encodeComponent(title.trim());
          final encodedBody = Uri.encodeComponent(body.trim());
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => NfcWriteSheet(
              initialType: WriteType.text,
              initialContent: 'notification://?title=$encodedTitle&body=$encodedBody',
            ),
          );
        },
      ),
    );
  }

  void _programDnd(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _DndProgramDialog(
        onConfirm: () {
          Navigator.pop(ctx);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const NfcWriteSheet(
              initialType: WriteType.text,
              initialContent: 'dnd://?state=on',
            ),
          );
        },
      ),
    );
  }

  void _programUrl(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _UrlProgramDialog(
        onConfirm: (url) {
          Navigator.pop(ctx);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => NfcWriteSheet(
              initialType: WriteType.url,
              initialContent: url.trim(),
            ),
          );
        },
      ),
    );
  }

  void _programWifi(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _WifiProgramDialog(
        onConfirm: (ssid, pass) {
          Navigator.pop(ctx);
          final payload = 'WIFI:S:${ssid.trim()};T:WPA;P:${pass.trim()};;';
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => NfcWriteSheet(
              initialType: WriteType.text,
              initialContent: payload,
            ),
          );
        },
      ),
    );
  }

  void _programContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _ContactProgramDialog(
        onConfirm: (name, phone) {
          Navigator.pop(ctx);
          final vcard = 'BEGIN:VCARD\nVERSION:3.0\nN:${name.trim()}\nTEL;TYPE=CELL:${phone.trim()}\nEND:VCARD';
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => NfcWriteSheet(
              initialType: WriteType.text,
              initialContent: vcard,
            ),
          );
        },
      ),
    );
  }
}

// ── Custom Stateful Programming Dialogs ──────────────────────────────────────

class _TimerProgramDialog extends StatefulWidget {
  final void Function(int seconds) onWriteTag;
  final void Function(int seconds) onStartNow;
  const _TimerProgramDialog({required this.onWriteTag, required this.onStartNow});

  @override
  State<_TimerProgramDialog> createState() => _TimerProgramDialogState();
}

class _TimerProgramDialogState extends State<_TimerProgramDialog> {
  int _minutes = 5;
  int _seconds = 0;
  late final TextEditingController _minCtrl;
  late final TextEditingController _secCtrl;

  @override
  void initState() {
    super.initState();
    _minCtrl = TextEditingController(text: '5');
    _secCtrl = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _secCtrl.dispose();
    super.dispose();
  }

  void _updateFromInputs() {
    final m = int.tryParse(_minCtrl.text) ?? 0;
    final s = int.tryParse(_secCtrl.text) ?? 0;
    setState(() {
      _minutes = m.clamp(0, 999);
      _seconds = s.clamp(0, 59);
    });
  }

  void _setPreset(int mins) {
    setState(() {
      _minutes = mins;
      _seconds = 0;
      _minCtrl.text = mins.toString();
      _secCtrl.text = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;
    final totalSeconds = (_minutes * 60) + _seconds;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.timer_rounded, color: Colors.orange, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Program Timer Action',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Preset Chips
            const Text(
              'Presets',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _presetChip(1, '1m'),
                _presetChip(5, '5m'),
                _presetChip(10, '10m'),
                _presetChip(25, '25m (Pomo)'),
                _presetChip(60, '1h'),
              ],
            ),
            const SizedBox(height: 20),

            // Live Time Display
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3), width: 1.2),
                ),
                child: Text(
                  '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateFromInputs(),
                    decoration: InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _secCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateFromInputs(),
                    decoration: InputDecoration(
                      labelText: 'Seconds',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Slider
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.orange,
                inactiveTrackColor: Colors.orange.withValues(alpha: 0.2),
                thumbColor: Colors.orange,
                overlayColor: Colors.orange.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: _minutes.toDouble().clamp(1.0, 120.0),
                min: 1,
                max: 120,
                divisions: 119,
                onChanged: (val) {
                  setState(() {
                    _minutes = val.round();
                    _minCtrl.text = _minutes.toString();
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: totalSeconds > 0
                      ? () => widget.onWriteTag(totalSeconds)
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Write to Tag'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: totalSeconds > 0
                      ? () => widget.onStartNow(totalSeconds)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Start Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _presetChip(int mins, String label) {
    final isSelected = _minutes == mins && _seconds == 0;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.orange,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => _setPreset(mins),
      selectedColor: Colors.orange,
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _NotificationProgramDialog extends StatefulWidget {
  final void Function(String title, String body) onConfirm;
  const _NotificationProgramDialog({required this.onConfirm});

  @override
  State<_NotificationProgramDialog> createState() => _NotificationProgramDialogState();
}

class _NotificationProgramDialogState extends State<_NotificationProgramDialog> {
  final _titleCtrl = TextEditingController(text: 'Focus Mode');
  final _bodyCtrl = TextEditingController(text: 'NFC action sequence triggered successfully!');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_active_rounded, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Program Notification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                labelText: 'Notification Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Message Body',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => widget.onConfirm(_titleCtrl.text, _bodyCtrl.text),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Confirm Action'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DndProgramDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _DndProgramDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.do_not_disturb_on_rounded, color: Colors.redAccent, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Program DND Action', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'This will program a Do Not Disturb toggle action to the NFC tag. When tapped, the system will switch the DND silence mode.',
              style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Confirm Action'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UrlProgramDialog extends StatefulWidget {
  final void Function(String url) onConfirm;
  const _UrlProgramDialog({required this.onConfirm});

  @override
  State<_UrlProgramDialog> createState() => _UrlProgramDialogState();
}

class _UrlProgramDialogState extends State<_UrlProgramDialog> {
  final _urlCtrl = TextEditingController(text: 'https://example.com');

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.link_rounded, color: Colors.teal, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Program URL Link', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlCtrl,
              decoration: InputDecoration(
                labelText: 'Web URL Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => widget.onConfirm(_urlCtrl.text),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Confirm Link'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WifiProgramDialog extends StatefulWidget {
  final void Function(String ssid, String pass) onConfirm;
  const _WifiProgramDialog({required this.onConfirm});

  @override
  State<_WifiProgramDialog> createState() => _WifiProgramDialogState();
}

class _WifiProgramDialogState extends State<_WifiProgramDialog> {
  final _ssidCtrl = TextEditingController(text: 'HomeWiFi');
  final _passCtrl = TextEditingController(text: 'SSIDPassword');

  @override
  void dispose() {
    _ssidCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.wifi_rounded, color: Colors.purple, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Program Wi-Fi Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ssidCtrl,
              decoration: InputDecoration(
                labelText: 'Wi-Fi Name (SSID)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => widget.onConfirm(_ssidCtrl.text, _passCtrl.text),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Confirm Action'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactProgramDialog extends StatefulWidget {
  final void Function(String name, String phone) onConfirm;
  const _ContactProgramDialog({required this.onConfirm});

  @override
  State<_ContactProgramDialog> createState() => _ContactProgramDialogState();
}

class _ContactProgramDialogState extends State<_ContactProgramDialog> {
  final _nameCtrl = TextEditingController(text: 'John Doe');
  final _phoneCtrl = TextEditingController(text: '+15550199');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.badge_rounded, color: Colors.pink, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Program Contact Card', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => widget.onConfirm(_nameCtrl.text, _phoneCtrl.text),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Confirm Action'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DesignerActionTile extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DesignerActionTile({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.45)
          : cs.surfaceContainerLow.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              // Icon block
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              // Text descriptions
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Mini category pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: color,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.55),
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, size: 20, color: cs.outline),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: 350 + (index * 60)),
        ).slideY(
          begin: 0.08,
          curve: Curves.easeOutQuad,
          duration: 400.ms,
        );
  }
}
