import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShieldScreen extends ConsumerWidget {
  const ShieldScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('AURA SHIELD'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                'User not found',
                style: TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          // Calculate shield status
          final now = DateTime.now();
          final lastUsed = user.lastShieldUsed;

          // Logic: Reset every Monday at 00:00
          // Find most recent Monday
          final daysSinceMonday = now.weekday - 1;
          final lastMonday = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: daysSinceMonday));

          final isUsedThisWeek =
              lastUsed != null && lastUsed.isAfter(lastMonday);
          final nextMonday = lastMonday.add(const Duration(days: 7));
          final timeUntilReset = nextMonday.difference(now);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 48),
                // Shield Graphic
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUsedThisWeek
                        ? AppColors.textMuted.withAlpha(20)
                        : AppColors.success.withAlpha(20),
                    boxShadow: [
                      BoxShadow(
                        color: isUsedThisWeek
                            ? Colors.black.withAlpha(50)
                            : AppColors.success.withAlpha(50),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.security,
                    size: 100,
                    color: isUsedThisWeek
                        ? AppColors.textMuted
                        : AppColors.success,
                  ),
                ),
                const SizedBox(height: 32),

                // Status Text
                Text(
                  isUsedThisWeek ? 'SHIELD DELETED' : 'SHIELD ACTIVE',
                  style: TextStyle(
                    color: isUsedThisWeek
                        ? AppColors.textMuted
                        : AppColors.success,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),

                // Description/Timer
                if (isUsedThisWeek) ...[
                  const Text(
                    'You have used your shield this week.\nIt will regenerate in:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimerText(timeUntilReset),
                ] else
                  const Text(
                    'Your shield is ready.\n\nUsage:\nBlocks ONE penalty proposal per week.\nMust be activated within 1 hour of approval.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerText(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeBox(days.toString(), 'DAYS'),
        const SizedBox(width: 16),
        _buildTimeBox(hours.toString().padLeft(2, '0'), 'HRS'),
        const SizedBox(width: 16),
        _buildTimeBox(minutes.toString().padLeft(2, '0'), 'MIN'),
      ],
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
