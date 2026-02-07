import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/utils/aura_utils.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';

import 'package:bro_leveling/features/bounty/view/bounty_card.dart';
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:bro_leveling/features/dashboard/logic/user_logic.dart';

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
  bool _isClaimingDaily = false;
  bool _isClaimingRecovery = false;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  Future<void> _checkOnboarding() async {
    if (_hasCheckedOnboarding) return;
    _hasCheckedOnboarding = true;

    final exists = await ref.read(userLogicProvider).checkUserExists();
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
            scrolledUnderElevation: 0,
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
                onPressed: () => context.go('/codex'),
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
                                  'AURALESS',
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

                        if (_isIndestructible(user.indestructibleUntil))
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'INDESTRUCTIBLE VIRGIN',
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                // parse to readable time in 12 hour format
                                'Until: ${user.indestructibleUntil?.toLocal().toString().split('.')[0] ?? ''}',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 48),

                        // Claim daily button
                        SizedBox(
                          width: 200,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                (_isClaimingDaily ||
                                    user.isBroken ||
                                    _hasClaimedToday(user.lastDailyClaim))
                                ? null
                                : () => _claimDaily(context),
                            child: _isClaimingDaily
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.background,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _hasClaimedToday(user.lastDailyClaim)
                                        ? 'CLAIMED'
                                        : 'CLAIM DAILY',
                                    style: const TextStyle(letterSpacing: 2),
                                  ),
                          ),
                        ),

                        if (user.isBroken) ...[
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _isClaimingRecovery
                                ? null
                                : () => _claimRecovery(context),
                            child: _isClaimingRecovery
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Claim Weekly Recovery (+25)'),
                          ),
                        ],

                        // Bounty card
                        const SizedBox(height: 32),
                        const BountyCard(),
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
                      // Momentum indicator - tappable
                      GestureDetector(
                        onTap: () => context.go('/streak'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: user.momentumMultiplier >= 1.3
                                ? Border.all(
                                    color: AppColors.warning.withAlpha(100),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user.momentumMultiplier >= 1.5
                                    ? '☄️'
                                    : user.momentumMultiplier >= 1.3
                                    ? '🔥'
                                    : user.momentumMultiplier >= 1.1
                                    ? '📈'
                                    : '🌱',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${user.streak}',
                                style: const TextStyle(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withAlpha(30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${user.momentumMultiplier}x',
                                  style: const TextStyle(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Streak indicator - tappable
                      GestureDetector(
                        onTap: () => context.go('/shield'),
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
                      // Prestige indicator - tappable
                      if (user.ascensionCount > 0 || user.aura >= 300)
                        GestureDetector(
                          onTap: () => context.go('/prestige'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: user.ascensionCount > 0
                                  ? AppColors.gold.withAlpha(30)
                                  : AppColors.background.withAlpha(150),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: user.ascensionCount > 0
                                    ? AppColors.gold.withAlpha(100)
                                    : AppColors.gold.withAlpha(50),
                              ),
                            ),
                            child: Row(
                              children: [
                                ...List.generate(
                                  3,
                                  (i) => Icon(
                                    i < user.ascensionCount
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 16,
                                    color: i < user.ascensionCount
                                        ? AppColors.gold
                                        : AppColors.textMuted,
                                  ),
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
    setState(() => _isClaimingDaily = true);
    try {
      final logic = ref.read(userLogicProvider);

      // We still need to check state for the specific "Indestructible" snackbar message
      // as it depends on before/after values.
      final currentUser = ref.read(userProvider).asData?.value;
      final wasIndestructible = _isIndestructible(
        currentUser?.indestructibleUntil,
      );

      final result = await logic.claimDaily();

      // The stream will naturally update the UI, but we want the snackbar with custom logic.
      if (context.mounted) {
        final bonus = result['milestone_bonus'] ?? 0;
        final auraGained = result['aura_gained'];
        final multiplier = result['momentum_multiplier'] ?? 1.0;
        final penalty = result['momentum_penalty'] ?? 0;
        final brokeMomentum = result['broke_momentum'] ?? false;

        // Get updated state from stream
        final updatedUser = ref.read(userProvider).asData?.value;
        final isNowIndestructible = _isIndestructible(
          updatedUser?.indestructibleUntil,
        );

        String message;
        if (brokeMomentum && penalty > 0) {
          message =
              '⚠️ Momentum broken! -$penalty penalty\nNet gain: +$auraGained Aura';
        } else if (bonus > 0) {
          message =
              '🎉 Daily claimed! +$auraGained (×$multiplier + $bonus milestone!)';
        } else if (multiplier > 1.0) {
          message =
              '🔥 Daily claimed! +$auraGained Aura (${multiplier}x momentum!)';
        } else {
          message = 'Daily claimed! +$auraGained Aura';
        }

        if (!wasIndestructible && isNowIndestructible) {
          message +=
              '\n🛡️ INDESTRUCTIBLE VIRGIN MODE ACTIVATED! (12h Immunity)';
        }

        showAuraSnackbar(
          context,
          message,
          type: brokeMomentum ? SnackType.warning : SnackType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showAuraSnackbar(context, e.toString(), type: SnackType.error);
      }
    } finally {
      if (mounted) setState(() => _isClaimingDaily = false);
    }
  }

  Future<void> _claimRecovery(BuildContext context) async {
    setState(() => _isClaimingRecovery = true);
    try {
      await ref.read(userLogicProvider).claimWeeklyRecovery();
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
    } finally {
      if (mounted) setState(() => _isClaimingRecovery = false);
    }
  }

  bool _isShieldActive(DateTime? lastShieldUsed) {
    if (lastShieldUsed == null) return true;
    final now = DateTime.now();
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

  bool _hasClaimedToday(DateTime? lastDailyClaim) {
    if (lastDailyClaim == null) return false;
    final now = DateTime.now();
    return lastDailyClaim.year == now.year &&
        lastDailyClaim.month == now.month &&
        lastDailyClaim.day == now.day;
  }
}
