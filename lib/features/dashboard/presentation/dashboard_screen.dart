import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final activeBg = isDark ? cs.primary.withValues(alpha: 0.15) : const Color(0xFFEDEEFE);
    final inactiveColor = isDark ? const Color(0xFF5C5C66) : const Color(0xFFA6A6B0);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _currentIndex, children: _tabs),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF17171D) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isDark ? const Color(0xFF28282F) : const Color(0xFFECECF2),
            width: 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                      letterSpacing: 0.04 * 11,
                    );
                  }
                  return GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: inactiveColor,
                    letterSpacing: 0.04 * 11,
                  );
                }),
              ),
            ),
            child: NavigationBar(
              backgroundColor: isDark ? const Color(0xFF17171D) : Colors.white,
              elevation: 0,
              height: 64,
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) => setState(() => _currentIndex = i),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              indicatorColor: activeBg,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, size: 22, color: inactiveColor),
                  selectedIcon: Icon(Icons.home_rounded, size: 22, color: cs.primary),
                  label: 'HOME',
                ),
                NavigationDestination(
                  icon: Icon(Icons.widgets_outlined, size: 22, color: inactiveColor),
                  selectedIcon: Icon(Icons.widgets_rounded, size: 22, color: cs.primary),
                  label: 'TEMPLATES',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined, size: 22, color: inactiveColor),
                  selectedIcon: Icon(Icons.settings_rounded, size: 22, color: cs.primary),
                  label: 'SETTINGS',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
