import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/utils/aura_utils.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';

import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:bro_leveling/features/dashboard/data/user_repository.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasCheckedOnboarding = false;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  Future<void> _checkOnboarding() async {
    if (_hasCheckedOnboarding) return;
    _hasCheckedOnboarding = true;

    final exists = await ref.read(userRepositoryProvider).userExists();
    if (!exists && mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      skipLoadingOnReload: true,
      skipError: true,
      data: (user) {
        if (user == null) {
          _checkOnboarding();
          return Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          );
        }

        final title = getTitle(user.aura, isHim: user.isHim);
        final auraColor = getAuraColor(user.aura, isBroken: user.isBroken);

        return Scaffold(
          backgroundColor: AppColors.background,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: Text(
              user.username.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                letterSpacing: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            actions: [
              // Codex Button
              IconButton(
                onPressed: () => context.push('/codex'),
                icon: const Icon(Icons.menu_book, color: AppColors.textPrimary),
              ),
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Broken badge
                        if (user.isBroken)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: AppColors.error.withAlpha(50),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.error),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: AppColors.error,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'BROKEN',
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Title - bold Orbitron, no container
                        Text(
                          title.toUpperCase(),
                          style: GoogleFonts.orbitron(
                            color: auraColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 42),

                        // Aura display with glow - scalable for large numbers
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface,
                            boxShadow: [
                              BoxShadow(
                                color: auraColor.withAlpha(80),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Text(
                            _formatAura(user.aura),
                            style: GoogleFonts.orbitron(
                              fontSize: _getAuraFontSize(user.aura),
                              fontWeight: FontWeight.bold,
                              color: auraColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'AURA',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            letterSpacing: 6,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Claim daily button
                        SizedBox(
                          width: 200,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: user.isBroken
                                ? null
                                : () => _claimDaily(context),
                            child: const Text(
                              'CLAIM DAILY',
                              style: TextStyle(letterSpacing: 2),
                            ),
                          ),
                        ),

                        if (user.isBroken) ...[
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => _claimRecovery(context),
                            child: const Text('Claim Weekly Recovery (+25)'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 16,
                  right: 24,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Indestructible Virgin Mode
                      if (_isIndestructible(user.indestructibleUntil))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.success),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withAlpha(50),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user,
                                size: 16,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'INDESTRUCTIBLE',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Shield Indicator
                      GestureDetector(
                        onTap: () => context.push('/streak'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                '${user.streak}',
                                style: const TextStyle(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Streak indicator - tappable
                      GestureDetector(
                        onTap: () => context.push('/shield'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background.withAlpha(150),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.gold.withAlpha(50),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.security,
                                size: 20,
                                color: _isShieldActive(user.lastShieldUsed)
                                    ? AppColors.success
                                    : AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error: $err',
                style: const TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.invalidate(userProvider),
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Format aura for display (e.g., 10,000 or 10K)
  String _formatAura(int aura) {
    if (aura >= 10000) {
      return '${(aura / 1000).toStringAsFixed(1)}K';
    }
    return '$aura';
  }

  // Dynamic font size based on digit count
  double _getAuraFontSize(int aura) {
    if (aura >= 100000) return 26;
    if (aura >= 10000) return 38;
    if (aura >= 1000) return 46;
    return 62;
  }

  Future<void> _claimDaily(BuildContext context) async {
    try {
      final result = await ref.read(userRepositoryProvider).claimDaily();
      if (context.mounted) {
        final bonus = result['milestone_bonus'] ?? 0;
        final message = bonus > 0
            ? 'Daily claimed! +${result['aura_gained']} (including +$bonus milestone bonus!)'
            : 'Daily claimed! +${result['aura_gained']} Aura';
        showAuraSnackbar(context, message, type: SnackType.success);
      }
    } catch (e) {
      if (context.mounted) {
        showAuraSnackbar(context, e.toString(), type: SnackType.error);
      }
    }
  }

  Future<void> _claimRecovery(BuildContext context) async {
    try {
      await ref.read(userRepositoryProvider).claimWeeklyRecovery();
      if (context.mounted) {
        showAuraSnackbar(
          context,
          'Recovery claimed! +25 Aura',
          type: SnackType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showAuraSnackbar(context, 'Error: $e', type: SnackType.error);
      }
    }
  }

  bool _isShieldActive(DateTime? lastShieldUsed) {
    if (lastShieldUsed == null) return true;
    final now = DateTime.now();
    // Monday 00:00 of current week
    final daysSinceMonday = now.weekday - 1;
    final lastMonday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: daysSinceMonday));
    return lastShieldUsed.isBefore(lastMonday);
  }

  bool _isIndestructible(DateTime? indestructibleUntil) {
    if (indestructibleUntil == null) return false;
    return DateTime.now().isBefore(indestructibleUntil);
  }
}
