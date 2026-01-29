import 'package:bro_leveling/features/proposals/data/proposal_repository.dart';
import 'package:bro_leveling/features/proposals/data/proposal_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final proposalsProvider = StreamProvider.autoDispose<List<ProposalModel>>((
  ref,
) {
  return ref.watch(proposalRepositoryProvider).getProposalsStream();
});
