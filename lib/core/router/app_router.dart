import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../features/explore/presentation/pages/explore_map_page.dart';
import '../../features/property_detail/presentation/pages/property_detail_page.dart';
import '../../features/saved/presentation/pages/saved_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// Named route constants
class AppRoutes {
  AppRoutes._();
  static const String onboarding = '/onboarding';
  static const String shell = '/';
  static const String explore = '/explore';
  static const String propertyDetail = '/explore/property/:id';
  static const String saved = '/saved';
  static const String profile = '/profile';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  debugLogDiagnostics: false,
  routes: [
    // ── Onboarding ────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => _fadeTransition(
        key: state.pageKey,
        child: const OnboardingPage(),
      ),
    ),

    // ── Main Shell (with BottomNav) ────────────────────────────────
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, shell) => _fadeTransition(
        key: state.pageKey,
        child: ShellPage(navigationShell: shell),
      ),
      branches: [
        // Explore tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              pageBuilder: (context, state) => _fadeTransition(
                key: state.pageKey,
                child: const ExploreMapPage(),
              ),
              routes: [
                GoRoute(
                  path: 'property/:id',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return _slideTransition(
                      key: state.pageKey,
                      child: PropertyDetailPage(propertyId: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // Saved tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/saved',
              pageBuilder: (context, state) => _fadeTransition(
                key: state.pageKey,
                child: const SavedPage(),
              ),
            ),
          ],
        ),

        // Trips tab (placeholder)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/trips',
              pageBuilder: (context, state) => _fadeTransition(
                key: state.pageKey,
                child: const SavedPage(mode: SavedMode.trips),
              ),
            ),
          ],
        ),

        // Profile tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => _fadeTransition(
                key: state.pageKey,
                child: const ProfilePage(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],

  // Redirect first time users to onboarding
  redirect: (context, state) => null,

  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  ),
);

// ── Transition helpers ─────────────────────────────────────────────

CustomTransitionPage<void> _fadeTransition({
  required LocalKey key,
  required Widget child,
}) =>
    CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );

CustomTransitionPage<void> _slideTransition({
  required LocalKey key,
  required Widget child,
}) =>
    CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );
