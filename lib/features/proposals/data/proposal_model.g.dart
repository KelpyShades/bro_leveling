// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProposalModel _$ProposalModelFromJson(Map<String, dynamic> json) =>
    _ProposalModel(
      id: json['id'] as String,
      proposerId: json['proposer_id'] as String,
      targetUserId: json['target_user_id'] as String,
      amount: (json['amount'] as num).toInt(),
      type: json['type'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      closesAt: DateTime.parse(json['closes_at'] as String),
      shielded: json['shielded'] as bool? ?? false,
    );

Map<String, dynamic> _$ProposalModelToJson(_ProposalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'proposer_id': instance.proposerId,
      'target_user_id': instance.targetUserId,
      'amount': instance.amount,
      'type': instance.type,
      'reason': instance.reason,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'closes_at': instance.closesAt.toIso8601String(),
      'shielded': instance.shielded,
    };
