import 'package:bro_leveling/core/widgets/app_shell.dart';
import 'package:bro_leveling/core/widgets/data_shell.dart';
import 'package:bro_leveling/features/codex/view/codex_screen.dart';
import 'package:bro_leveling/features/activity/view/aura_activity_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bro_leveling/features/auth/view/login_screen.dart';
import 'package:bro_leveling/features/dashboard/view/home_screen.dart';
import 'package:bro_leveling/features/leaderboard/view/leaderboard_screen.dart';
import 'package:bro_leveling/features/onboarding/view/onboarding_screen.dart';
import 'package:bro_leveling/features/profile/view/profile_screen.dart';
import 'package:bro_leveling/features/proposals/view/create_proposal_screen.dart';
import 'package:bro_leveling/features/proposals/view/proposals_screen.dart';
import 'package:bro_leveling/features/prestige/view/prestige_screen.dart';
import 'package:bro_leveling/features/shield/view/shield_screen.dart';
import 'package:bro_leveling/features/streak/view/streak_screen.dart';
import 'package:bro_leveling/features/chat/view/chat_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggingIn = state.uri.path == '/';

    // Not logged in → go to login
    if (session == null && !isLoggingIn) {
      return '/';
    }

    // Logged in but on login page → redirect away
    // Note: home_screen handles checking if user exists
    if (session != null && isLoggingIn) {
      return '/home';
    }

    return null;
  },
  routes: [
    // Non-shell routes (Login)
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),

    // Persistent Logic Shell (keeps data alive)
    ShellRoute(
      builder: (context, state, child) => DataShell(child: child),
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/create-proposal',
          builder: (context, state) => const CreateProposalScreen(),
        ),
        GoRoute(
          path: '/streak',
          builder: (context, state) => const StreakScreen(),
        ),
        GoRoute(
          path: '/shield',
          builder: (context, state) => const ShieldScreen(),
        ),
        GoRoute(
          path: '/codex',
          builder: (context, state) => const CodexScreen(),
        ),
        GoRoute(
          path: '/proposals',
          builder: (context, state) => const ProposalsScreen(),
        ),
        GoRoute(
          path: '/prestige',
          builder: (context, state) => const PrestigeScreen(),
        ),
        GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),

        // Shell route (persistent bottom nav)
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            // Index 0: Home
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            // Index 1: Leaderboard (Ranks)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/leaderboard',
                  builder: (context, state) => const LeaderboardScreen(),
                ),
              ],
            ),
            // Index 2: History (was 3)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/history',
                  builder: (context, state) => const AuraHistoryScreen(),
                ),
              ],
            ),
            // Index 3: Profile (was 4)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
