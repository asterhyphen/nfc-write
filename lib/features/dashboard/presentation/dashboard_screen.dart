import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/background_nfc_manager.dart';
import '../../../core/widgets/bouncy_tap.dart';
import '../../templates/presentation/templates_tab.dart';
import '../../settings/presentation/settings_tab.dart';
import 'home_tab.dart';

/// Root shell with an Apple frosted glass floating capsule bottom navigation bar.
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
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1C1C1E).withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.06),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AppleTabItem(
                    icon: CupertinoIcons.house_fill,
                    unselectedIcon: CupertinoIcons.house,
                    label: 'Home',
                    isSelected: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                  _AppleTabItem(
                    icon: CupertinoIcons.square_grid_2x2_fill,
                    unselectedIcon: CupertinoIcons.square_grid_2x2,
                    label: 'Templates',
                    isSelected: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                  _AppleTabItem(
                    icon: CupertinoIcons.gear_alt_fill,
                    unselectedIcon: CupertinoIcons.gear_alt,
                    label: 'Settings',
                    isSelected: _currentIndex == 2,
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppleTabItem extends StatelessWidget {
  final IconData icon;
  final IconData unselectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppleTabItem({
    required this.icon,
    required this.unselectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;
    final activeColor = cs.primary;
    const inactiveColor = Color(0xFF8E8E93);

    return Expanded(
      child: BouncyTap(
        onTap: onTap,
        scaleDown: 0.92,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? activeColor.withValues(alpha: 0.16)
                    : activeColor.withValues(alpha: 0.10))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.10 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: Icon(
                  isSelected ? icon : unselectedIcon,
                  size: 23,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
