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
        title: const Text('STREAK'),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              children: [
                // Current streak display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.warning.withAlpha(100)),
                  ),
                  child: Column(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(
                        '$currentStreak',
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
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
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Daily reward info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.success,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Claim',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '+10 Aura per day',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+10',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Warning
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withAlpha(50)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Missing a day resets your streak to 0',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Milestones header
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'STREAK MILESTONES',
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
