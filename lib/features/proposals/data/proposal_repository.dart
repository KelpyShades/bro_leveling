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
    return _client
        .from('proposals')
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
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('proposals').insert({
      'proposer_id': user.id,
      'target_user_id': targetUserId,
      'amount': amount,
      'type': type,
      'reason': reason,
      'closes_at': DateTime.now()
          .add(const Duration(hours: 12))
          .toIso8601String(),
    });
  }

  Future<void> vote(String proposalId, String value) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('votes').insert({
      'proposal_id': proposalId,
      'voter_id': user.id,
      'value': value,
    });

    // Check if we should resolve - ideally trigger or cron in real app.
    // Spec says "Postgres function resolve_proposal".
    // We can try to trigger it manually or let the trigger handle it if one existed (schema had manual func).
    // The resolve_proposal function checks counts. We can call it after checking if enough votes exist?
    // Or just call it every time a vote is cast (maybe redundant but ensures completion).

    await _client.rpc(
      'resolve_proposal',
      params: {'p_proposal_id': proposalId},
    );
  }
}
