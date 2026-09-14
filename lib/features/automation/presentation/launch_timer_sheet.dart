import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/glass_card.dart';
import '../../nfc_management/presentation/nfc_write_sheet.dart';
import 'timer_notifier.dart';
import 'flip_clock_timer_screen.dart';
import '../data/timer_preferences.dart';

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
  final int? initialSeconds;
  final String? initialLabel;

  const LaunchTimerSheet({
    super.key,
    this.initialSeconds,
    this.initialLabel,
  });

  @override
  ConsumerState<LaunchTimerSheet> createState() => _LaunchTimerSheetState();
}

class _LaunchTimerSheetState extends ConsumerState<LaunchTimerSheet> {
  TimerMode _mode = TimerMode.countdown;
  late int _selectedSeconds;
  int? _countUpLimit;
  late String _timerLabel;
  final TextEditingController _customCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSeconds = widget.initialSeconds ?? 300;
    _timerLabel = widget.initialLabel ?? 'TIMER';
    if (widget.initialSeconds == null) {
      TimerPreferences.getLastDuration().then((secs) {
        if (mounted) {
          setState(() {
            _selectedSeconds = secs;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_mode == TimerMode.countup) {
      ref.read(timerProvider.notifier).startCountUp(
            label: _timerLabel == 'TIMER' ? 'FOCUS FLOW' : _timerLabel,
            limitSeconds: _countUpLimit,
          );
    } else {
      ref.read(timerProvider.notifier).start(_selectedSeconds, _timerLabel);
    }
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
              child: Icon(
                _mode == TimerMode.countup
                    ? Icons.trending_up_rounded
                    : Icons.timer_rounded,
                color: cs.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _mode == TimerMode.countup ? 'Count Up Flow' : 'Launch Timer',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _mode == TimerMode.countup
                      ? 'Open stopwatch or set milestone goals'
                      : 'Select a duration or enter custom',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: 20),

        // ── Mode Switcher Segmented Control ─────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _mode = TimerMode.countdown),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _mode == TimerMode.countdown
                          ? cs.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _mode == TimerMode.countdown
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_top_rounded,
                          size: 16,
                          color: _mode == TimerMode.countdown
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Countdown',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _mode == TimerMode.countdown
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _mode = TimerMode.countup),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _mode == TimerMode.countup
                          ? cs.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _mode == TimerMode.countup
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          size: 16,
                          color: _mode == TimerMode.countup
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Count Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _mode == TimerMode.countup
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 20),

        if (_mode == TimerMode.countdown) ...[
          // Countdown Presets Grid
          Text(
            'Countdown Presets',
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
        ] else ...[
          // Count Up Mode Options
          Text(
            'Milestone Target (Optional)',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  Icons.all_inclusive_rounded,
                  size: 18,
                  color: _countUpLimit == null ? cs.onPrimary : cs.primary,
                ),
                label: Text(
                  'Open Flow (No Limit)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _countUpLimit == null ? cs.onPrimary : cs.onSurface,
                  ),
                ),
                selected: _countUpLimit == null,
                selectedColor: cs.primary,
                backgroundColor: cs.surfaceContainerHigh,
                onSelected: (selected) {
                  if (selected) setState(() => _countUpLimit = null);
                },
              ),
              ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  Icons.psychology_rounded,
                  size: 18,
                  color: _countUpLimit == 1500 ? cs.onPrimary : cs.primary,
                ),
                label: Text(
                  '25m Pomodoro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _countUpLimit == 1500 ? cs.onPrimary : cs.onSurface,
                  ),
                ),
                selected: _countUpLimit == 1500,
                selectedColor: cs.primary,
                backgroundColor: cs.surfaceContainerHigh,
                onSelected: (selected) {
                  if (selected) setState(() => _countUpLimit = 1500);
                },
              ),
              ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  Icons.bolt_rounded,
                  size: 18,
                  color: _countUpLimit == 2700 ? cs.onPrimary : cs.primary,
                ),
                label: Text(
                  '45m Deep Work',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _countUpLimit == 2700 ? cs.onPrimary : cs.onSurface,
                  ),
                ),
                selected: _countUpLimit == 2700,
                selectedColor: cs.primary,
                backgroundColor: cs.surfaceContainerHigh,
                onSelected: (selected) {
                  if (selected) setState(() => _countUpLimit = 2700);
                },
              ),
              ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  Icons.alarm_rounded,
                  size: 18,
                  color: _countUpLimit == 3600 ? cs.onPrimary : cs.primary,
                ),
                label: Text(
                  '60m Sprint',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _countUpLimit == 3600 ? cs.onPrimary : cs.onSurface,
                  ),
                ),
                selected: _countUpLimit == 3600,
                selectedColor: cs.primary,
                backgroundColor: cs.surfaceContainerHigh,
                onSelected: (selected) {
                  if (selected) setState(() => _countUpLimit = 3600);
                },
              ),
            ],
          ).animate().fadeIn(delay: 150.ms),
        ],

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
                label: Text(
                  _mode == TimerMode.countup
                      ? 'Start Count Up'
                      : 'Start (${_formatDuration(_selectedSeconds)})',
                ),
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
    final payload = _mode == TimerMode.countup
        ? (_countUpLimit != null
            ? 'timer://countup?limit=$_countUpLimit'
            : 'timer://countup')
        : 'timer://$_selectedSeconds';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NfcWriteSheet(
        initialType: WriteType.text,
        initialContent: payload,
      ),
    );
  }
}
