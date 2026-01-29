import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';
import 'package:bro_leveling/features/proposals/logic/proposal_logic.dart';
import 'package:bro_leveling/features/proposals/logic/proposal_provider.dart';
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProposalsScreen extends ConsumerStatefulWidget {
  const ProposalsScreen({super.key});

  @override
  ConsumerState<ProposalsScreen> createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends ConsumerState<ProposalsScreen> {
  final Map<String, bool> _votingLoader = {};

  @override
  Widget build(BuildContext context) {
    final proposalsAsync = ref.watch(proposalsProvider);
    final userVotesAsync = ref.watch(userVotesProvider);

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
                    if (prop.targetUsername != null)
                      Text(
                        'FOR: ${prop.targetUsername!.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    const SizedBox(height: 4),

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

                    // Voting buttons or Results
                    if (prop.status == 'pending') ...[
                      userVotesAsync.when(
                        data: (votes) {
                          final userVote = votes[prop.id];

                          if (userVote != null) {
                            return Column(
                              children: [
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.gold.withAlpha(50),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'VOTING CLOSED FOR YOU',
                                            style: TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          Text(
                                            'YOU VOTED: ${userVote.toUpperCase()}',
                                            style: TextStyle(
                                              color: userVote == 'support'
                                                  ? AppColors.success
                                                  : AppColors.error,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          _buildVoteBar(
                                            'SUPPORT',
                                            prop.supportCount,
                                            AppColors.success,
                                          ),
                                          const SizedBox(width: 12),
                                          _buildVoteBar(
                                            'REJECT',
                                            prop.rejectCount,
                                            AppColors.error,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _votingLoader[prop.id] == true
                                          ? null
                                          : () => _vote(prop.id, 'support'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.success,
                                      ),
                                      child: _votingLoader[prop.id] == true
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text('SUPPORT'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _votingLoader[prop.id] == true
                                          ? null
                                          : () => _vote(prop.id, 'reject'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.error,
                                      ),
                                      child: _votingLoader[prop.id] == true
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text('REJECT'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        loading: () => const SizedBox(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
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
                                onPressed: () => _useShield(prop.id),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          onPressed: () => context.push('/create-proposal'),
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.background,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildVoteBar(String label, int count, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: count > 0 ? 1.0 : 0.0, // Simplified visualization
              backgroundColor: color.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _vote(String id, String value) async {
    setState(() => _votingLoader[id] = true);
    try {
      await ref.read(proposalLogicProvider).vote(id, value);
      if (mounted) {
        showAuraSnackbar(context, 'Vote cast: $value', type: SnackType.success);
      }
    } catch (e) {
      if (mounted) {
        showAuraSnackbar(context, 'Error: $e', type: SnackType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _votingLoader[id] = false);
      }
    }
  }

  Future<void> _useShield(String proposalId) async {
    try {
      await ref.read(proposalLogicProvider).useShield(proposalId);

      if (mounted) {
        showAuraSnackbar(
          context,
          'Shield Activated! Penalty reversed.',
          type: SnackType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showAuraSnackbar(
          context,
          'Failed to use shield: $e',
          type: SnackType.error,
        );
      }
    }
  }
}
