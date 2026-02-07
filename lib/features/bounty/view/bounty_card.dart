import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/features/bounty/logic/bounty_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Collapsible bounty card for home screen
class BountyCard extends ConsumerStatefulWidget {
  const BountyCard({super.key});

  @override
  ConsumerState<BountyCard> createState() => _BountyCardState();
}

class _BountyCardState extends ConsumerState<BountyCard> {
  bool _isExpanded = false;
  String? _claimingId;

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(bountyProgressProvider);

    final totalComplete = status.readyToClaimCount;
    final totalBounties =
        status.dailyBounties.length + status.weeklyBounties.length;

    if (totalBounties == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: totalComplete > 0
            ? Border.all(color: AppColors.gold.withAlpha(150), width: 1.5)
            : null,
        boxShadow: totalComplete > 0
            ? [
                BoxShadow(
                  color: AppColors.gold.withAlpha(30),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildMasteryBadge(status.level),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'BOUNTY MASTERY',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1,
                                  ),
                                ),
                                if (totalComplete > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.gold,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '$totalComplete READY',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            _buildXpBar(status.currentXp, status.nextLevelXp),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (_isExpanded) ...[
            const Divider(height: 1, color: AppColors.surfaceLight),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('DAILY MISSIONS'),
                  const SizedBox(height: 8),
                  ...status.dailyBounties.entries.map(
                    (e) => _buildBountyItem(e.key, e.value),
                  ),

                  const SizedBox(height: 16),

                  _buildSectionHeader('WEEKLY CHALLENGES'),
                  const SizedBox(height: 8),
                  ...status.weeklyBounties.entries.map(
                    (e) => _buildBountyItem(e.key, e.value),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 11,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMasteryBadge(int level) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold.withAlpha(100), width: 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold.withAlpha(50), Colors.transparent],
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'LVL',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$level',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpBar(int current, int next) {
    final progress = (current / next).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$current / $next XP',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildBountyItem(String key, BountyProgress bounty) {
    final info = bountyDisplayInfo[key];
    final emoji = info?.emoji ?? '📋';
    final name = info?.name ?? key;
    final description = info?.description ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bounty.claimed
            ? AppColors.surfaceLight.withAlpha(50)
            : bounty.complete
            ? AppColors.gold.withAlpha(10)
            : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: bounty.canClaim
            ? Border.all(color: AppColors.gold.withAlpha(100))
            : bounty.claimed
            ? null
            : Border.all(color: AppColors.surfaceLight.withAlpha(50)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: bounty.claimed
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        decoration: bounty.claimed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    Row(
                      children: [
                        _buildRewardBadge(
                          'A',
                          '${bounty.reward}',
                          AppColors.gold,
                        ),
                        const SizedBox(width: 4),
                        _buildRewardBadge('XP', '${bounty.xp}', AppColors.info),
                      ],
                    ),
                  ],
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                if (!bounty.complete) ...[
                  const SizedBox(height: 8),
                  _buildMiniProgress(
                    bounty.progress,
                    bounty.target,
                    bounty.progressPercent,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildActionItem(bounty),
        ],
      ),
    );
  }

  Widget _buildRewardBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$value $label',
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMiniProgress(int current, int target, double percent) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.textMuted,
              ),
              minHeight: 3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$current/$target',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildActionItem(BountyProgress bounty) {
    if (bounty.claimed) {
      return const Icon(
        Icons.check_circle,
        color: AppColors.textMuted,
        size: 24,
      );
    }

    if (bounty.canClaim) {
      final isClaiming = _claimingId == bounty.id;
      return SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: isClaiming
              ? null
              : () async {
                  setState(() => _claimingId = bounty.id);
                  try {
                    await ref.read(bountyLogicProvider).claim(bounty);
                  } finally {
                    if (mounted) setState(() => _claimingId = null);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: isClaiming
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'CLAIM',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
        ),
      );
    }

    return const Icon(
      Icons.lock_outline,
      color: AppColors.surfaceLight,
      size: 20,
    );
  }
}
