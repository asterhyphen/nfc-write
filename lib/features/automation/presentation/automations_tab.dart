import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/glass_card.dart';
import '../data/automation_engine.dart';
import '../domain/automation_action.dart';
import 'create_profile_sheet.dart';

/// Pre-configured starter automation profiles.
final List<AutomationProfile> kStarterProfiles = [
  const AutomationProfile(
    id: 'focus_mode',
    name: '⚡ Deep Work Session',
    actions: [
      AutomationAction.showNotification(
        title: 'Focus Started',
        body: 'Distractions muted. Starting 25m Pomodoro.',
      ),
      AutomationAction.delayTimer(seconds: 1500, label: 'Pomodoro Timer'),
    ],
    isFavorite: true,
  ),
  const AutomationProfile(
    id: 'bedtime',
    name: '🌙 Bedtime Routine',
    actions: [
      AutomationAction.setBrightness(level: 0.1),
      AutomationAction.showNotification(
        title: 'Night Mode',
        body: 'Brightness dimmed. Sleep tight!',
      ),
    ],
    isFavorite: true,
  ),
  const AutomationProfile(
    id: 'car_mode',
    name: '🚗 Car Navigation',
    actions: [
      AutomationAction.showNotification(
        title: 'Car Mode Active',
        body: 'Opening navigation maps…',
      ),
      AutomationAction.openUrl(url: 'https://maps.google.com'),
    ],
  ),
  const AutomationProfile(
    id: 'smart_home',
    name: '🏠 Welcome Home',
    actions: [
      AutomationAction.showNotification(
        title: 'Welcome Home',
        body: 'Connecting smart home scene…',
      ),
      AutomationAction.openUrl(
        url: 'https://home-assistant.local:8123/api/webhook/arrived_home',
      ),
    ],
  ),
];

class AutomationsTab extends ConsumerWidget {
  const AutomationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Automations',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                onPressed: () => _openCreateProfile(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create'),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 6),
          Text(
            'Map NFC tags to run multi-step action sequences.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: kStarterProfiles.length,
              itemBuilder: (ctx, i) {
                final profile = kStarterProfiles[i];
                return _ProfileCard(
                      profile: profile,
                      onRun: () {
                        ref
                            .read(automationEngineProvider)
                            .executeProfile(profile);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Running automation: ${profile.name}',
                            ),
                          ),
                        );
                      },
                    )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 150 + i * 60))
                    .slideY(begin: 0.1);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openCreateProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateProfileSheet(),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final AutomationProfile profile;
  final VoidCallback onRun;

  const _ProfileCard({required this.profile, required this.onRun});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    profile.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${profile.actions.length} STEPS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action Steps summary
            Column(
              children: profile.actions.map((action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 14,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _describeAction(action),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.7),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRun,
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Run Automation'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _describeAction(AutomationAction a) => a.map(
    openUrl: (x) => 'Open URL: ${x.url}',
    showNotification: (x) => 'Notification: ${x.title}',
    launchApp: (x) => 'Launch App: ${x.packageName}',
    setBrightness: (x) => 'Set Brightness to ${(x.level * 100).toInt()}%',
    delayTimer: (x) => 'Wait ${x.seconds}s',
  );
}
