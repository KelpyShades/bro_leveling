import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/features/activity/logic/activity_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuraHistoryScreen extends ConsumerWidget {
  const AuraHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'ACTIVITY LOG',
            style: TextStyle(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [
              Tab(text: 'PERSONAL'),
              Tab(text: 'GLOBAL FEED'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ActivityList(provider: personalActivityProvider, isGlobal: false),
            _ActivityList(provider: globalActivityProvider, isGlobal: true),
          ],
        ),
      ),
    );
  }
}

class _ActivityList extends ConsumerWidget {
  final StreamProvider<List<Map<String, dynamic>>> provider;
  final bool isGlobal;

  const _ActivityList({required this.provider, required this.isGlobal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(provider);

    return activityAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.history_toggle_off,
                  size: 64,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 16),
                Text(
                  isGlobal
                      ? 'No recent global activity'
                      : 'No personal history yet',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final event = activities[index];
            return _ActivityCard(event: event, isGlobal: isGlobal);
          },
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.gold)),
      error: (err, stack) => Center(
        child: Text(
          'Error: $err',
          style: const TextStyle(color: AppColors.error),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final bool isGlobal;

  const _ActivityCard({required this.event, required this.isGlobal});

  @override
  Widget build(BuildContext context) {
    final type = event['source'] as String? ?? 'unknown';
    final amount = (event['amount'] as num?)?.toInt() ?? 0;
    final createdAtStr = event['created_at'] as String?;
    final createdAt = createdAtStr != null
        ? DateTime.parse(createdAtStr)
        : DateTime.now();
    // In global feed, 'users' relation might be present. In personal, it might not be needed.
    // However, Supabase returns nested object for relations.
    final userData = event['users'] as Map<String, dynamic>?;
    final username = userData?['username'] as String? ?? 'Unknown System';

    final isPositive = amount >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;

    IconData icon;
    String titleText;

    switch (type) {
      case 'daily_login':
        icon = Icons.calendar_today;
        titleText = 'DAILY CLAIM';
        break;
      case 'proposal_vote':
        icon = Icons.gavel;
        titleText = 'VOTED';
        break;
      case 'proposal_passed':
        icon = Icons.check_circle;
        titleText = 'PROPOSAL PASSED';
        break;
      case 'proposal_rejected':
        icon = Icons.cancel;
        titleText = 'PROPOSAL REJECTED';
        break;
      case 'shield_usage':
        icon = Icons.security;
        titleText = 'SHIELD DEFENSE';
        break;
      case 'decay':
        icon = Icons.trending_down;
        titleText = 'RANK DECAY';
        break; // New decay icon
      default:
        icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
        titleText = type.replaceAll('_', ' ').toUpperCase();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      _formatTime(createdAt),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    children: [
                      if (isGlobal) ...[
                        TextSpan(
                          text: username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' '),
                      ],
                      // Contextual description based on type could go here
                      // For now, just render the effect
                      TextSpan(
                        text: isPositive ? 'gained' : 'lost',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: '${amount.abs()}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const TextSpan(text: ' Aura'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${dt.day}/${dt.month}';
    }
  }
}
