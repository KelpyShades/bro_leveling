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
    @Default(false) bool shielded,
  }) = _ProposalModel;

  factory ProposalModel.fromJson(Map<String, dynamic> json) =>
      _$ProposalModelFromJson(json);
}
