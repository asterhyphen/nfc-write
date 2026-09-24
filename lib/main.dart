import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/router.dart';
import 'core/theme/app_theme.dart';
import 'features/automation/data/native_timer_service.dart';
import 'features/automation/presentation/timer_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TipTapTupApp()));
}

class TipTapTupApp extends ConsumerStatefulWidget {
  const TipTapTupApp({super.key});

  @override
  ConsumerState<TipTapTupApp> createState() => _TipTapTupAppState();
}

class _TipTapTupAppState extends ConsumerState<TipTapTupApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(timerProvider.notifier).sync();
      NativeTimerService.hideOngoingNotification();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      final timerState = ref.read(timerProvider);
      if (timerState.isRunning &&
          !timerState.isPaused &&
          !timerState.isFinished) {
        if (timerState.mode == TimerMode.countdown &&
            timerState.targetEndTime != null) {
          NativeTimerService.showOngoingNotification(
            whenTime: timerState.targetEndTime!,
            label: timerState.label,
            isCountdown: true,
          );
        } else if (timerState.mode == TimerMode.countup &&
            timerState.startTime != null) {
          NativeTimerService.showOngoingNotification(
            whenTime: timerState.startTime!,
            label: timerState.label,
            isCountdown: false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'TipTapTup',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
