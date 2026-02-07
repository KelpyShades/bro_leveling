import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';
import 'package:bro_leveling/features/dashboard/data/user_model.dart';
import 'package:bro_leveling/features/proposals/logic/proposal_logic.dart';
import 'package:bro_leveling/features/leaderboard/logic/leaderboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateProposalScreen extends ConsumerStatefulWidget {
  const CreateProposalScreen({super.key});

  @override
  ConsumerState<CreateProposalScreen> createState() =>
      _CreateProposalScreenState();
}

class _CreateProposalScreenState extends ConsumerState<CreateProposalScreen> {
  final _reasonController = TextEditingController();
  final _amountController = TextEditingController();
  UserModel? _selectedTarget;
  String _type = 'boost';
  bool _isAnonymous = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('NEW PROPOSAL'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target user dropdown
            const Text(
              'TARGET',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final usersAsync = ref.watch(leaderboardProvider);
                return usersAsync.when(
                  skipLoadingOnReload: true,
                  skipError: true,
                  data: (users) {
                    return DropdownButtonFormField<UserModel>(
                      decoration: const InputDecoration(
                        hintText: 'Select target user',
                      ),
                      dropdownColor: AppColors.surface,
                      items: users.map((user) {
                        return DropdownMenuItem(
                          value: user,
                          child: Text(
                            user.username,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedTarget = val),
                      initialValue: _selectedTarget,
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  ),
                  error: (err, stack) => const Text(
                    'Error loading users',
                    style: TextStyle(color: AppColors.error),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Type selection
            const Text(
              'TYPE',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _type = 'boost'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _type == 'boost'
                            ? AppColors.success.withAlpha(30)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _type == 'boost'
                              ? AppColors.success
                              : AppColors.surfaceLight,
                          width: _type == 'boost' ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: _type == 'boost'
                                ? AppColors.success
                                : AppColors.textMuted,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'BOOST',
                            style: TextStyle(
                              color: _type == 'boost'
                                  ? AppColors.success
                                  : AppColors.textMuted,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _type = 'penalty'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _type == 'penalty'
                            ? AppColors.error.withAlpha(30)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _type == 'penalty'
                              ? AppColors.error
                              : AppColors.surfaceLight,
                          width: _type == 'penalty' ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            color: _type == 'penalty'
                                ? AppColors.error
                                : AppColors.textMuted,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PENALTY',
                            style: TextStyle(
                              color: _type == 'penalty'
                                  ? AppColors.error
                                  : AppColors.textMuted,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Amount
            const Text(
              'AMOUNT (1-100)',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(hintText: '0'),
            ),
            const SizedBox(height: 24),

            // Reason
            const Text(
              'REASON',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Why does this person deserve this?',
              ),
            ),
            const SizedBox(height: 24),

            // Anonymous option
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: _isAnonymous
                    ? Border.all(color: AppColors.gold.withAlpha(100))
                    : null,
              ),
              child: CheckboxListTile(
                value: _isAnonymous,
                onChanged: (val) => setState(() => _isAnonymous = val ?? false),
                title: const Text(
                  'Submit Anonymously',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  _type == 'penalty'
                      ? 'Identity hidden during voting (+5 Aura cost)'
                      : 'Identity hidden during voting (free for boosts)',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                activeColor: AppColors.gold,
                secondary: Icon(
                  Icons.visibility_off,
                  color: _isAnonymous ? AppColors.gold : AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cost preview
            // Cost display - only show for penalty proposals
            if (_type == 'penalty') ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PENALTY COST',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      '-${10 + (_isAnonymous ? 5 : 0)} Aura',
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Free badge for boosts
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success.withAlpha(50)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.celebration, color: AppColors.success, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'BOOSTS ARE FREE!',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.background,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'SUBMIT PROPOSAL',
                        style: TextStyle(letterSpacing: 2),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedTarget == null ||
        _amountController.text.isEmpty ||
        _reasonController.text.isEmpty) {
      showAuraSnackbar(
        context,
        'Please fill all fields',
        type: SnackType.error,
      );
      return;
    }

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0 || amount > 100) {
      showAuraSnackbar(
        context,
        'Amount must be between 1 and 100',
        type: SnackType.error,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(proposalLogicProvider)
          .createProposal(
            targetUserId: _selectedTarget!.id,
            amount: _type == 'penalty' ? -amount : amount,
            type: _type,
            reason: _reasonController.text.trim(),
            isAnonymous: _isAnonymous,
          );
      if (mounted) {
        context.pop();
        showAuraSnackbar(context, 'Proposal created!', type: SnackType.success);
      }
    } catch (e) {
      if (mounted) {
        showAuraSnackbar(context, 'Error: $e', type: SnackType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
