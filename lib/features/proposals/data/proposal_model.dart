import 'package:freezed_annotation/freezed_annotation.dart';

part 'proposal_model.freezed.dart';
part 'proposal_model.g.dart';

@freezed
sealed class ProposalModel with _$ProposalModel {
  const factory ProposalModel({
    required String id,
    @JsonKey(name: 'proposer_id') required String proposerId,
    @JsonKey(name: 'target_user_id') required String targetUserId,
    required int amount,
    required String type, // 'boost' or 'penalty'
    required String reason,
    required String status, // 'pending', 'approved', 'rejected'
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'closes_at') required DateTime closesAt,
    @JsonKey(name: 'target_username') String? targetUsername,
    @JsonKey(name: 'proposer_username') String? proposerUsername,
    @JsonKey(name: 'support_voter_ids')
    @Default([])
    List<String> supportVoterIds,
    @JsonKey(name: 'reject_voter_ids') @Default([]) List<String> rejectVoterIds,
    @Default(false) bool shielded,
    @JsonKey(name: 'is_anonymous') @Default(false) bool isAnonymous,
    @JsonKey(name: 'revealed_at') DateTime? revealedAt,
  }) = _ProposalModel;

  const ProposalModel._();

  int get supportCount => supportVoterIds.length;
  int get rejectCount => rejectVoterIds.length;

  /// Whether the proposer should be hidden (anonymous and not yet revealed)
  bool get isProposerHidden =>
      isAnonymous && revealedAt == null && status == 'active';

  factory ProposalModel.fromJson(Map<String, dynamic> json) =>
      _$ProposalModelFromJson(json);
}
