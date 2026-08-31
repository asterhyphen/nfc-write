import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/automation/presentation/timer_notifier.dart';
import '../../features/automation/presentation/flip_clock_timer_screen.dart';
import '../../features/nfc_management/data/tag_registry_repository.dart';

/// Handles background and cold-start NFC scanning via MethodChannel.
class BackgroundNfcManager {
  static const _channel = MethodChannel('dev.aster.nfc_write/nfc');

  static void initialize(WidgetRef ref, BuildContext context) {
    // 1. Foreground listener when the app is already running
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNfcTagScanned') {
        final String? payload = call.arguments as String?;
        if (payload != null) {
          _handlePayload(payload, ref, context);
        }
      }
    });

    // 2. Cold-start check (when the app was launched by tapping the tag)
    _channel.invokeMethod<String>('getPendingPayload').then((payload) {
      if (payload != null && context.mounted) {
        _handlePayload(payload, ref, context);
      }
    });
  }

  static Future<void> _handlePayload(
    String payload,
    WidgetRef ref,
    BuildContext context,
  ) async {
    if (payload.startsWith('timer://')) {
      final secs = int.tryParse(payload.replaceFirst('timer://', '')) ?? 300;
      final registry = await ref.read(tagRegistryRepositoryProvider.future);
      final tagName = registry.getTagName(payload);
      ref.read(timerProvider.notifier).start(secs, tagName ?? 'TIMER');

      if (context.mounted) {
        // Push Flip Clock Screen
        Navigator.push(context, FlipClockTimerScreen.route());
      }
    } else if (payload.startsWith('notification://')) {
      final uri = Uri.parse(payload);
      final title = uri.queryParameters['title'] ?? 'NFC Notification';
      final body =
          uri.queryParameters['body'] ?? 'Automation Action Completed!';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
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
    } else if (payload.startsWith('dnd://')) {
      final uri = Uri.parse(payload);
      final state = uri.queryParameters['state'] ?? 'toggle';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: Row(
            children: [
              const Icon(Icons.do_not_disturb_on_rounded, color: Colors.white),
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
  }
}
