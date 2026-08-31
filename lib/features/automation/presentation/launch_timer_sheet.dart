import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/glass_card.dart';
import '../../nfc_management/presentation/nfc_write_sheet.dart';
import 'timer_notifier.dart';
import 'flip_clock_timer_screen.dart';

/// Preset timer options in seconds.
class TimerPreset {
  final String label;
  final int seconds;
  final IconData icon;

  const TimerPreset({
    required this.label,
    required this.seconds,
    required this.icon,
  });
}

const List<TimerPreset> kStandardPresets = [
  TimerPreset(label: '30 Secs', seconds: 30, icon: Icons.flash_on_rounded),
  TimerPreset(label: '1 Min', seconds: 60, icon: Icons.timer_10_rounded),
  TimerPreset(label: '5 Mins', seconds: 300, icon: Icons.timer_3_rounded),
  TimerPreset(label: '10 Mins', seconds: 600, icon: Icons.timer_rounded),
  TimerPreset(label: '15 Mins', seconds: 900, icon: Icons.alarm_rounded),
  TimerPreset(
    label: '30 Mins',
    seconds: 1800,
    icon: Icons.hourglass_bottom_rounded,
  ),
];

class LaunchTimerSheet extends ConsumerStatefulWidget {
  final int initialSeconds;
  final String? initialLabel;

  const LaunchTimerSheet({
    super.key,
    this.initialSeconds = 300, // Default 5 mins
    this.initialLabel,
  });

  @override
  ConsumerState<LaunchTimerSheet> createState() => _LaunchTimerSheetState();
}

class _LaunchTimerSheetState extends ConsumerState<LaunchTimerSheet> {
  late int _selectedSeconds;
  late String _timerLabel;
  final TextEditingController _customCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSeconds = widget.initialSeconds;
    _timerLabel = widget.initialLabel ?? 'TIMER';
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  void _startTimer() {
    ref.read(timerProvider.notifier).start(_selectedSeconds, _timerLabel);
    Navigator.push(context, FlipClockTimerScreen.route());
  }

  void _pauseTimer() {
    ref.read(timerProvider.notifier).pause();
  }

  void _resumeTimer() {
    ref.read(timerProvider.notifier).resume();
  }

  void _resetTimer() {
    ref.read(timerProvider.notifier).reset();
  }

  String _formatDuration(int totalSecs) {
    final mins = totalSecs ~/ 60;
    final secs = totalSecs % 60;
    final hrs = mins ~/ 60;
    if (hrs > 0) {
      final remMins = mins % 60;
      return '${hrs.toString().padLeft(2, '0')}:${remMins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final timerState = ref.watch(timerProvider);
    final isActive =
        timerState.isRunning || timerState.isPaused || timerState.isFinished;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: ctrl,
                padding: const EdgeInsets.all(24),
                child: isActive
                    ? _buildActiveTimerView(cs, timerState)
                    : _buildSetupView(cs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Setup View ─────────────────────────────────────────────────────────────

  Widget _buildSetupView(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.timer_rounded, color: cs.primary, size: 24),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Launch Timer',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Select a standard duration or set custom',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: 24),

        // Presets Grid
        Text(
          'Standard Presets',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
          ),
          itemCount: kStandardPresets.length,
          itemBuilder: (ctx, i) {
            final p = kStandardPresets[i];
            final isSelected = _selectedSeconds == p.seconds;
            return ChoiceChip(
              showCheckmark: false,
              avatar: Icon(
                p.icon,
                size: 18,
                color: isSelected ? cs.onPrimary : cs.primary,
              ),
              label: Text(
                p.label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? cs.onPrimary : cs.onSurface,
                ),
              ),
              selected: isSelected,
              selectedColor: cs.primary,
              backgroundColor: cs.surfaceContainerHigh,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedSeconds = p.seconds;
                    _customCtrl.clear();
                  });
                }
              },
            );
          },
        ).animate().fadeIn(delay: 150.ms),

        const SizedBox(height: 20),

        // Custom Duration Input
        GlassCard(
          child: Row(
            children: [
              const Icon(Icons.edit_calendar_rounded, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _customCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Custom duration (in minutes)',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (val) {
                    final mins = int.tryParse(val);
                    if (mins != null && mins > 0) {
                      setState(() {
                        _selectedSeconds = mins * 60;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 250.ms),

        const SizedBox(height: 28),

        // Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _writeTimerToNfc,
                icon: const Icon(Icons.nfc_rounded),
                label: const Text('Write to NFC'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _startTimer,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text('Start (${_formatDuration(_selectedSeconds)})'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 350.ms),
      ],
    );
  }

  // ── Active Timer View ──────────────────────────────────────────────────────

  Widget _buildActiveTimerView(ColorScheme cs, TimerState timerState) {
    final progress = timerState.duration > 0
        ? timerState.remainingSeconds / timerState.duration
        : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(
          timerState.label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 32),

        // Circular Timer Progress Ring
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: cs.outlineVariant.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  timerState.isFinished
                      ? Colors.green
                      : (timerState.isPaused ? Colors.amber : cs.primary),
                ),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (timerState.isFinished) ...[
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 56,
                    color: Colors.green,
                  ).animate().scale(begin: const Offset(0.5, 0.5)),
                  const SizedBox(height: 8),
                  Text(
                    'Time\'s Up!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ] else ...[
                  Text(
                    _formatDuration(timerState.remainingSeconds),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timerState.isPaused ? 'PAUSED' : 'RUNNING',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: timerState.isPaused ? Colors.amber : cs.outline,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ).animate().scale(begin: const Offset(0.9, 0.9)),

        const SizedBox(height: 40),

        // Timer Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (timerState.isRunning || timerState.isPaused) ...[
              IconButton.filledTonal(
                iconSize: 32,
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _resetTimer,
                tooltip: 'Reset',
              ),
              const SizedBox(width: 16),
              IconButton.filled(
                iconSize: 44,
                padding: const EdgeInsets.all(16),
                icon: Icon(
                  timerState.isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                ),
                onPressed: timerState.isPaused ? _resumeTimer : _pauseTimer,
              ),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                iconSize: 32,
                icon: const Icon(Icons.stop_rounded),
                onPressed: _resetTimer,
                tooltip: 'Stop',
              ),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                iconSize: 32,
                icon: const Icon(Icons.fullscreen_rounded),
                onPressed: () {
                  Navigator.push(context, FlipClockTimerScreen.route());
                },
                tooltip: 'Fullscreen Clock',
              ),
            ] else if (timerState.isFinished) ...[
              FilledButton.icon(
                onPressed: _resetTimer,
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Start Again'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  void _writeTimerToNfc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NfcWriteSheet(),
    );
  }
}
