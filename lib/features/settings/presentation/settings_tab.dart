import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/bouncy_tap.dart';
import '../../history/presentation/history_notifier.dart';
import '../data/backup_service.dart';

/// Settings tab styled with Apple iOS Inset Grouped design.
class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 20),

        _SectionHeader('APPEARANCE'),
        _SettingCard(
          icon: CupertinoIcons.moon_fill,
          badgeColor: const Color(0xFF5856D6),
          title: 'Theme Mode',
          subtitle: 'Follows system appearance',
          trailing: const Icon(CupertinoIcons.chevron_right, size: 14),
          onTap: () => _showThemeDialog(context),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05),

        const SizedBox(height: 16),
        _SectionHeader('DATA & BACKUP'),
        _SettingCard(
          icon: CupertinoIcons.arrow_up_doc_fill,
          badgeColor: const Color(0xFF007AFF),
          title: 'Export Backup (JSON)',
          subtitle: 'Export scan history & tag aliases',
          trailing: const Icon(CupertinoIcons.chevron_right, size: 14),
          onTap: () => _exportBackup(context, ref),
        ).animate().fadeIn(delay: 150.ms).slideX(begin: 0.05),

        _SettingCard(
          icon: CupertinoIcons.arrow_down_doc_fill,
          badgeColor: const Color(0xFF34C759),
          title: 'Import Backup (JSON)',
          subtitle: 'Restore scan records & tag aliases',
          trailing: const Icon(CupertinoIcons.chevron_right, size: 14),
          onTap: () => _importBackup(context, ref),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),

        _SettingCard(
          icon: CupertinoIcons.trash_fill,
          badgeColor: const Color(0xFFFF3B30),
          title: 'Clear Scan History',
          subtitle: 'Remove all recorded scans',
          iconColor: Colors.white,
          onTap: () => _confirmClearHistory(context, ref),
        ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.05),

        const SizedBox(height: 16),
        _SectionHeader('ABOUT'),
        _SettingCard(
          icon: CupertinoIcons.info_circle_fill,
          badgeColor: const Color(0xFFFF9500),
          title: 'TipTapTup',
          subtitle: 'Version 1.0.0 • Modern NFC Manager',
          onTap: () {},
        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.05),

        _SettingCard(
          icon: CupertinoIcons.doc_text_fill,
          badgeColor: const Color(0xFF8E8E93),
          title: 'Open Source Licenses',
          subtitle: 'Third-party acknowledgements',
          trailing: const Icon(CupertinoIcons.chevron_right, size: 14),
          onTap: () =>
              showLicensePage(context: context, applicationName: 'TipTapTup'),
        ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.05),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Theme'),
        content: const Text(
          'Theme follows your system setting (light / dark).',
        ),
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
                const SnackBar(
                  content: Text('Backup JSON copied to clipboard!'),
                ),
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
            const Text('Paste your TipTapTup JSON backup string below:'),
            const SizedBox(height: 12),
            TextField(
              controller: importCtrl,
              maxLines: 5,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              decoration: InputDecoration(
                hintText: '{\n  "app": "TipTapTup", ...\n}',
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
                final backupSvc = await ref.read(backupServiceProvider.future);
                await backupSvc.restoreBackupJson(text);

                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                ref.invalidate(historyProvider);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Backup restored successfully!'),
                  ),
                );
              } catch (e) {
                if (!ctx.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Import error: $e')));
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('History cleared.')));
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
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final Color? badgeColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _SettingCard({
    required this.icon,
    this.badgeColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA);
    final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return BouncyTap(
      onTap: onTap,
      scaleDown: 0.96,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: badgeColor ?? cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              IconTheme(
                data: const IconThemeData(
                  color: Color(0xFFC7C7CC),
                ),
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}
