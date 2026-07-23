import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../nfc_management/presentation/nfc_write_sheet.dart';

/// Automations tab — placeholder with a CTA to write automation profiles.
class AutomationsTab extends ConsumerWidget {
  const AutomationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Automations',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 8),
          Text(
            'Map NFC tags to sequences of actions.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ).animate().fadeIn(delay: 100.ms),

          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 80,
                    color: cs.primary.withValues(alpha: 0.4),
                  ).animate().fadeIn(delay: 200.ms).scale(),
                  const SizedBox(height: 20),
                  Text(
                    'No automations yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Create a profile and assign it\nto an NFC tag.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const NfcWriteSheet(),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Write an NFC Tag'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).scale(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
