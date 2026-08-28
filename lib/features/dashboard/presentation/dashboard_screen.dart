import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/presentation/settings_tab.dart';
import '../../templates/presentation/templates_tab.dart';
import '../../../core/config/background_nfc_manager.dart';
import 'home_tab.dart';

/// Root shell widget with a premium floating [NavigationBar].
///
/// Each tab is lazily kept alive via [IndexedStack].
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BackgroundNfcManager.initialize(ref, context);
    });
  }

  static const List<Widget> _tabs = [
    HomeDashboardTab(),
    TemplatesTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _currentIndex, children: _tabs),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0E111A) : Colors.white,
          border: Border(
            top: BorderSide(
              color: cs.outline,
              width: 1.0,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: isDark ? const Color(0xFF0E111A) : Colors.white,
          elevation: 0,
          height: 70,
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorColor: cs.primary.withValues(alpha: 0.08),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined, size: 22),
              selectedIcon: Icon(Icons.home_rounded, size: 22, color: cs.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.widgets_outlined, size: 22),
              selectedIcon: Icon(Icons.widgets_rounded, size: 22, color: cs.primary),
              label: 'Templates',
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined, size: 22),
              selectedIcon: Icon(Icons.settings_rounded, size: 22, color: cs.primary),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
