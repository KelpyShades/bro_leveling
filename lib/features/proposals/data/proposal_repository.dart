import 'package:bro_leveling/features/proposals/data/proposal_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final proposalRepositoryProvider = Provider<ProposalRepository>((ref) {
  return ProposalRepository(Supabase.instance.client);
});

class ProposalRepository {
  final SupabaseClient _client;

  ProposalRepository(this._client);

  Stream<List<ProposalModel>> getProposalsStream() {
    // Use view that includes both target and proposer usernames
    return _client
        .from('proposals_with_usernames')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (data) => data.map((json) => ProposalModel.fromJson(json)).toList(),
        );
  }

  Future<void> createProposal({
    required String targetUserId,
    required int amount,
    required String type,
    required String reason,
    bool isAnonymous = false,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Use RPC for proper validation and 24h voting window
    await _client.rpc(
      'create_proposal',
      params: {
        'p_target_user_id': targetUserId,
        'p_amount': amount.abs(), // RPC expects positive amount
        'p_type': type,
        'p_reason': reason,
        'p_is_anonymous': isAnonymous,
      },
    );
  }

  Future<void> vote(String proposalId, String value) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // We use a RPC or a clever update to avoid fetching the whole array.
    // However, since we want to be simple and safe, let's use a raw update with array_append if possible,
    // or just a standard update since we know the current state from the stream usually.
    // But to be robust, let's use a postgres set logic.

    // Check if already voted (client side check is done, but server side is safer)
    // Actually, let's just do the update. If they are in the array, Postgres won't append duplicates if we use a set-like logic or just rely on UI.
    // For simplicity:
    await _client.rpc(
      'vote_on_proposal',
      params: {
        'p_proposal_id': proposalId,
        'p_voter_id': user.id,
        'p_vote_value': value,
      },
    );

    try {
      await _client.rpc(
        'resolve_proposal',
        params: {'p_proposal_id': proposalId},
      );
    } catch (e) {
      if (e.toString().contains('Voting period not ended yet')) {
        return;
      }
      rethrow;
    }
  }

  Stream<Map<String, String>> getUserVotesStream() {
    final user = _client.auth.currentUser;
    if (user == null) return Stream.value({});

    // We derive user votes from the proposals stream
    return getProposalsStream().map((proposals) {
      final map = <String, String>{};
      for (final prop in proposals) {
        if (prop.supportVoterIds.contains(user.id)) {
          map[prop.id] = 'support';
        } else if (prop.rejectVoterIds.contains(user.id)) {
          map[prop.id] = 'reject';
        }
      }
      return map;
    });
  }
}
