// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  aura: (json['aura'] as num?)?.toInt() ?? 100,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  isBroken: json['is_broken'] as bool? ?? false,
  isHim: json['is_him'] as bool? ?? false,
  lastDailyClaim: json['last_daily_claim'] == null
      ? null
      : DateTime.parse(json['last_daily_claim'] as String),
  lastShieldUsed: json['last_shield_used'] == null
      ? null
      : DateTime.parse(json['last_shield_used'] as String),
  lastPenaltyAt: json['last_penalty_at'] == null
      ? null
      : DateTime.parse(json['last_penalty_at'] as String),
  lastDecayAt: json['last_decay_at'] == null
      ? null
      : DateTime.parse(json['last_decay_at'] as String),
  indestructibleUntil: json['indestructible_until'] == null
      ? null
      : DateTime.parse(json['indestructible_until'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'aura': instance.aura,
      'streak': instance.streak,
      'is_broken': instance.isBroken,
      'is_him': instance.isHim,
      'last_daily_claim': instance.lastDailyClaim?.toIso8601String(),
      'last_shield_used': instance.lastShieldUsed?.toIso8601String(),
      'last_penalty_at': instance.lastPenaltyAt?.toIso8601String(),
      'last_decay_at': instance.lastDecayAt?.toIso8601String(),
      'indestructible_until': instance.indestructibleUntil?.toIso8601String(),
    };
