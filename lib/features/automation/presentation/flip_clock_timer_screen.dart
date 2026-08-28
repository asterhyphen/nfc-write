import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'timer_notifier.dart';

/// Immersive Fullscreen Flip-Clock timer screen.
/// Forces landscape orientation and locks it, displaying a skeuomorphic 3D flip card countdown.
class FlipClockTimerScreen extends ConsumerStatefulWidget {
  const FlipClockTimerScreen({super.key});

  /// Custom transition route that rotates the screen open into landscape.
  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const FlipClockTimerScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final rotate = Tween<double>(begin: 0.15, end: 0.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );
        final scale = Tween<double>(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeIn),
        );

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: RotationTransition(
              turns: rotate,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  ConsumerState<FlipClockTimerScreen> createState() => _FlipClockTimerScreenState();
}

class _FlipClockTimerScreenState extends ConsumerState<FlipClockTimerScreen> with TickerProviderStateMixin {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  // Background gradient shift animation controllers
  late final AnimationController _gradientCtrl;
  late final Animation<double> _gradientAnim;

  @override
  void initState() {
    super.initState();
    // Force and lock landscape orientation on entry
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Fullscreen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Slowly shift gradient colors
    _gradientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
    _gradientAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_gradientCtrl);

    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _tickerDispose();
    super.dispose();
  }

  void _tickerDispose() {
    _hideControlsTimer?.cancel();
    _gradientCtrl.dispose();
    // Restore default orientation on exit
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _onScreenTap() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _handleCancel(BuildContext context) {
    final timerState = ref.read(timerProvider);
    if (timerState.isFinished) {
      ref.read(timerProvider.notifier).reset();
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Timer?'),
        content: const Text('Are you sure you want to stop the active focus session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continue Session'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(timerProvider.notifier).reset();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Cancel Timer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final cs = Theme.of(context).colorScheme;

    // Trigger haptics and display finished overlay if completed
    if (timerState.isFinished) {
      HapticFeedback.heavyImpact();
    }

    // Urgency pulse in the final 10 seconds
    final isUrgent = timerState.remainingSeconds <= 10 && timerState.isRunning;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onScreenTap,
        child: Stack(
          children: [
            // ── Background Animated Gradient ────────────────────────
            AnimatedBuilder(
              animation: _gradientAnim,
              builder: (ctx, child) {
                final hueVal = _gradientAnim.value;
                final col1 = isUrgent
                    ? Colors.red.withValues(alpha: 0.15 + (math.sin(hueVal * math.pi * 8) * 0.05))
                    : HSLColor.fromAHSL(0.18, (hueVal * 360) % 360, 0.65, 0.45).toColor();
                final col2 = isUrgent
                    ? const Color(0xFF1E0505)
                    : HSLColor.fromAHSL(0.12, ((hueVal * 360) + 120) % 360, 0.5, 0.2).toColor();

                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [col1, col2, Colors.black],
                      radius: 1.4,
                      center: Alignment.center,
                    ),
                  ),
                );
              },
            ),

            // ── Progress indicator bar at the top ────────────────────
            if (timerState.duration > 0 && !timerState.isFinished)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: timerState.remainingSeconds / timerState.duration,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isUrgent ? Colors.redAccent : cs.primary.withValues(alpha: 0.7),
                  ),
                  minHeight: 5,
                ),
              ),

            // ── Flip Clock Display ───────────────────────────────────
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timerState.label.toUpperCase(),
                    style: TextStyle(
                      color: isUrgent
                          ? Colors.redAccent
                          : cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4.0,
                      shadows: isUrgent
                          ? [const Shadow(color: Colors.red, blurRadius: 10)]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FlipClockDisplay(
                    seconds: timerState.remainingSeconds,
                    isUrgent: isUrgent,
                    isFinished: timerState.isFinished,
                  ),
                ],
              ),
            ),

            // ── Frosted Overlay Controls ──────────────────────────────
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showControls || timerState.isFinished ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AbsorbPointer(
                  absorbing: !_showControls && !timerState.isFinished,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Close/Cancel
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => _handleCancel(context),
                                tooltip: 'Cancel Session',
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 1.5,
                                height: 28,
                                color: Colors.white10,
                              ),
                              const SizedBox(width: 16),
                              // Play / Pause
                              if (timerState.isFinished)
                                FilledButton.icon(
                                  onPressed: () {
                                    ref.read(timerProvider.notifier).reset();
                                    Navigator.pop(context);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.done),
                                  label: const Text('Dismiss'),
                                )
                              else
                                FloatingActionButton.small(
                                  heroTag: 'flip_play_pause',
                                  elevation: 0,
                                  backgroundColor: timerState.isPaused ? cs.primary : Colors.white24,
                                  foregroundColor: timerState.isPaused ? cs.onPrimary : Colors.white,
                                  onPressed: () {
                                    final notifier = ref.read(timerProvider.notifier);
                                    if (timerState.isPaused) {
                                      notifier.resume();
                                    } else {
                                      notifier.pause();
                                    }
                                    _startHideControlsTimer();
                                  },
                                  child: Icon(
                                    timerState.isPaused ? Icons.play_arrow : Icons.pause,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Composed Flip-Clock Row Display ──────────────────────────────────────────

class FlipClockDisplay extends StatelessWidget {
  final int seconds;
  final bool isUrgent;
  final bool isFinished;

  const FlipClockDisplay({
    super.key,
    required this.seconds,
    required this.isUrgent,
    required this.isFinished,
  });

  @override
  Widget build(BuildContext context) {
    final hrs = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final showHrs = hrs > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showHrs) ...[
          FlipDigitPair(value: hrs, isUrgent: isUrgent, isFinished: isFinished),
          _divider(),
        ],
        FlipDigitPair(value: mins, isUrgent: isUrgent, isFinished: isFinished),
        _divider(),
        FlipDigitPair(value: secs, isUrgent: isUrgent, isFinished: isFinished),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isUrgent ? Colors.redAccent : Colors.white70,
              shape: BoxShape.circle,
              boxShadow: isUrgent
                  ? [const BoxShadow(color: Colors.red, blurRadius: 10, spreadRadius: 1)]
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isUrgent ? Colors.redAccent : Colors.white70,
              shape: BoxShape.circle,
              boxShadow: isUrgent
                  ? [const BoxShadow(color: Colors.red, blurRadius: 10, spreadRadius: 1)]
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pair of Digits Widget (Tens & Ones) ───────────────────────────────────────

class FlipDigitPair extends StatelessWidget {
  final int value;
  final bool isUrgent;
  final bool isFinished;

  const FlipDigitPair({
    super.key,
    required this.value,
    required this.isUrgent,
    required this.isFinished,
  });

  @override
  Widget build(BuildContext context) {
    final tens = (value.clamp(0, 99) ~/ 10);
    final ones = value % 10;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlipDigit(value: tens, isUrgent: isUrgent, isFinished: isFinished),
        const SizedBox(width: 6),
        FlipDigit(value: ones, isUrgent: isUrgent, isFinished: isFinished),
      ],
    );
  }
}

// ── Realistic Split-Flap 3D FlipDigit Widget ─────────────────────────────────

class FlipDigit extends StatefulWidget {
  final int value;
  final bool isUrgent;
  final bool isFinished;

  const FlipDigit({
    super.key,
    required this.value,
    required this.isUrgent,
    required this.isFinished,
  });

  @override
  State<FlipDigit> createState() => _FlipDigitState();
}

class _FlipDigitState extends State<FlipDigit> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _prev = 0;
  int _curr = 0;

  @override
  void initState() {
    super.initState();
    _curr = widget.value;
    _prev = widget.value;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void didUpdateWidget(covariant FlipDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _curr) {
      _prev = _curr;
      _curr = widget.value;
      _ctrl.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final val = _ctrl.value;

        // Split-flap arrangement
        return SizedBox(
          width: 72,
          height: 100,
          child: Stack(
            children: [
              // 1. Back upper card (shows the next value)
              _cardPanel(_curr, Alignment.topCenter),

              // 2. Back lower card (shows the old value)
              _cardPanel(_prev, Alignment.bottomCenter),

              // 3. Falling front card (flip from top to bottom)
              if (val < 0.5)
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0025)
                    ..rotateX(val * math.pi),
                  alignment: Alignment.bottomCenter,
                  child: _cardPanel(_prev, Alignment.topCenter),
                )
              else
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0025)
                    ..rotateX((val - 1.0) * math.pi),
                  alignment: Alignment.topCenter,
                  child: _cardPanel(_curr, Alignment.bottomCenter),
                ),

              // Horizontal center cut divider
              Center(
                child: Container(
                  height: 2.0,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cardPanel(int digitValue, Alignment alignment) {
    final textColor = widget.isFinished
        ? const Color(0xFF10B981)
        : (widget.isUrgent ? Colors.redAccent : Colors.white);

    return Align(
      alignment: alignment,
      child: ClipRect(
        child: Align(
          alignment: alignment == Alignment.topCenter ? Alignment.topCenter : Alignment.bottomCenter,
          heightFactor: 0.5,
          child: Container(
            width: 72,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF27272A), Color(0xFF09090B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$digitValue',
                style: TextStyle(
                  fontSize: 76,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  color: textColor,
                  height: 1.0,
                  shadows: widget.isUrgent || widget.isFinished
                      ? [BoxShadow(color: textColor.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 1)]
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
