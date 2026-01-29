import 'package:bro_leveling/features/dashboard/data/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(Supabase.instance.client);
});

class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  Stream<UserModel?> getUserStream() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return Stream.value(null);
    }

    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((event) {
          if (event.isEmpty) {
            return null;
          }
          return UserModel.fromJson(event.first);
        });
  }

  /// Check if current user exists in users table.
  Future<bool> userExists() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    final data = await _client
        .from('users')
        .select('id')
        .eq('id', userId)
        .maybeSingle();
    return data != null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final data = await _client
        .from('users')
        .select()
        .order('aura', ascending: false);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  /// Create a new user with the given username.
  Future<void> createUser(String username) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }

    await _client.from('users').insert({
      'id': user.id,
      'username': username,
      'aura': 100,
      'streak': 0,
      'is_broken': false,
    });
  }

  /// Claim daily aura with streak tracking.
  /// Returns a map with 'aura_gained', 'new_streak', and 'milestone_bonus'.
  Future<Map<String, dynamic>> claimDaily() async {
    final result = await _client.rpc('claim_daily_aura');
    return Map<String, dynamic>.from(result);
  }

  /// Claim weekly recovery (only available if aura = 0).
  Future<void> claimWeeklyRecovery() async {
    await _client.rpc('claim_weekly_recovery');
  }

  /// Use shield on a penalty proposal.
  Future<void> useShield(String proposalId) async {
    await _client.rpc('use_shield', params: {'p_proposal_id': proposalId});
  }

  /// Get global aura history (last 24h).
  Future<List<Map<String, dynamic>>> getGlobalAuraHistory() async {
    final response = await _client
        .from('aura_events')
        .select('*, users:user_id(username)')
        .gt(
          'created_at',
          DateTime.now().subtract(const Duration(hours: 24)).toIso8601String(),
        )
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Share aura with another user.
  Future<void> shareAura({
    required String toUserId,
    required int amount,
  }) async {
    await _client.rpc(
      'share_aura',
      params: {'p_to_user_id': toUserId, 'p_amount': amount},
    );
  }

  Future<List<Map<String, dynamic>>> getAuraHistory() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('aura_events')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);

    return List<Map<String, dynamic>>.from(data);
  }
}
