import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/features/locations/pages/manage_locations_page.dart';
import '../../presentation/features/radar_map/pages/weather_map_page.dart';
import '../../presentation/features/settings/pages/settings_page.dart';
import '../../presentation/features/weather/pages/weather_home_page.dart';
import '../../presentation/shell/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // 1. Weather Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'weather',
                builder: (context, state) => const WeatherHomePage(),
              ),
            ],
          ),

          // 2. Radar Map Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/radar',
                name: 'radar',
                builder: (context, state) => const WeatherMapPage(),
              ),
            ],
          ),

          // 3. Locations Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/locations',
                name: 'locations',
                builder: (context, state) => const ManageLocationsPage(),
              ),
            ],
          ),

          // 4. Settings Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
