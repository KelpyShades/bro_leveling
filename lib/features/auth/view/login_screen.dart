import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';
import 'package:bro_leveling/features/auth/logic/auth_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUpMode = false;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      showAuraSnackbar(
        context,
        'Please fill all fields',
        type: SnackType.error,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authLogicProvider)
          .signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (mounted) {
        context.go('/home');
      }
    } on AuthException catch (e) {
      if (mounted) {
        showAuraSnackbar(context, e.message, type: SnackType.error);
      }
    } catch (e) {
      if (mounted) {
        showAuraSnackbar(
          context,
          'Unexpected error occurred',
          type: SnackType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signUp() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      showAuraSnackbar(
        context,
        'Please fill all fields',
        type: SnackType.error,
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showAuraSnackbar(
        context,
        'Passwords do not match',
        type: SnackType.error,
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      showAuraSnackbar(
        context,
        'Password must be at least 6 characters',
        type: SnackType.error,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authLogicProvider)
          .signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (mounted) {
        showAuraSnackbar(context, 'Account created!', type: SnackType.success);
        // Switch back to login mode
        setState(() {
          _isSignUpMode = false;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        showAuraSnackbar(context, e.message, type: SnackType.error);
      }
    } catch (e) {
      if (mounted) {
        showAuraSnackbar(
          context,
          'Unexpected error occurred',
          type: SnackType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isSignUpMode = !_isSignUpMode;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  _isSignUpMode ? 'JOIN THE SQUAD' : 'LEVEL UP',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isSignUpMode
                      ? 'Start farming that aura'
                      : 'Welcome back, bro',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),

                // Email field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),

                // Confirm password (only in signup mode)
                if (_isSignUpMode) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Main action button
                if (_isLoading)
                  const CircularProgressIndicator(color: AppColors.gold)
                else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSignUpMode ? _signUp : _signIn,
                      child: Text(_isSignUpMode ? 'CREATE ACCOUNT' : 'LOG IN'),
                    ),
                  ),

                const SizedBox(height: 16),

                // Toggle mode button
                TextButton(
                  onPressed: _isLoading ? null : _toggleMode,
                  child: Text(
                    _isSignUpMode
                        ? 'Already have an account? Log in'
                        : "Don't have an account? Sign up",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
