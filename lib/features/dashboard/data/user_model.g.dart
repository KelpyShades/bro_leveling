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
  title: json['title'] as String? ?? 'INVINCIBLE',
  momentumMultiplier: (json['momentum_multiplier'] as num?)?.toDouble() ?? 1.0,
  isBroken: json['is_broken'] as bool? ?? false,
  isHim: json['is_him'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  lastDailyClaim: json['last_daily_claim'] == null
      ? null
      : DateTime.parse(json['last_daily_claim'] as String),
  lastWeeklyRecovery: json['last_weekly_recovery'] == null
      ? null
      : DateTime.parse(json['last_weekly_recovery'] as String),
  lastWeeklyBonus: json['last_weekly_bonus'] == null
      ? null
      : DateTime.parse(json['last_weekly_bonus'] as String),
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
  lastIndestructibleGrantedAt: json['last_indestructible_granted_at'] == null
      ? null
      : DateTime.parse(json['last_indestructible_granted_at'] as String),
  ascensionCount: (json['ascension_count'] as num?)?.toInt() ?? 0,
  ascensionPerks:
      (json['ascension_perks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastAscensionAt: json['last_ascension_at'] == null
      ? null
      : DateTime.parse(json['last_ascension_at'] as String),
  totalAuraEarned: (json['total_aura_earned'] as num?)?.toInt() ?? 0,
  bountyXp: (json['bounty_xp'] as num?)?.toInt() ?? 0,
  bountyLevel: (json['bounty_level'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'aura': instance.aura,
      'streak': instance.streak,
      'title': instance.title,
      'momentum_multiplier': instance.momentumMultiplier,
      'is_broken': instance.isBroken,
      'is_him': instance.isHim,
      'created_at': instance.createdAt?.toIso8601String(),
      'last_daily_claim': instance.lastDailyClaim?.toIso8601String(),
      'last_weekly_recovery': instance.lastWeeklyRecovery?.toIso8601String(),
      'last_weekly_bonus': instance.lastWeeklyBonus?.toIso8601String(),
      'last_shield_used': instance.lastShieldUsed?.toIso8601String(),
      'last_penalty_at': instance.lastPenaltyAt?.toIso8601String(),
      'last_decay_at': instance.lastDecayAt?.toIso8601String(),
      'indestructible_until': instance.indestructibleUntil?.toIso8601String(),
      'last_indestructible_granted_at': instance.lastIndestructibleGrantedAt
          ?.toIso8601String(),
      'ascension_count': instance.ascensionCount,
      'ascension_perks': instance.ascensionPerks,
      'last_ascension_at': instance.lastAscensionAt?.toIso8601String(),
      'total_aura_earned': instance.totalAuraEarned,
      'bounty_xp': instance.bountyXp,
      'bounty_level': instance.bountyLevel,
    };
