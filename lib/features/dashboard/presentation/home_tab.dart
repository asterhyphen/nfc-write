import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/presentation/history_notifier.dart';
import '../../nfc_management/presentation/nfc_scan_sheet.dart';
import '../../nfc_management/presentation/nfc_write_sheet.dart';

/// Clean, simple Homepage for scanning and programming NFC actions.
class HomeDashboardTab extends ConsumerWidget {
  const HomeDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Glowing Background Lights ──────────────────────────────────────
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withValues(alpha: 0.15),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms),
          Positioned(
            bottom: 60,
            left: -150,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.tertiary.withValues(alpha: 0.1),
              ),
            ),
          ).animate().fadeIn(duration: 1000.ms),

          // ── Content Layout ──────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Minimalistic Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TapFlow Studio',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'NFC Tool',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: cs.primaryContainer,
                        child: Icon(Icons.nfc_rounded, color: cs.primary, size: 24),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // ── Large Clean Scan Card ──────────────────────────────────────
                  GestureDetector(
                    onTap: () => _openScanSheet(context, ref),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [cs.primary, cs.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.nfc_rounded,
                                color: Colors.white,
                                size: 48,
                              ),
                            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms),
                            const SizedBox(height: 16),
                            const Text(
                              'Tap to Scan NFC Tag',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Reads payload and executes associated actions',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 150.ms).scale(begin: const Offset(0.98, 0.98)),

                  const SizedBox(height: 32),

                  // ── Vertical list of actions ──────────────────────────────
                  Text(
                    'Program Actions to Tag',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: 12),

                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _ActionTile(
                        title: 'Start Timer',
                        subtitle: 'Run countdown focus/timer alert',
                        icon: Icons.timer_rounded,
                        color: Colors.orange,
                        onTap: () => _programTimer(context),
                      ),
                      _ActionTile(
                        title: 'Send Notification',
                        subtitle: 'Trigger a customized local push notification',
                        icon: Icons.notifications_active_rounded,
                        color: Colors.blue,
                        onTap: () => _programNotification(context),
                      ),
                      _ActionTile(
                        title: 'Switch on DND',
                        subtitle: 'Mute sounds and toggle Do Not Disturb mode',
                        icon: Icons.do_not_disturb_on_rounded,
                        color: Colors.redAccent,
                        onTap: () => _programDnd(context),
                      ),
                      _ActionTile(
                        title: 'Open Web URL',
                        subtitle: 'Launch website or link in system browser',
                        icon: Icons.link_rounded,
                        color: Colors.teal,
                        onTap: () => _programUrl(context),
                      ),
                      _ActionTile(
                        title: 'Share Wi-Fi Network',
                        subtitle: 'Write credentials for quick guest login',
                        icon: Icons.wifi_rounded,
                        color: Colors.purple,
                        onTap: () => _programWifi(context),
                      ),
                      _ActionTile(
                        title: 'Share Contact card',
                        subtitle: 'Write business vCard metadata to tag',
                        icon: Icons.badge_rounded,
                        color: Colors.indigo,
                        onTap: () => _programContact(context),
                      ),
                    ],
                  ).animate().fadeIn(delay: 350.ms),
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

  // ── Action configuration modal helper triggers ──────────────────────────────

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

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.4) : cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: cs.outline),
        onTap: onTap,
      ),
    );
  }
}
