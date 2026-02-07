import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Streak milestones per spec Section 3.
const streakMilestones = [
  (days: 7, bonus: 30),
  (days: 14, bonus: 60),
  (days: 30, bonus: 150),
  (days: 60, bonus: 300),
  (days: 100, bonus: 600),
];

/// Momentum tiers with multipliers and names
const momentumTiers = [
  (minDays: 30, multiplier: 1.5, name: 'UNSTOPPABLE', emoji: '☄️', penalty: 30),
  (minDays: 14, multiplier: 1.4, name: 'ON FIRE', emoji: '🌋', penalty: 20),
  (minDays: 7, multiplier: 1.3, name: 'HOT STREAK', emoji: '🔥', penalty: 10),
  (minDays: 5, multiplier: 1.2, name: 'WARMING UP', emoji: '🌡️', penalty: 5),
  (minDays: 3, multiplier: 1.1, name: 'BUILDING', emoji: '📈', penalty: 5),
  (minDays: 1, multiplier: 1.0, name: 'STARTING', emoji: '🌱', penalty: 0),
];

({String name, String emoji, double multiplier, int penalty, int? nextTierDays})
getMomentumTier(int streak) {
  for (final tier in momentumTiers) {
    if (streak >= tier.minDays) {
      // Find next tier
      final currentIndex = momentumTiers.indexOf(tier);
      final nextTierDays = currentIndex > 0
          ? momentumTiers[currentIndex - 1].minDays
          : null;
      return (
        name: tier.name,
        emoji: tier.emoji,
        multiplier: tier.multiplier,
        penalty: tier.penalty,
        nextTierDays: nextTierDays,
      );
    }
  }
  return (
    name: 'STARTING',
    emoji: '🌱',
    multiplier: 1.0,
    penalty: 0,
    nextTierDays: 3,
  );
}

class StreakScreen extends ConsumerWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('MOMENTUM'),
      ),
      body: userAsync.when(
        skipLoadingOnReload: true,
        skipError: true,
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                'No user data',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final currentStreak = user.streak;
          final tier = getMomentumTier(currentStreak);
          final baseGain = 25;
          final multipliedGain = (baseGain * tier.multiplier).floor();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              children: [
                // Momentum display card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _getTierColor(tier.multiplier).withAlpha(30),
                        AppColors.surface,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getTierColor(tier.multiplier).withAlpha(100),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Tier emoji
                      Text(tier.emoji, style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 8),

                      // Tier name
                      Text(
                        tier.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getTierColor(tier.multiplier),
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Streak count
                      Text(
                        '$currentStreak',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: _getTierColor(tier.multiplier),
                        ),
                      ),
                      const Text(
                        'DAY STREAK',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Multiplier badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _getTierColor(tier.multiplier).withAlpha(30),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _getTierColor(tier.multiplier),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: _getTierColor(tier.multiplier),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${tier.multiplier}x MULTIPLIER',
                              style: TextStyle(
                                color: _getTierColor(tier.multiplier),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Daily claim info with multiplier
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bolt,
                        color: AppColors.success,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Claim',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Base +$baseGain × ${tier.multiplier}',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+$multipliedGain',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Next tier progress (if not at max)
                if (tier.nextTierDays != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Next Tier: ${getMomentumTier(tier.nextTierDays!).name}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${tier.nextTierDays! - currentStreak} days',
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: currentStreak / tier.nextTierDays!,
                            backgroundColor: AppColors.surfaceLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getTierColor(
                                getMomentumTier(tier.nextTierDays!).multiplier,
                              ),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Warning with penalty info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tier.penalty > 0
                              ? 'Missing a day resets momentum and costs -${tier.penalty} Aura!'
                              : 'Missing a day resets your momentum to 1.0x',
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Momentum tiers explanation
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MOMENTUM TIERS',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Momentum tiers list
                ...momentumTiers.reversed.map(
                  (t) => _buildMomentumTier(
                    t.minDays,
                    t.multiplier,
                    t.name,
                    t.emoji,
                    t.penalty,
                    currentStreak,
                  ),
                ),

                const SizedBox(height: 24),

                // Milestones header
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'STREAK MILESTONES (BONUS)',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Milestones list
                ...streakMilestones.map(
                  (m) => _buildMilestone(m.days, m.bonus, currentStreak),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error: $err',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
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

  Color _getTierColor(double multiplier) {
    if (multiplier >= 1.5) return const Color(0xFFFF6B35); // Orange/Flame
    if (multiplier >= 1.4) return const Color(0xFFFF8C42); // Light orange
    if (multiplier >= 1.3) return AppColors.warning; // Yellow/Gold
    if (multiplier >= 1.2) return const Color(0xFF4ECDC4); // Teal
    if (multiplier >= 1.1) return AppColors.success; // Green
    return AppColors.textMuted; // Grey
  }

  Widget _buildMomentumTier(
    int minDays,
    double multiplier,
    String name,
    String emoji,
    int penalty,
    int currentStreak,
  ) {
    final isActive = currentStreak >= minDays;
    final tierColor = _getTierColor(multiplier);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? tierColor.withAlpha(20) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? Border.all(color: tierColor.withAlpha(100)) : null,
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isActive ? tierColor : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$minDays+ days${penalty > 0 ? ' • -$penalty if broken' : ''}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? tierColor : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${multiplier}x',
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textMuted,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestone(int days, int bonus, int currentStreak) {
    final isReached = currentStreak >= days;
    final isNext =
        !isReached &&
        streakMilestones
            .where((m) => m.days < days && currentStreak < m.days)
            .isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isReached ? AppColors.gold.withAlpha(20) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: AppColors.gold, width: 2)
            : isReached
            ? Border.all(color: AppColors.gold.withAlpha(50))
            : null,
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isReached ? AppColors.gold : AppColors.surfaceLight,
            ),
            child: Icon(
              isReached ? Icons.check : Icons.lock_outline,
              color: isReached ? AppColors.background : AppColors.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Days
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$days Days',
                  style: TextStyle(
                    color: isReached ? AppColors.gold : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (isNext && currentStreak < days)
                  Text(
                    '${days - currentStreak} days to go',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          // Bonus
          Text(
            '+$bonus',
            style: TextStyle(
              color: isReached ? AppColors.gold : AppColors.textSecondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
