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
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            backgroundColor: isDark ? const Color(0xFF0E111A) : Colors.white,
            elevation: 0,
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            indicatorColor: cs.primary.withValues(alpha: 0.1),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: cs.primary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: const Icon(Icons.widgets_outlined),
                selectedIcon: Icon(Icons.widgets_rounded, color: cs.primary),
                label: 'Templates',
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded, color: cs.primary),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
