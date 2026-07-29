import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/presentation/history_notifier.dart';
import '../data/backup_service.dart';

/// Settings tab with real controls for appearance, JSON backup/restore, and history.
class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 24),

        _SectionHeader('Appearance'),
        _SettingCard(
          icon: Icons.dark_mode_outlined,
          title: 'Theme Mode',
          subtitle: 'Follow system theme',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(context),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1),

        const SizedBox(height: 16),
        _SectionHeader('Backup & Data'),
        _SettingCard(
          icon: Icons.upload_rounded,
          title: 'Export Backup (JSON)',
          subtitle: 'Export scan history & tag aliases',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _exportBackup(context, ref),
        ).animate().fadeIn(delay: 150.ms).slideX(begin: 0.1),

        _SettingCard(
          icon: Icons.download_rounded,
          title: 'Import Backup (JSON)',
          subtitle: 'Restore scan records & tag aliases',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _importBackup(context, ref),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),

        _SettingCard(
          icon: Icons.delete_forever_outlined,
          title: 'Clear Scan History',
          subtitle: 'Remove all recorded scans',
          iconColor: cs.error,
          onTap: () => _confirmClearHistory(context, ref),
        ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.1),

        const SizedBox(height: 16),
        _SectionHeader('About'),
        _SettingCard(
          icon: Icons.info_outline,
          title: 'TapFlow',
          subtitle: 'Version 1.0.0 • Premium NFC Manager',
          onTap: () {},
        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),

        _SettingCard(
          icon: Icons.code,
          title: 'Open Source Licenses',
          subtitle: 'Third-party libraries',
          trailing: const Icon(Icons.chevron_right),
          onTap: () =>
              showLicensePage(context: context, applicationName: 'TapFlow'),
        ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.1),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Theme'),
        content: const Text('Theme follows your system setting (light / dark).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final backupSvc = await ref.read(backupServiceProvider.future);
    final jsonStr = await backupSvc.exportBackupJson();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.upload_file_rounded),
            SizedBox(width: 10),
            Text('Backup JSON'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Here is your formatted backup JSON payload:'),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 180),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  jsonStr,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Copy JSON'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonStr));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup JSON copied to clipboard!')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _importBackup(BuildContext context, WidgetRef ref) {
    final importCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.download_rounded),
            SizedBox(width: 10),
            Text('Import Backup'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paste your TapFlow JSON backup string below:'),
            const SizedBox(height: 12),
            TextField(
              controller: importCtrl,
              maxLines: 5,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              decoration: InputDecoration(
                hintText: '{\n  "app": "TapFlow", ...\n}',
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
            onPressed: () async {
              final text = importCtrl.text.trim();
              if (text.isEmpty) return;

              try {
                final backupSvc =
                    await ref.read(backupServiceProvider.future);
                await backupSvc.restoreBackupJson(text);

                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                ref.invalidate(historyProvider);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Backup restored successfully!')),
                );
              } catch (e) {
                if (!ctx.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Import error: $e')),
                );
              }
            },
            child: const Text('Restore Data'),
          ),
        ],
      ),
    );
  }

  void _confirmClearHistory(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'This will delete all scan records permanently. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(historyProvider.notifier).clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared.')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: (iconColor ?? cs.primary).withValues(alpha: 0.12),
          child: Icon(icon, color: iconColor ?? cs.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
