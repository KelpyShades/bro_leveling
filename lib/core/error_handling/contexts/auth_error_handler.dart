import 'package:supabase_flutter/supabase_flutter.dart';

class AuthErrorHandler {
  static void register(Map<Type, String Function(dynamic)> handlers) {
    handlers[AuthException] = _handleAuthException;
  }

  static String _handleAuthException(dynamic error) {
    if (error is! AuthException) return 'Authentication error';

    final message = error.message.toLowerCase();

    if (message.contains('invalid login credentials')) {
      return 'Invalid email or password';
    }
    if (message.contains('email not confirmed')) {
      return 'Please verify your email first';
    }
    if (message.contains('user already registered')) {
      return 'This email is already registered';
    }
    if (message.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment';
    }
    if (message.contains('session expired')) {
      return 'Session expired. Please log in again';
    }

    return error.message;
  }
}
