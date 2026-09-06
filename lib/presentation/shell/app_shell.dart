import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/floating_glass_nav_bar.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: FloatingGlassNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onDestinationSelected,
        items: [
          FloatingNavItem(
            icon: Icons.wb_sunny_outlined,
            activeIcon: Icons.wb_sunny_rounded,
            label: l10n?.navWeather ?? 'Weather',
          ),
          FloatingNavItem(
            icon: Icons.radar_outlined,
            activeIcon: Icons.radar_rounded,
            label: l10n?.navRadar ?? 'Radar',
          ),
          FloatingNavItem(
            icon: Icons.bookmark_border_rounded,
            activeIcon: Icons.bookmark_rounded,
            label: l10n?.navLocations ?? 'Locations',
          ),
          FloatingNavItem(
            icon: Icons.tune_rounded,
            activeIcon: Icons.tune_rounded,
            label: l10n?.navSettings ?? 'Settings',
          ),
        ],
      ),
    );
  }
}
