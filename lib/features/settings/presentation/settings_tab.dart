import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/presentation/history_notifier.dart';

/// Settings tab with real controls wired to providers.
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
          title: 'Theme',
          subtitle: 'Follow system theme',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(context),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1),

        const SizedBox(height: 16),
        _SectionHeader('Data'),
        _SettingCard(
          icon: Icons.delete_forever_outlined,
          title: 'Clear Scan History',
          subtitle: 'Remove all recorded scans',
          iconColor: cs.error,
          onTap: () => _confirmClearHistory(context, ref),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),

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
          onTap: () => showLicensePage(context: context, applicationName: 'TapFlow'),
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
