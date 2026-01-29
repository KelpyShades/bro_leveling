import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/features/auth/logic/auth_logic.dart';
import 'package:bro_leveling/features/dashboard/logic/user_logic.dart';
import 'package:bro_leveling/features/leaderboard/logic/leaderboard_provider.dart';
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:bro_leveling/features/dashboard/data/user_model.dart';
import 'package:bro_leveling/core/utils/aura_utils.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _shareAmountController = TextEditingController();
  UserModel? _selectedRecipient;

  @override
  void dispose() {
    _shareAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('PROFILE'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: userAsync.when(
        skipLoadingOnReload: true,
        skipError: true,
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                'Not logged in',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final title = getTitle(user.aura, isHim: user.isHim);
          final auraColor = getAuraColor(user.aura, isBroken: user.isBroken);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: auraColor.withAlpha(50)),
                  ),
                  child: Column(
                    children: [
                      // Avatar placeholder
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: auraColor.withAlpha(30),
                          border: Border.all(color: auraColor, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            user.username[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: auraColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.username,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: auraColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            color: auraColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat('AURA', '${user.aura}', auraColor),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.surfaceLight,
                          ),
                          _buildStat(
                            'STREAK',
                            '${user.streak}',
                            AppColors.warning,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.surfaceLight,
                          ),
                          _buildStat(
                            'STATUS',
                            user.isBroken ? 'AURALESS' : 'ACTIVE',
                            user.isBroken ? AppColors.error : AppColors.success,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Aura sharing section
                if (!user.isBroken && user.aura >= 50) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: AppColors.error,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'SHARE AURA',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Gift aura to help a friend (max 10/day, 50/week)',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Recipient dropdown
                        Consumer(
                          builder: (context, ref, child) {
                            final usersAsync = ref.watch(leaderboardProvider);
                            return usersAsync.when(
                              skipLoadingOnReload: true,
                              skipError: true,
                              data: (usersList) {
                                final recipients = usersList
                                    .where(
                                      (u) => u.id != user.id && !u.isBroken,
                                    )
                                    .toList();
                                return DropdownButtonFormField<UserModel>(
                                  decoration: const InputDecoration(
                                    hintText: 'Select recipient',
                                  ),
                                  dropdownColor: AppColors.surface,
                                  initialValue: _selectedRecipient,
                                  items: recipients.map((u) {
                                    return DropdownMenuItem(
                                      value: u,
                                      child: Text(
                                        u.username,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedRecipient = val),
                                );
                              },
                              loading: () => const CircularProgressIndicator(
                                color: AppColors.gold,
                              ),
                              error: (err, stack) => const Text(
                                'Error loading users',
                                style: TextStyle(color: AppColors.error),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // Amount input
                        TextField(
                          controller: _shareAmountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            hintText: 'Amount (1-10)',
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _shareAura,
                            child: const Text('SEND AURA'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Weekly recovery for broken users
                if (user.isBroken) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.error.withAlpha(20),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.error.withAlpha(50)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.healing,
                          color: AppColors.error,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'WEEKLY RECOVERY',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Claim +25 Aura to start recovering',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _claimRecovery,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: const Text('CLAIM RECOVERY'),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(authLogicProvider).signOut();
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.textMuted),
                      foregroundColor: AppColors.textMuted,
                    ),
                    icon: const Icon(
                      Icons.logout,
                      color: AppColors.gold,
                      size: 20,
                    ),
                    label: const Text(
                      'LOGOUT',
                      style: TextStyle(letterSpacing: 1, color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 100), // Bottom padding for consistency
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
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

  Future<void> _shareAura() async {
    if (_selectedRecipient == null) {
      showAuraSnackbar(context, 'Select a recipient', type: SnackType.error);
      return;
    }

    final amount = int.tryParse(_shareAmountController.text);
    if (amount == null || amount < 1 || amount > 10) {
      showAuraSnackbar(context, 'Amount must be 1-10', type: SnackType.error);
      return;
    }

    try {
      await ref
          .read(userLogicProvider)
          .shareAura(toUserId: _selectedRecipient!.id, amount: amount);
      if (mounted) {
        showAuraSnackbar(
          context,
          'Shared $amount aura with ${_selectedRecipient!.username}',
          type: SnackType.success,
        );
        _shareAmountController.clear();
        setState(() => _selectedRecipient = null);
      }
    } catch (e) {
      if (mounted) {
        showAuraSnackbar(context, 'Error: $e', type: SnackType.error);
      }
    }
  }

  Future<void> _claimRecovery() async {
    try {
      await ref.read(userLogicProvider).claimWeeklyRecovery();
      if (mounted) {
        showAuraSnackbar(
          context,
          'Claimed +25 Aura recovery!',
          type: SnackType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showAuraSnackbar(context, 'Error: $e', type: SnackType.error);
      }
    }
  }
}
