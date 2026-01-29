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
    @JsonKey(name: 'is_broken') @Default(false) bool isBroken,
    @JsonKey(name: 'is_him') @Default(false) bool isHim,
    @JsonKey(name: 'last_daily_claim') DateTime? lastDailyClaim,
    @JsonKey(name: 'last_shield_used') DateTime? lastShieldUsed,
    @JsonKey(name: 'last_penalty_at') DateTime? lastPenaltyAt,
    @JsonKey(name: 'last_decay_at') DateTime? lastDecayAt,
    @JsonKey(name: 'indestructible_until') DateTime? indestructibleUntil,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
