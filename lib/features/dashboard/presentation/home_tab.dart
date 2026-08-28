import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/presentation/history_notifier.dart';
import '../../nfc_management/presentation/nfc_scan_sheet.dart';
import '../../nfc_management/presentation/nfc_write_sheet.dart';

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
                        subtitle: 'Starts a countdown focus timer',
                        tag: 'UTILITY',
                        icon: Icons.timer_rounded,
                        color: const Color(0xFFF59E0B),
                        onTap: () => _programTimer(context),
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

  void _programTimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        int selectedMins = 5;
        return AlertDialog(
          title: const Text('Program Timer Tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Set timer duration to write to NFC tag:'),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: selectedMins,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 Minute')),
                  DropdownMenuItem(value: 5, child: Text('5 Minutes')),
                  DropdownMenuItem(value: 10, child: Text('10 Minutes')),
                  DropdownMenuItem(value: 15, child: Text('15 Minutes')),
                  DropdownMenuItem(value: 30, child: Text('30 Minutes')),
                ],
                onChanged: (val) {
                  if (val != null) selectedMins = val;
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NfcWriteSheet(
                    initialType: WriteType.text,
                    initialContent: 'timer://${selectedMins * 60}',
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _programNotification(BuildContext context) {
    final titleCtrl = TextEditingController(text: 'Focus Mode');
    final bodyCtrl = TextEditingController(text: 'Your action sequence triggered successfully!');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Program Notification Tag'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Notification Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bodyCtrl,
              decoration: const InputDecoration(labelText: 'Notification Message'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final encodedTitle = Uri.encodeComponent(titleCtrl.text.trim());
              final encodedBody = Uri.encodeComponent(bodyCtrl.text.trim());
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
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _programDnd(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Program DND Tag'),
        content: const Text('Do you want to program Do Not Disturb DND Toggle to this tag?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
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
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _programUrl(BuildContext context) {
    final urlCtrl = TextEditingController(text: 'https://example.com');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Program URL Tag'),
        content: TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(labelText: 'Web URL Address'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => NfcWriteSheet(
                  initialType: WriteType.url,
                  initialContent: urlCtrl.text.trim(),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _programWifi(BuildContext context) {
    final ssidCtrl = TextEditingController(text: 'HomeWiFi');
    final passCtrl = TextEditingController(text: 'SSIDPassword');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Program Wi-Fi Tag'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ssidCtrl,
              decoration: const InputDecoration(labelText: 'Wi-Fi Name (SSID)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final payload = 'WIFI:S:${ssidCtrl.text.trim()};T:WPA;P:${passCtrl.text.trim()};;';
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
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _programContact(BuildContext context) {
    final nameCtrl = TextEditingController(text: 'John Doe');
    final phoneCtrl = TextEditingController(text: '+15550199');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Program Contact Tag'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final vcard = 'BEGIN:VCARD\nVERSION:3.0\nN:${nameCtrl.text.trim()}\nTEL;TYPE=CELL:${phoneCtrl.text.trim()}\nEND:VCARD';
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
            child: const Text('Confirm'),
          ),
        ],
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
