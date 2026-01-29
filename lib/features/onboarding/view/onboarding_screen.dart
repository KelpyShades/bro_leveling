import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';
import 'package:bro_leveling/features/dashboard/logic/user_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      showAuraSnackbar(context, 'Enter a username', type: SnackType.error);
      return;
    }

    if (username.length < 3) {
      showAuraSnackbar(
        context,
        'Username must be at least 3 characters',
        type: SnackType.error,
      );
      return;
    }

    if (username.length > 20) {
      showAuraSnackbar(
        context,
        'Username must be 20 characters or less',
        type: SnackType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(userLogicProvider).createUser(username);
      if (mounted) {
        context.go('/home');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Welcome text
                  const Text(
                    'WELCOME TO',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'BRO LEVELING',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Aura display
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '100',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'STARTING AURA',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'INVISIBLE',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Username input
                  const Text(
                    'CHOOSE YOUR NAME',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter username',
                      hintStyle: TextStyle(
                        color: AppColors.textMuted.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Create button
                  if (_isLoading)
                    const CircularProgressIndicator(color: AppColors.gold)
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _createProfile,
                        child: const Text(
                          'START LEVELING',
                          style: TextStyle(fontSize: 16, letterSpacing: 2),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),
                  const Text(
                    'Your aura journey begins here',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
