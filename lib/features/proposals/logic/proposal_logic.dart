import 'package:bro_leveling/features/proposals/data/proposal_repository.dart';
import 'package:bro_leveling/features/dashboard/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProposalLogic {
  final Ref _ref;

  ProposalLogic(this._ref);

  Future<void> vote(String proposalId, String value) async {
    await _ref.read(proposalRepositoryProvider).vote(proposalId, value);
  }

  Future<void> useShield(String proposalId) async {
    await _ref.read(userRepositoryProvider).useShield(proposalId);
  }

  Future<void> createProposal({
    required String targetUserId,
    required int amount,
    required String type,
    required String reason,
  }) async {
    await _ref
        .read(proposalRepositoryProvider)
        .createProposal(
          targetUserId: targetUserId,
          amount: amount,
          type: type,
          reason: reason,
        );
  }
}

final proposalLogicProvider = Provider<ProposalLogic>(
  (ref) => ProposalLogic(ref),
);
