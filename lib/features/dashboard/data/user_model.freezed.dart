// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get username; int get aura; int get streak; String get title;@JsonKey(name: 'momentum_multiplier') double get momentumMultiplier;@JsonKey(name: 'is_broken') bool get isBroken;@JsonKey(name: 'is_him') bool get isHim;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'last_daily_claim') DateTime? get lastDailyClaim;@JsonKey(name: 'last_weekly_recovery') DateTime? get lastWeeklyRecovery;@JsonKey(name: 'last_weekly_bonus') DateTime? get lastWeeklyBonus;@JsonKey(name: 'last_shield_used') DateTime? get lastShieldUsed;@JsonKey(name: 'last_penalty_at') DateTime? get lastPenaltyAt;@JsonKey(name: 'last_decay_at') DateTime? get lastDecayAt;@JsonKey(name: 'indestructible_until') DateTime? get indestructibleUntil;@JsonKey(name: 'last_indestructible_granted_at') DateTime? get lastIndestructibleGrantedAt;// Prestige fields
@JsonKey(name: 'ascension_count') int get ascensionCount;@JsonKey(name: 'ascension_perks') List<String> get ascensionPerks;@JsonKey(name: 'last_ascension_at') DateTime? get lastAscensionAt;@JsonKey(name: 'total_aura_earned') int get totalAuraEarned;// Bounty Mastery
@JsonKey(name: 'bounty_xp') int get bountyXp;@JsonKey(name: 'bounty_level') int get bountyLevel;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.aura, aura) || other.aura == aura)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.title, title) || other.title == title)&&(identical(other.momentumMultiplier, momentumMultiplier) || other.momentumMultiplier == momentumMultiplier)&&(identical(other.isBroken, isBroken) || other.isBroken == isBroken)&&(identical(other.isHim, isHim) || other.isHim == isHim)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastDailyClaim, lastDailyClaim) || other.lastDailyClaim == lastDailyClaim)&&(identical(other.lastWeeklyRecovery, lastWeeklyRecovery) || other.lastWeeklyRecovery == lastWeeklyRecovery)&&(identical(other.lastWeeklyBonus, lastWeeklyBonus) || other.lastWeeklyBonus == lastWeeklyBonus)&&(identical(other.lastShieldUsed, lastShieldUsed) || other.lastShieldUsed == lastShieldUsed)&&(identical(other.lastPenaltyAt, lastPenaltyAt) || other.lastPenaltyAt == lastPenaltyAt)&&(identical(other.lastDecayAt, lastDecayAt) || other.lastDecayAt == lastDecayAt)&&(identical(other.indestructibleUntil, indestructibleUntil) || other.indestructibleUntil == indestructibleUntil)&&(identical(other.lastIndestructibleGrantedAt, lastIndestructibleGrantedAt) || other.lastIndestructibleGrantedAt == lastIndestructibleGrantedAt)&&(identical(other.ascensionCount, ascensionCount) || other.ascensionCount == ascensionCount)&&const DeepCollectionEquality().equals(other.ascensionPerks, ascensionPerks)&&(identical(other.lastAscensionAt, lastAscensionAt) || other.lastAscensionAt == lastAscensionAt)&&(identical(other.totalAuraEarned, totalAuraEarned) || other.totalAuraEarned == totalAuraEarned)&&(identical(other.bountyXp, bountyXp) || other.bountyXp == bountyXp)&&(identical(other.bountyLevel, bountyLevel) || other.bountyLevel == bountyLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,aura,streak,title,momentumMultiplier,isBroken,isHim,createdAt,lastDailyClaim,lastWeeklyRecovery,lastWeeklyBonus,lastShieldUsed,lastPenaltyAt,lastDecayAt,indestructibleUntil,lastIndestructibleGrantedAt,ascensionCount,const DeepCollectionEquality().hash(ascensionPerks),lastAscensionAt,totalAuraEarned,bountyXp,bountyLevel]);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, aura: $aura, streak: $streak, title: $title, momentumMultiplier: $momentumMultiplier, isBroken: $isBroken, isHim: $isHim, createdAt: $createdAt, lastDailyClaim: $lastDailyClaim, lastWeeklyRecovery: $lastWeeklyRecovery, lastWeeklyBonus: $lastWeeklyBonus, lastShieldUsed: $lastShieldUsed, lastPenaltyAt: $lastPenaltyAt, lastDecayAt: $lastDecayAt, indestructibleUntil: $indestructibleUntil, lastIndestructibleGrantedAt: $lastIndestructibleGrantedAt, ascensionCount: $ascensionCount, ascensionPerks: $ascensionPerks, lastAscensionAt: $lastAscensionAt, totalAuraEarned: $totalAuraEarned, bountyXp: $bountyXp, bountyLevel: $bountyLevel)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String username, int aura, int streak, String title,@JsonKey(name: 'momentum_multiplier') double momentumMultiplier,@JsonKey(name: 'is_broken') bool isBroken,@JsonKey(name: 'is_him') bool isHim,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'last_daily_claim') DateTime? lastDailyClaim,@JsonKey(name: 'last_weekly_recovery') DateTime? lastWeeklyRecovery,@JsonKey(name: 'last_weekly_bonus') DateTime? lastWeeklyBonus,@JsonKey(name: 'last_shield_used') DateTime? lastShieldUsed,@JsonKey(name: 'last_penalty_at') DateTime? lastPenaltyAt,@JsonKey(name: 'last_decay_at') DateTime? lastDecayAt,@JsonKey(name: 'indestructible_until') DateTime? indestructibleUntil,@JsonKey(name: 'last_indestructible_granted_at') DateTime? lastIndestructibleGrantedAt,@JsonKey(name: 'ascension_count') int ascensionCount,@JsonKey(name: 'ascension_perks') List<String> ascensionPerks,@JsonKey(name: 'last_ascension_at') DateTime? lastAscensionAt,@JsonKey(name: 'total_aura_earned') int totalAuraEarned,@JsonKey(name: 'bounty_xp') int bountyXp,@JsonKey(name: 'bounty_level') int bountyLevel
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? aura = null,Object? streak = null,Object? title = null,Object? momentumMultiplier = null,Object? isBroken = null,Object? isHim = null,Object? createdAt = freezed,Object? lastDailyClaim = freezed,Object? lastWeeklyRecovery = freezed,Object? lastWeeklyBonus = freezed,Object? lastShieldUsed = freezed,Object? lastPenaltyAt = freezed,Object? lastDecayAt = freezed,Object? indestructibleUntil = freezed,Object? lastIndestructibleGrantedAt = freezed,Object? ascensionCount = null,Object? ascensionPerks = null,Object? lastAscensionAt = freezed,Object? totalAuraEarned = null,Object? bountyXp = null,Object? bountyLevel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,aura: null == aura ? _self.aura : aura // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,momentumMultiplier: null == momentumMultiplier ? _self.momentumMultiplier : momentumMultiplier // ignore: cast_nullable_to_non_nullable
as double,isBroken: null == isBroken ? _self.isBroken : isBroken // ignore: cast_nullable_to_non_nullable
as bool,isHim: null == isHim ? _self.isHim : isHim // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDailyClaim: freezed == lastDailyClaim ? _self.lastDailyClaim : lastDailyClaim // ignore: cast_nullable_to_non_nullable
as DateTime?,lastWeeklyRecovery: freezed == lastWeeklyRecovery ? _self.lastWeeklyRecovery : lastWeeklyRecovery // ignore: cast_nullable_to_non_nullable
as DateTime?,lastWeeklyBonus: freezed == lastWeeklyBonus ? _self.lastWeeklyBonus : lastWeeklyBonus // ignore: cast_nullable_to_non_nullable
as DateTime?,lastShieldUsed: freezed == lastShieldUsed ? _self.lastShieldUsed : lastShieldUsed // ignore: cast_nullable_to_non_nullable
as DateTime?,lastPenaltyAt: freezed == lastPenaltyAt ? _self.lastPenaltyAt : lastPenaltyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDecayAt: freezed == lastDecayAt ? _self.lastDecayAt : lastDecayAt // ignore: cast_nullable_to_non_nullable
as DateTime?,indestructibleUntil: freezed == indestructibleUntil ? _self.indestructibleUntil : indestructibleUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,lastIndestructibleGrantedAt: freezed == lastIndestructibleGrantedAt ? _self.lastIndestructibleGrantedAt : lastIndestructibleGrantedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ascensionCount: null == ascensionCount ? _self.ascensionCount : ascensionCount // ignore: cast_nullable_to_non_nullable
as int,ascensionPerks: null == ascensionPerks ? _self.ascensionPerks : ascensionPerks // ignore: cast_nullable_to_non_nullable
as List<String>,lastAscensionAt: freezed == lastAscensionAt ? _self.lastAscensionAt : lastAscensionAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalAuraEarned: null == totalAuraEarned ? _self.totalAuraEarned : totalAuraEarned // ignore: cast_nullable_to_non_nullable
as int,bountyXp: null == bountyXp ? _self.bountyXp : bountyXp // ignore: cast_nullable_to_non_nullable
as int,bountyLevel: null == bountyLevel ? _self.bountyLevel : bountyLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  int aura,  int streak,  String title, @JsonKey(name: 'momentum_multiplier')  double momentumMultiplier, @JsonKey(name: 'is_broken')  bool isBroken, @JsonKey(name: 'is_him')  bool isHim, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_daily_claim')  DateTime? lastDailyClaim, @JsonKey(name: 'last_weekly_recovery')  DateTime? lastWeeklyRecovery, @JsonKey(name: 'last_weekly_bonus')  DateTime? lastWeeklyBonus, @JsonKey(name: 'last_shield_used')  DateTime? lastShieldUsed, @JsonKey(name: 'last_penalty_at')  DateTime? lastPenaltyAt, @JsonKey(name: 'last_decay_at')  DateTime? lastDecayAt, @JsonKey(name: 'indestructible_until')  DateTime? indestructibleUntil, @JsonKey(name: 'last_indestructible_granted_at')  DateTime? lastIndestructibleGrantedAt, @JsonKey(name: 'ascension_count')  int ascensionCount, @JsonKey(name: 'ascension_perks')  List<String> ascensionPerks, @JsonKey(name: 'last_ascension_at')  DateTime? lastAscensionAt, @JsonKey(name: 'total_aura_earned')  int totalAuraEarned, @JsonKey(name: 'bounty_xp')  int bountyXp, @JsonKey(name: 'bounty_level')  int bountyLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.aura,_that.streak,_that.title,_that.momentumMultiplier,_that.isBroken,_that.isHim,_that.createdAt,_that.lastDailyClaim,_that.lastWeeklyRecovery,_that.lastWeeklyBonus,_that.lastShieldUsed,_that.lastPenaltyAt,_that.lastDecayAt,_that.indestructibleUntil,_that.lastIndestructibleGrantedAt,_that.ascensionCount,_that.ascensionPerks,_that.lastAscensionAt,_that.totalAuraEarned,_that.bountyXp,_that.bountyLevel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  int aura,  int streak,  String title, @JsonKey(name: 'momentum_multiplier')  double momentumMultiplier, @JsonKey(name: 'is_broken')  bool isBroken, @JsonKey(name: 'is_him')  bool isHim, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_daily_claim')  DateTime? lastDailyClaim, @JsonKey(name: 'last_weekly_recovery')  DateTime? lastWeeklyRecovery, @JsonKey(name: 'last_weekly_bonus')  DateTime? lastWeeklyBonus, @JsonKey(name: 'last_shield_used')  DateTime? lastShieldUsed, @JsonKey(name: 'last_penalty_at')  DateTime? lastPenaltyAt, @JsonKey(name: 'last_decay_at')  DateTime? lastDecayAt, @JsonKey(name: 'indestructible_until')  DateTime? indestructibleUntil, @JsonKey(name: 'last_indestructible_granted_at')  DateTime? lastIndestructibleGrantedAt, @JsonKey(name: 'ascension_count')  int ascensionCount, @JsonKey(name: 'ascension_perks')  List<String> ascensionPerks, @JsonKey(name: 'last_ascension_at')  DateTime? lastAscensionAt, @JsonKey(name: 'total_aura_earned')  int totalAuraEarned, @JsonKey(name: 'bounty_xp')  int bountyXp, @JsonKey(name: 'bounty_level')  int bountyLevel)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.aura,_that.streak,_that.title,_that.momentumMultiplier,_that.isBroken,_that.isHim,_that.createdAt,_that.lastDailyClaim,_that.lastWeeklyRecovery,_that.lastWeeklyBonus,_that.lastShieldUsed,_that.lastPenaltyAt,_that.lastDecayAt,_that.indestructibleUntil,_that.lastIndestructibleGrantedAt,_that.ascensionCount,_that.ascensionPerks,_that.lastAscensionAt,_that.totalAuraEarned,_that.bountyXp,_that.bountyLevel);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  int aura,  int streak,  String title, @JsonKey(name: 'momentum_multiplier')  double momentumMultiplier, @JsonKey(name: 'is_broken')  bool isBroken, @JsonKey(name: 'is_him')  bool isHim, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_daily_claim')  DateTime? lastDailyClaim, @JsonKey(name: 'last_weekly_recovery')  DateTime? lastWeeklyRecovery, @JsonKey(name: 'last_weekly_bonus')  DateTime? lastWeeklyBonus, @JsonKey(name: 'last_shield_used')  DateTime? lastShieldUsed, @JsonKey(name: 'last_penalty_at')  DateTime? lastPenaltyAt, @JsonKey(name: 'last_decay_at')  DateTime? lastDecayAt, @JsonKey(name: 'indestructible_until')  DateTime? indestructibleUntil, @JsonKey(name: 'last_indestructible_granted_at')  DateTime? lastIndestructibleGrantedAt, @JsonKey(name: 'ascension_count')  int ascensionCount, @JsonKey(name: 'ascension_perks')  List<String> ascensionPerks, @JsonKey(name: 'last_ascension_at')  DateTime? lastAscensionAt, @JsonKey(name: 'total_aura_earned')  int totalAuraEarned, @JsonKey(name: 'bounty_xp')  int bountyXp, @JsonKey(name: 'bounty_level')  int bountyLevel)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.aura,_that.streak,_that.title,_that.momentumMultiplier,_that.isBroken,_that.isHim,_that.createdAt,_that.lastDailyClaim,_that.lastWeeklyRecovery,_that.lastWeeklyBonus,_that.lastShieldUsed,_that.lastPenaltyAt,_that.lastDecayAt,_that.indestructibleUntil,_that.lastIndestructibleGrantedAt,_that.ascensionCount,_that.ascensionPerks,_that.lastAscensionAt,_that.totalAuraEarned,_that.bountyXp,_that.bountyLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.username, this.aura = 100, this.streak = 0, this.title = 'INVINCIBLE', @JsonKey(name: 'momentum_multiplier') this.momentumMultiplier = 1.0, @JsonKey(name: 'is_broken') this.isBroken = false, @JsonKey(name: 'is_him') this.isHim = false, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'last_daily_claim') this.lastDailyClaim, @JsonKey(name: 'last_weekly_recovery') this.lastWeeklyRecovery, @JsonKey(name: 'last_weekly_bonus') this.lastWeeklyBonus, @JsonKey(name: 'last_shield_used') this.lastShieldUsed, @JsonKey(name: 'last_penalty_at') this.lastPenaltyAt, @JsonKey(name: 'last_decay_at') this.lastDecayAt, @JsonKey(name: 'indestructible_until') this.indestructibleUntil, @JsonKey(name: 'last_indestructible_granted_at') this.lastIndestructibleGrantedAt, @JsonKey(name: 'ascension_count') this.ascensionCount = 0, @JsonKey(name: 'ascension_perks') final  List<String> ascensionPerks = const [], @JsonKey(name: 'last_ascension_at') this.lastAscensionAt, @JsonKey(name: 'total_aura_earned') this.totalAuraEarned = 0, @JsonKey(name: 'bounty_xp') this.bountyXp = 0, @JsonKey(name: 'bounty_level') this.bountyLevel = 1}): _ascensionPerks = ascensionPerks;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String username;
@override@JsonKey() final  int aura;
@override@JsonKey() final  int streak;
@override@JsonKey() final  String title;
@override@JsonKey(name: 'momentum_multiplier') final  double momentumMultiplier;
@override@JsonKey(name: 'is_broken') final  bool isBroken;
@override@JsonKey(name: 'is_him') final  bool isHim;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'last_daily_claim') final  DateTime? lastDailyClaim;
@override@JsonKey(name: 'last_weekly_recovery') final  DateTime? lastWeeklyRecovery;
@override@JsonKey(name: 'last_weekly_bonus') final  DateTime? lastWeeklyBonus;
@override@JsonKey(name: 'last_shield_used') final  DateTime? lastShieldUsed;
@override@JsonKey(name: 'last_penalty_at') final  DateTime? lastPenaltyAt;
@override@JsonKey(name: 'last_decay_at') final  DateTime? lastDecayAt;
@override@JsonKey(name: 'indestructible_until') final  DateTime? indestructibleUntil;
@override@JsonKey(name: 'last_indestructible_granted_at') final  DateTime? lastIndestructibleGrantedAt;
// Prestige fields
@override@JsonKey(name: 'ascension_count') final  int ascensionCount;
 final  List<String> _ascensionPerks;
@override@JsonKey(name: 'ascension_perks') List<String> get ascensionPerks {
  if (_ascensionPerks is EqualUnmodifiableListView) return _ascensionPerks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ascensionPerks);
}

@override@JsonKey(name: 'last_ascension_at') final  DateTime? lastAscensionAt;
@override@JsonKey(name: 'total_aura_earned') final  int totalAuraEarned;
// Bounty Mastery
@override@JsonKey(name: 'bounty_xp') final  int bountyXp;
@override@JsonKey(name: 'bounty_level') final  int bountyLevel;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.aura, aura) || other.aura == aura)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.title, title) || other.title == title)&&(identical(other.momentumMultiplier, momentumMultiplier) || other.momentumMultiplier == momentumMultiplier)&&(identical(other.isBroken, isBroken) || other.isBroken == isBroken)&&(identical(other.isHim, isHim) || other.isHim == isHim)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastDailyClaim, lastDailyClaim) || other.lastDailyClaim == lastDailyClaim)&&(identical(other.lastWeeklyRecovery, lastWeeklyRecovery) || other.lastWeeklyRecovery == lastWeeklyRecovery)&&(identical(other.lastWeeklyBonus, lastWeeklyBonus) || other.lastWeeklyBonus == lastWeeklyBonus)&&(identical(other.lastShieldUsed, lastShieldUsed) || other.lastShieldUsed == lastShieldUsed)&&(identical(other.lastPenaltyAt, lastPenaltyAt) || other.lastPenaltyAt == lastPenaltyAt)&&(identical(other.lastDecayAt, lastDecayAt) || other.lastDecayAt == lastDecayAt)&&(identical(other.indestructibleUntil, indestructibleUntil) || other.indestructibleUntil == indestructibleUntil)&&(identical(other.lastIndestructibleGrantedAt, lastIndestructibleGrantedAt) || other.lastIndestructibleGrantedAt == lastIndestructibleGrantedAt)&&(identical(other.ascensionCount, ascensionCount) || other.ascensionCount == ascensionCount)&&const DeepCollectionEquality().equals(other._ascensionPerks, _ascensionPerks)&&(identical(other.lastAscensionAt, lastAscensionAt) || other.lastAscensionAt == lastAscensionAt)&&(identical(other.totalAuraEarned, totalAuraEarned) || other.totalAuraEarned == totalAuraEarned)&&(identical(other.bountyXp, bountyXp) || other.bountyXp == bountyXp)&&(identical(other.bountyLevel, bountyLevel) || other.bountyLevel == bountyLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,aura,streak,title,momentumMultiplier,isBroken,isHim,createdAt,lastDailyClaim,lastWeeklyRecovery,lastWeeklyBonus,lastShieldUsed,lastPenaltyAt,lastDecayAt,indestructibleUntil,lastIndestructibleGrantedAt,ascensionCount,const DeepCollectionEquality().hash(_ascensionPerks),lastAscensionAt,totalAuraEarned,bountyXp,bountyLevel]);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, aura: $aura, streak: $streak, title: $title, momentumMultiplier: $momentumMultiplier, isBroken: $isBroken, isHim: $isHim, createdAt: $createdAt, lastDailyClaim: $lastDailyClaim, lastWeeklyRecovery: $lastWeeklyRecovery, lastWeeklyBonus: $lastWeeklyBonus, lastShieldUsed: $lastShieldUsed, lastPenaltyAt: $lastPenaltyAt, lastDecayAt: $lastDecayAt, indestructibleUntil: $indestructibleUntil, lastIndestructibleGrantedAt: $lastIndestructibleGrantedAt, ascensionCount: $ascensionCount, ascensionPerks: $ascensionPerks, lastAscensionAt: $lastAscensionAt, totalAuraEarned: $totalAuraEarned, bountyXp: $bountyXp, bountyLevel: $bountyLevel)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, int aura, int streak, String title,@JsonKey(name: 'momentum_multiplier') double momentumMultiplier,@JsonKey(name: 'is_broken') bool isBroken,@JsonKey(name: 'is_him') bool isHim,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'last_daily_claim') DateTime? lastDailyClaim,@JsonKey(name: 'last_weekly_recovery') DateTime? lastWeeklyRecovery,@JsonKey(name: 'last_weekly_bonus') DateTime? lastWeeklyBonus,@JsonKey(name: 'last_shield_used') DateTime? lastShieldUsed,@JsonKey(name: 'last_penalty_at') DateTime? lastPenaltyAt,@JsonKey(name: 'last_decay_at') DateTime? lastDecayAt,@JsonKey(name: 'indestructible_until') DateTime? indestructibleUntil,@JsonKey(name: 'last_indestructible_granted_at') DateTime? lastIndestructibleGrantedAt,@JsonKey(name: 'ascension_count') int ascensionCount,@JsonKey(name: 'ascension_perks') List<String> ascensionPerks,@JsonKey(name: 'last_ascension_at') DateTime? lastAscensionAt,@JsonKey(name: 'total_aura_earned') int totalAuraEarned,@JsonKey(name: 'bounty_xp') int bountyXp,@JsonKey(name: 'bounty_level') int bountyLevel
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? aura = null,Object? streak = null,Object? title = null,Object? momentumMultiplier = null,Object? isBroken = null,Object? isHim = null,Object? createdAt = freezed,Object? lastDailyClaim = freezed,Object? lastWeeklyRecovery = freezed,Object? lastWeeklyBonus = freezed,Object? lastShieldUsed = freezed,Object? lastPenaltyAt = freezed,Object? lastDecayAt = freezed,Object? indestructibleUntil = freezed,Object? lastIndestructibleGrantedAt = freezed,Object? ascensionCount = null,Object? ascensionPerks = null,Object? lastAscensionAt = freezed,Object? totalAuraEarned = null,Object? bountyXp = null,Object? bountyLevel = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,aura: null == aura ? _self.aura : aura // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,momentumMultiplier: null == momentumMultiplier ? _self.momentumMultiplier : momentumMultiplier // ignore: cast_nullable_to_non_nullable
as double,isBroken: null == isBroken ? _self.isBroken : isBroken // ignore: cast_nullable_to_non_nullable
as bool,isHim: null == isHim ? _self.isHim : isHim // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDailyClaim: freezed == lastDailyClaim ? _self.lastDailyClaim : lastDailyClaim // ignore: cast_nullable_to_non_nullable
as DateTime?,lastWeeklyRecovery: freezed == lastWeeklyRecovery ? _self.lastWeeklyRecovery : lastWeeklyRecovery // ignore: cast_nullable_to_non_nullable
as DateTime?,lastWeeklyBonus: freezed == lastWeeklyBonus ? _self.lastWeeklyBonus : lastWeeklyBonus // ignore: cast_nullable_to_non_nullable
as DateTime?,lastShieldUsed: freezed == lastShieldUsed ? _self.lastShieldUsed : lastShieldUsed // ignore: cast_nullable_to_non_nullable
as DateTime?,lastPenaltyAt: freezed == lastPenaltyAt ? _self.lastPenaltyAt : lastPenaltyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDecayAt: freezed == lastDecayAt ? _self.lastDecayAt : lastDecayAt // ignore: cast_nullable_to_non_nullable
as DateTime?,indestructibleUntil: freezed == indestructibleUntil ? _self.indestructibleUntil : indestructibleUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,lastIndestructibleGrantedAt: freezed == lastIndestructibleGrantedAt ? _self.lastIndestructibleGrantedAt : lastIndestructibleGrantedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ascensionCount: null == ascensionCount ? _self.ascensionCount : ascensionCount // ignore: cast_nullable_to_non_nullable
as int,ascensionPerks: null == ascensionPerks ? _self._ascensionPerks : ascensionPerks // ignore: cast_nullable_to_non_nullable
as List<String>,lastAscensionAt: freezed == lastAscensionAt ? _self.lastAscensionAt : lastAscensionAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalAuraEarned: null == totalAuraEarned ? _self.totalAuraEarned : totalAuraEarned // ignore: cast_nullable_to_non_nullable
as int,bountyXp: null == bountyXp ? _self.bountyXp : bountyXp // ignore: cast_nullable_to_non_nullable
as int,bountyLevel: null == bountyLevel ? _self.bountyLevel : bountyLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
