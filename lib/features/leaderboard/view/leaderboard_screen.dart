import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/utils/aura_utils.dart';
import 'package:bro_leveling/features/dashboard/data/user_model.dart';
import 'package:bro_leveling/features/leaderboard/logic/leaderboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('LEADERBOARD'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: leaderboardAsync.when(
        skipLoadingOnReload: true,
        skipError: true,
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No users yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          // Find "HIM"
          final himUser = users.where((u) => u.isHim).firstOrNull;
          // Filter out HIM from the main list if desired, or keep them.
          // "show him seperate from the board... although we still maintain the leaderboard"
          // If we remove him, the ranks change. If we keep him, he appears twice.
          // Let's remove him from the list visual but keep the rank logic? Use original index.

          return CustomScrollView(
            slivers: [
              if (himUser != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildHimCard(himUser, users.indexOf(himUser) + 1),
                  ),
                ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final user = users[index];
                    // If this is the HIM user and we already showed them, maybe skip?
                    // But "maintain leaderboard" usually implies the full list.
                    // Let's keep them in the list but maybe highlight them or just let them be.
                    // User said "show him seperate... even."
                    // I will skip rendering the HIM user in the main list to avoid duplication.
                    if (user.isHim) return const SizedBox.shrink();

                    final rank = index + 1;
                    return _buildUserCard(user, rank);
                  }, childCount: users.length),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildHimCard(UserModel user, int rank) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.gold.withAlpha(20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withAlpha(50),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.gold,
            child: Text(
              user.username[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.username,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'HIM',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (user.indestructibleUntil != null &&
              user.indestructibleUntil!.isAfter(DateTime.now()))
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(200),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: AppColors.success, blurRadius: 10),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'INDESTRUCTIBLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '${user.aura}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                    ),
                  ),
                  const Text(
                    'AURA',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user, int rank) {
    final title = getTitle(user.aura, isHim: user.isHim);
    final auraColor = getAuraColor(user.aura, isBroken: user.isBroken);
    final isIndestructible =
        user.indestructibleUntil != null &&
        user.indestructibleUntil!.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: rank <= 3
            ? Border.all(
                color: rank == 1
                    ? AppColors.gold
                    : rank == 2
                    ? const Color(0xFFC0C0C0)
                    : const Color(0xFFCD7F32),
                width: 2,
              )
            : null,
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40,
            child: Text(
              rank <= 3 ? _getRankEmoji(rank) : '#$rank',
              style: TextStyle(
                fontSize: rank <= 3 ? 24 : 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: auraColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: auraColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (user.isBroken)
                      const Text('💀', style: TextStyle(fontSize: 12)),

                    if (isIndestructible)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.auraHigh.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.auraHigh,
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user,
                              size: 10,
                              color: AppColors.auraHigh,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'INDESTRUCTIBLE',
                              style: TextStyle(
                                color: AppColors.auraHigh,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Aura
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.aura}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: auraColor,
                ),
              ),
              const Text(
                'AURA',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '👑';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '$rank';
    }
  }
}
