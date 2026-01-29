import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';
import 'package:bro_leveling/features/proposals/data/proposal_repository.dart';
import 'package:bro_leveling/features/proposals/logic/proposal_provider.dart';
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:bro_leveling/features/dashboard/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProposalsScreen extends ConsumerWidget {
  const ProposalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposalsAsync = ref.watch(proposalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('PROPOSALS'),
      ),
      body: proposalsAsync.when(
        skipLoadingOnReload: true,
        skipError: true,
        data: (proposals) {
          if (proposals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.gavel, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'No active proposals',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final prop = proposals[index];
              final isBoost = prop.type == 'boost';
              final typeColor = isBoost ? AppColors.success : AppColors.error;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: typeColor.withAlpha(50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            prop.type.toUpperCase(),
                            style: TextStyle(
                              color: typeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('MMM d, HH:mm').format(prop.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Amount
                    Row(
                      children: [
                        Text(
                          isBoost ? '+' : '-',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: typeColor,
                          ),
                        ),
                        Text(
                          '${prop.amount}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          ' AURA',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Reason
                    Text(
                      prop.reason,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),

                    // Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prop.status.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: prop.status == 'pending'
                                ? AppColors.warning
                                : prop.status == 'approved'
                                ? AppColors.success
                                : AppColors.error,
                            letterSpacing: 1,
                          ),
                        ),
                        if (prop.status == 'pending')
                          Text(
                            'Closes ${DateFormat('HH:mm').format(prop.closesAt)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                      ],
                    ),

                    // Voting buttons
                    if (prop.status == 'pending') ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  _vote(context, ref, prop.id, 'support'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                              ),
                              child: const Text('SUPPORT'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  _vote(context, ref, prop.id, 'reject'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                              ),
                              child: const Text('REJECT'),
                            ),
                          ),
                        ],
                      ),
                    ] else if (prop.status == 'approved' &&
                        prop.type == 'penalty' &&
                        !prop.shielded) ...[
                      // Shield Option (Only for target user, within 1h)
                      // We need current user ID to check target.
                      // Since we don't have user provider here easily, we can check Supabase auth directly
                      // or better, wrap this in a Consumer to get userProvider.
                      // For now, let's assume we can use supabase client or userProvider.
                      // Refactoring to get user:
                      Consumer(
                        builder: (context, ref, _) {
                          final user = ref.watch(userProvider).asData?.value;
                          if (user == null || user.id != prop.targetUserId) {
                            return const SizedBox.shrink();
                          }

                          // Check time window (1 hour)
                          // Assuming closesAt is roughly approval time or we use a buffer.
                          // Ideally we'd use 'updated_at' or specific approval timestamp.
                          // For MVP, we use closesAt as the reference.
                          if (DateTime.now()
                                  .difference(prop.closesAt)
                                  .inMinutes >
                              60) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _useShield(context, ref, prop.id),
                                icon: const Icon(Icons.security),
                                label: const Text(
                                  'USE SHIELD (REVERSE PENALTY)',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  foregroundColor: AppColors.surface,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error: $err',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-proposal'),
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _vote(
    BuildContext context,
    WidgetRef ref,
    String id,
    String value,
  ) async {
    try {
      await ref.read(proposalRepositoryProvider).vote(id, value);
      if (context.mounted) {
        showAuraSnackbar(context, 'Vote cast: $value', type: SnackType.success);
      }
    } catch (e) {
      if (context.mounted) {
        showAuraSnackbar(context, 'Error: $e', type: SnackType.error);
      }
    }
  }

  Future<void> _useShield(
    BuildContext context,
    WidgetRef ref,
    String proposalId,
  ) async {
    // Optimistic UI or just loading?
    // Let's show loading dialog or just async await with snackbar
    try {
      await ref.read(userRepositoryProvider).useShield(proposalId);
      // Refresh both proposals and user
      ref.invalidate(proposalsProvider);
      ref.invalidate(userProvider);

      if (context.mounted) {
        showAuraSnackbar(
          context,
          'Shield Activated! Penalty reversed.',
          type: SnackType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showAuraSnackbar(
          context,
          'Failed to use shield: $e',
          type: SnackType.error,
        );
      }
    }
  }
}
