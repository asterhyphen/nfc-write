import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../automation/presentation/launch_timer_sheet.dart';
import '../../history/presentation/history_notifier.dart';
import '../../../core/widgets/glass_card.dart';
import '../../nfc_management/presentation/nfc_scan_sheet.dart';
import '../../nfc_management/presentation/nfc_write_sheet.dart';

/// The main Home tab of the dashboard — statistics, quick actions, launch timers, recent scans.
class HomeDashboardTab extends ConsumerWidget {
  const HomeDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final cs = Theme.of(context).colorScheme;

    final totalScans = historyAsync.value?.length ?? 0;
    final favorites =
        historyAsync.value?.where((r) => r.isFavorite).length ?? 0;
    final recent = historyAsync.value?.take(5).toList() ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    'TapFlow',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: cs.primaryContainer,
                child: Icon(Icons.nfc_rounded, color: cs.primary),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.15),

          const SizedBox(height: 24),

          // ── Stats card ────────────────────────────────────────────────────
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBadge(label: 'Total Scans', value: '$totalScans'),
                Container(width: 1, height: 40, color: cs.outlineVariant),
                _StatBadge(label: 'Profiles', value: '0'),
                Container(width: 1, height: 40, color: cs.outlineVariant),
                _StatBadge(label: 'Favourites', value: '$favorites'),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),

          const SizedBox(height: 28),

          // ── Quick Actions ─────────────────────────────────────────────────
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 250.ms),
          const SizedBox(height: 14),

          GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
                children: [
                  _QuickAction(
                    title: 'Read Tag',
                    subtitle: 'Scan & inspect',
                    icon: Icons.nfc_rounded,
                    gradient: [
                      const Color(0xFF4776E6),
                      const Color(0xFF8E54E9),
                    ],
                    onTap: () => _openScanSheet(context, ref),
                  ),
                  _QuickAction(
                    title: 'Write Tag',
                    subtitle: 'Create NDEF',
                    icon: Icons.edit_rounded,
                    gradient: [
                      const Color(0xFF11998E),
                      const Color(0xFF38EF7D),
                    ],
                    onTap: () => _openWriteSheet(context, ref),
                  ),
                  _QuickAction(
                    title: 'Launch Timer',
                    subtitle: 'Presets & countdown',
                    icon: Icons.timer_rounded,
                    gradient: [
                      const Color(0xFFFF512F),
                      const Color(0xFFDD2476),
                    ],
                    onTap: () =>
                        _openLaunchTimerSheet(context, 300), // Standard 5m
                  ),
                  _QuickAction(
                    title: 'Erase Tag',
                    subtitle: 'Wipe NDEF',
                    icon: Icons.delete_sweep_rounded,
                    gradient: [
                      const Color(0xFF8E2DE2),
                      const Color(0xFF4A00E0),
                    ],
                    onTap: () => _openEraseSheet(context, ref),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: 350.ms)
              .scale(begin: const Offset(0.95, 0.95)),

          const SizedBox(height: 28),

          // ── Standard Launch Timer Presets ─────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.flash_on_rounded, size: 20, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Standard Launch Timers',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _openLaunchTimerSheet(context, 300),
                child: const Text('Custom'),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _TimerPresetCard(
                  label: '30s Quick',
                  seconds: 30,
                  icon: Icons.flash_on_rounded,
                  color: Colors.orange,
                  onTap: () => _openLaunchTimerSheet(
                    context,
                    30,
                    label: '30s Quick Timer',
                  ),
                ),
                _TimerPresetCard(
                  label: '1 Min',
                  seconds: 60,
                  icon: Icons.timer_10_rounded,
                  color: Colors.blue,
                  onTap: () =>
                      _openLaunchTimerSheet(context, 60, label: '1 Min Timer'),
                ),
                _TimerPresetCard(
                  label: '5 Mins ★',
                  seconds: 300,
                  icon: Icons.star_rounded,
                  color: Colors.purple,
                  isStandard: true,
                  onTap: () => _openLaunchTimerSheet(
                    context,
                    300,
                    label: '5 Mins Focus',
                  ),
                ),
                _TimerPresetCard(
                  label: '10 Mins',
                  seconds: 600,
                  icon: Icons.timer_rounded,
                  color: Colors.teal,
                  onTap: () => _openLaunchTimerSheet(
                    context,
                    600,
                    label: '10 Mins Timer',
                  ),
                ),
                _TimerPresetCard(
                  label: '15 Mins',
                  seconds: 900,
                  icon: Icons.alarm_rounded,
                  color: Colors.amber,
                  onTap: () => _openLaunchTimerSheet(
                    context,
                    900,
                    label: '15 Mins Timer',
                  ),
                ),
                _TimerPresetCard(
                  label: '30 Mins',
                  seconds: 1800,
                  icon: Icons.hourglass_bottom_rounded,
                  color: Colors.indigo,
                  onTap: () => _openLaunchTimerSheet(
                    context,
                    1800,
                    label: '30 Mins Timer',
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.1),

          const SizedBox(height: 28),

          // ── Recent activity ───────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (recent.isNotEmpty)
                TextButton(onPressed: () {}, child: const Text('See all')),
            ],
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 10),

          historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (_) {
              if (recent.isEmpty) {
                return _EmptyHistory();
              }
              return Column(
                children: [
                  for (int i = 0; i < recent.length; i++)
                    _RecentTile(record: recent[i])
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: 550 + i * 60))
                        .slideX(begin: 0.1),
                ],
              );
            },
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

  void _openWriteSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NfcWriteSheet(),
    );
  }

  void _openEraseSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          NfcScanSheet(mode: NfcSheetMode.erase, onRecordSaved: (_) {}),
    );
  }

  void _openLaunchTimerSheet(
    BuildContext context,
    int seconds, {
    String? label,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          LaunchTimerSheet(initialSeconds: seconds, initialLabel: label),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerPresetCard extends StatelessWidget {
  final String label;
  final int seconds;
  final IconData icon;
  final Color color;
  final bool isStandard;
  final VoidCallback onTap;

  const _TimerPresetCard({
    required this.label,
    required this.seconds,
    required this.icon,
    required this.color,
    this.isStandard = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isStandard
                ? color.withValues(alpha: 0.15)
                : Theme.of(context).colorScheme.surfaceContainerHigh,
            border: Border.all(
              color: isStandard ? color : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isStandard
                      ? color
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.nfc_rounded,
            size: 56,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No scans yet.\nTap "Read Tag" to get started.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}

class _RecentTile extends ConsumerWidget {
  final dynamic record; // ScanRecord
  const _RecentTile({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cs.secondaryContainer,
          child: Icon(_iconFor(record.tagType), size: 18, color: cs.secondary),
        ),
        title: Text(
          record.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          record.tagType,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(
            record.isFavorite ? Icons.star : Icons.star_border,
            color: record.isFavorite ? Colors.amber : null,
          ),
          onPressed: () =>
              ref.read(historyProvider.notifier).toggleFavorite(record.id),
        ),
      ),
    );
  }

  IconData _iconFor(String type) {
    switch (type.toLowerCase()) {
      case 'url':
        return Icons.link;
      case 'text':
        return Icons.text_fields;
      case 'wifi':
        return Icons.wifi;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      default:
        return Icons.nfc;
    }
  }
}
