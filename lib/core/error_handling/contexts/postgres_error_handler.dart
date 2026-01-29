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
        if (message.contains('votes_proposal_id_voter_id_key')) {
          return 'You have already voted on this proposal';
        }
        return 'This record already exists';
      case '23503': // foreign_key_violation
        return 'Referenced record not found';
      case '23502': // not_null_violation
        return 'Required field is missing';
      case '23514': // check_violation
        if (message.contains('users_aura_check')) {
          return 'Aura cannot be negative (You are at 0)';
        }
        if (message.contains('proposals_amount_check')) {
          return 'Proposal amount must be between -100 and 100';
        }
        if (message.contains('votes_value_check')) {
          return 'Invalid vote option selection';
        }
        if (message.contains('aura_transfers_amount_check')) {
          return 'Transfer amount must be between 1 and 10';
        }
        return 'Operation violates game rules';
      case '42501': // insufficient_privilege
        return 'You do not have permission for this action';
      case 'PGRST301': // JWT expired
        return 'Session expired. Please log in again';
    }

    // Check message patterns for custom exceptions (RAISE EXCEPTION)

    // --- Indestructible / Shield ---
    if (message.contains('indestructible virgin mode')) {
      return 'Target is Indestructible! (Virgin Shield Active)';
    }
    if (message.contains('shield window has expired')) {
      return 'Shield expired (1 hour time limit)';
    }
    if (message.contains('proposal must be approved to use shield')) {
      return 'Shield can only reverse Approved penalties';
    }

    // --- Broken Status ---
    // Catches "Cannot vote while Broken", "Cannot claim...", "Cannot share..."
    if (message.contains('broken')) {
      return 'Action not available while Broken';
    }

    // --- Daily/Weekly Limits ---
    if (message.contains('already claimed')) {
      return 'Already claimed today';
    }
    if (message.contains('daily proposal limit reached')) {
      return 'Daily Limit Reached (2 Proposals/Day)';
    }
    if (message.contains('daily sharing limit reached')) {
      return 'Daily Sharing Limit Reached (10 Aura/Day)';
    }
    if (message.contains('weekly sharing limit reached')) {
      return 'Weekly Sharing Limit Reached (50 Aura/Week)';
    }
    if (message.contains('weekly recovery already claimed')) {
      return 'Weekly Recovery already used this week';
    }

    // --- Proposal / Voting State ---
    if (message.contains('proposal is no longer open')) {
      return 'Voting for this proposal has closed';
    }
    if (message.contains('voting period has ended')) {
      return 'Voting period has ended';
    }
    if (message.contains('proposal already resolved')) {
      return 'This proposal is already resolved';
    }
    if (message.contains('voting period not ended yet')) {
      return 'Voting is still in progress';
    }

    // --- Validation / Amounts ---
    if (message.contains('not enough aura')) {
      return 'Not enough Aura for this action';
    }
    if (message.contains('must be 1-100')) {
      return 'Amount must be between 1 and 100';
    }
    if (message.contains('can only share 1-10')) {
      return 'Share amount must be 1-10 Aura';
    }
    if (message.contains('need at least 50 aura')) {
      return 'You need 50+ Aura to share with others';
    }

    if (error.details != null) {
      return '${error.message}: ${error.details}';
    }

    return error.message;
  }
}
