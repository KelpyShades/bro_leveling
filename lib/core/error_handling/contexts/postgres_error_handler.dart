import 'package:supabase_flutter/supabase_flutter.dart';

class PostgresErrorHandler {
  static void register(Map<Type, String Function(dynamic)> handlers) {
    handlers[PostgrestException] = _handlePostgresError;
  }

  static String _handlePostgresError(dynamic error) {
    if (error is! PostgrestException) return 'Database error';

    final code = error.code;
    final message = error.message.toLowerCase();

    // Common Postgres error codes
    switch (code) {
      case '23505': // unique_violation
        return 'This record already exists';
      case '23503': // foreign_key_violation
        return 'Referenced record not found';
      case '23502': // not_null_violation
        return 'Required field is missing';
      case '42501': // insufficient_privilege
        return 'You do not have permission for this action';
      case 'PGRST301': // JWT expired
        return 'Session expired. Please log in again';
    }

    // Check message patterns
    if (message.contains('already claimed')) {
      return 'Already claimed today';
    }
    if (message.contains('not enough aura')) {
      return 'Not enough Aura for this action';
    }
    if (message.contains('broken')) {
      return 'Action not available while Broken';
    }

    return error.message;
  }
}
