import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    @Default(100) int aura,
    @Default(0) int streak,
    @Default('INVINCIBLE') String title,
    @JsonKey(name: 'momentum_multiplier')
    @Default(1.0)
    double momentumMultiplier,
    @JsonKey(name: 'is_broken') @Default(false) bool isBroken,
    @JsonKey(name: 'is_him') @Default(false) bool isHim,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_daily_claim') DateTime? lastDailyClaim,
    @JsonKey(name: 'last_weekly_recovery') DateTime? lastWeeklyRecovery,
    @JsonKey(name: 'last_weekly_bonus') DateTime? lastWeeklyBonus,
    @JsonKey(name: 'last_shield_used') DateTime? lastShieldUsed,
    @JsonKey(name: 'last_penalty_at') DateTime? lastPenaltyAt,
    @JsonKey(name: 'last_decay_at') DateTime? lastDecayAt,
    @JsonKey(name: 'indestructible_until') DateTime? indestructibleUntil,
    @JsonKey(name: 'last_indestructible_granted_at')
    DateTime? lastIndestructibleGrantedAt,
    // Prestige fields
    @JsonKey(name: 'ascension_count') @Default(0) int ascensionCount,
    @JsonKey(name: 'ascension_perks') @Default([]) List<String> ascensionPerks,
    @JsonKey(name: 'last_ascension_at') DateTime? lastAscensionAt,
    @JsonKey(name: 'total_aura_earned') @Default(0) int totalAuraEarned,
    // Bounty Mastery
    @JsonKey(name: 'bounty_xp') @Default(0) int bountyXp,
    @JsonKey(name: 'bounty_level') @Default(1) int bountyLevel,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
