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

 String get id; String get username; int get aura; int get streak;@JsonKey(name: 'is_broken') bool get isBroken;@JsonKey(name: 'is_him') bool get isHim;@JsonKey(name: 'last_daily_claim') DateTime? get lastDailyClaim;@JsonKey(name: 'last_shield_used') DateTime? get lastShieldUsed;@JsonKey(name: 'last_penalty_at') DateTime? get lastPenaltyAt;@JsonKey(name: 'last_decay_at') DateTime? get lastDecayAt;@JsonKey(name: 'indestructible_until') DateTime? get indestructibleUntil;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.aura, aura) || other.aura == aura)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.isBroken, isBroken) || other.isBroken == isBroken)&&(identical(other.isHim, isHim) || other.isHim == isHim)&&(identical(other.lastDailyClaim, lastDailyClaim) || other.lastDailyClaim == lastDailyClaim)&&(identical(other.lastShieldUsed, lastShieldUsed) || other.lastShieldUsed == lastShieldUsed)&&(identical(other.lastPenaltyAt, lastPenaltyAt) || other.lastPenaltyAt == lastPenaltyAt)&&(identical(other.lastDecayAt, lastDecayAt) || other.lastDecayAt == lastDecayAt)&&(identical(other.indestructibleUntil, indestructibleUntil) || other.indestructibleUntil == indestructibleUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,aura,streak,isBroken,isHim,lastDailyClaim,lastShieldUsed,lastPenaltyAt,lastDecayAt,indestructibleUntil);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, aura: $aura, streak: $streak, isBroken: $isBroken, isHim: $isHim, lastDailyClaim: $lastDailyClaim, lastShieldUsed: $lastShieldUsed, lastPenaltyAt: $lastPenaltyAt, lastDecayAt: $lastDecayAt, indestructibleUntil: $indestructibleUntil)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String username, int aura, int streak,@JsonKey(name: 'is_broken') bool isBroken,@JsonKey(name: 'is_him') bool isHim,@JsonKey(name: 'last_daily_claim') DateTime? lastDailyClaim,@JsonKey(name: 'last_shield_used') DateTime? lastShieldUsed,@JsonKey(name: 'last_penalty_at') DateTime? lastPenaltyAt,@JsonKey(name: 'last_decay_at') DateTime? lastDecayAt,@JsonKey(name: 'indestructible_until') DateTime? indestructibleUntil
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? aura = null,Object? streak = null,Object? isBroken = null,Object? isHim = null,Object? lastDailyClaim = freezed,Object? lastShieldUsed = freezed,Object? lastPenaltyAt = freezed,Object? lastDecayAt = freezed,Object? indestructibleUntil = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,aura: null == aura ? _self.aura : aura // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,isBroken: null == isBroken ? _self.isBroken : isBroken // ignore: cast_nullable_to_non_nullable
as bool,isHim: null == isHim ? _self.isHim : isHim // ignore: cast_nullable_to_non_nullable
as bool,lastDailyClaim: freezed == lastDailyClaim ? _self.lastDailyClaim : lastDailyClaim // ignore: cast_nullable_to_non_nullable
as DateTime?,lastShieldUsed: freezed == lastShieldUsed ? _self.lastShieldUsed : lastShieldUsed // ignore: cast_nullable_to_non_nullable
as DateTime?,lastPenaltyAt: freezed == lastPenaltyAt ? _self.lastPenaltyAt : lastPenaltyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDecayAt: freezed == lastDecayAt ? _self.lastDecayAt : lastDecayAt // ignore: cast_nullable_to_non_nullable
as DateTime?,indestructibleUntil: freezed == indestructibleUntil ? _self.indestructibleUntil : indestructibleUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  int aura,  int streak, @JsonKey(name: 'is_broken')  bool isBroken, @JsonKey(name: 'is_him')  bool isHim, @JsonKey(name: 'last_daily_claim')  DateTime? lastDailyClaim, @JsonKey(name: 'last_shield_used')  DateTime? lastShieldUsed, @JsonKey(name: 'last_penalty_at')  DateTime? lastPenaltyAt, @JsonKey(name: 'last_decay_at')  DateTime? lastDecayAt, @JsonKey(name: 'indestructible_until')  DateTime? indestructibleUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.aura,_that.streak,_that.isBroken,_that.isHim,_that.lastDailyClaim,_that.lastShieldUsed,_that.lastPenaltyAt,_that.lastDecayAt,_that.indestructibleUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  int aura,  int streak, @JsonKey(name: 'is_broken')  bool isBroken, @JsonKey(name: 'is_him')  bool isHim, @JsonKey(name: 'last_daily_claim')  DateTime? lastDailyClaim, @JsonKey(name: 'last_shield_used')  DateTime? lastShieldUsed, @JsonKey(name: 'last_penalty_at')  DateTime? lastPenaltyAt, @JsonKey(name: 'last_decay_at')  DateTime? lastDecayAt, @JsonKey(name: 'indestructible_until')  DateTime? indestructibleUntil)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.aura,_that.streak,_that.isBroken,_that.isHim,_that.lastDailyClaim,_that.lastShieldUsed,_that.lastPenaltyAt,_that.lastDecayAt,_that.indestructibleUntil);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  int aura,  int streak, @JsonKey(name: 'is_broken')  bool isBroken, @JsonKey(name: 'is_him')  bool isHim, @JsonKey(name: 'last_daily_claim')  DateTime? lastDailyClaim, @JsonKey(name: 'last_shield_used')  DateTime? lastShieldUsed, @JsonKey(name: 'last_penalty_at')  DateTime? lastPenaltyAt, @JsonKey(name: 'last_decay_at')  DateTime? lastDecayAt, @JsonKey(name: 'indestructible_until')  DateTime? indestructibleUntil)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.aura,_that.streak,_that.isBroken,_that.isHim,_that.lastDailyClaim,_that.lastShieldUsed,_that.lastPenaltyAt,_that.lastDecayAt,_that.indestructibleUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.username, this.aura = 100, this.streak = 0, @JsonKey(name: 'is_broken') this.isBroken = false, @JsonKey(name: 'is_him') this.isHim = false, @JsonKey(name: 'last_daily_claim') this.lastDailyClaim, @JsonKey(name: 'last_shield_used') this.lastShieldUsed, @JsonKey(name: 'last_penalty_at') this.lastPenaltyAt, @JsonKey(name: 'last_decay_at') this.lastDecayAt, @JsonKey(name: 'indestructible_until') this.indestructibleUntil});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String username;
@override@JsonKey() final  int aura;
@override@JsonKey() final  int streak;
@override@JsonKey(name: 'is_broken') final  bool isBroken;
@override@JsonKey(name: 'is_him') final  bool isHim;
@override@JsonKey(name: 'last_daily_claim') final  DateTime? lastDailyClaim;
@override@JsonKey(name: 'last_shield_used') final  DateTime? lastShieldUsed;
@override@JsonKey(name: 'last_penalty_at') final  DateTime? lastPenaltyAt;
@override@JsonKey(name: 'last_decay_at') final  DateTime? lastDecayAt;
@override@JsonKey(name: 'indestructible_until') final  DateTime? indestructibleUntil;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.aura, aura) || other.aura == aura)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.isBroken, isBroken) || other.isBroken == isBroken)&&(identical(other.isHim, isHim) || other.isHim == isHim)&&(identical(other.lastDailyClaim, lastDailyClaim) || other.lastDailyClaim == lastDailyClaim)&&(identical(other.lastShieldUsed, lastShieldUsed) || other.lastShieldUsed == lastShieldUsed)&&(identical(other.lastPenaltyAt, lastPenaltyAt) || other.lastPenaltyAt == lastPenaltyAt)&&(identical(other.lastDecayAt, lastDecayAt) || other.lastDecayAt == lastDecayAt)&&(identical(other.indestructibleUntil, indestructibleUntil) || other.indestructibleUntil == indestructibleUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,aura,streak,isBroken,isHim,lastDailyClaim,lastShieldUsed,lastPenaltyAt,lastDecayAt,indestructibleUntil);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, aura: $aura, streak: $streak, isBroken: $isBroken, isHim: $isHim, lastDailyClaim: $lastDailyClaim, lastShieldUsed: $lastShieldUsed, lastPenaltyAt: $lastPenaltyAt, lastDecayAt: $lastDecayAt, indestructibleUntil: $indestructibleUntil)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, int aura, int streak,@JsonKey(name: 'is_broken') bool isBroken,@JsonKey(name: 'is_him') bool isHim,@JsonKey(name: 'last_daily_claim') DateTime? lastDailyClaim,@JsonKey(name: 'last_shield_used') DateTime? lastShieldUsed,@JsonKey(name: 'last_penalty_at') DateTime? lastPenaltyAt,@JsonKey(name: 'last_decay_at') DateTime? lastDecayAt,@JsonKey(name: 'indestructible_until') DateTime? indestructibleUntil
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? aura = null,Object? streak = null,Object? isBroken = null,Object? isHim = null,Object? lastDailyClaim = freezed,Object? lastShieldUsed = freezed,Object? lastPenaltyAt = freezed,Object? lastDecayAt = freezed,Object? indestructibleUntil = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,aura: null == aura ? _self.aura : aura // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,isBroken: null == isBroken ? _self.isBroken : isBroken // ignore: cast_nullable_to_non_nullable
as bool,isHim: null == isHim ? _self.isHim : isHim // ignore: cast_nullable_to_non_nullable
as bool,lastDailyClaim: freezed == lastDailyClaim ? _self.lastDailyClaim : lastDailyClaim // ignore: cast_nullable_to_non_nullable
as DateTime?,lastShieldUsed: freezed == lastShieldUsed ? _self.lastShieldUsed : lastShieldUsed // ignore: cast_nullable_to_non_nullable
as DateTime?,lastPenaltyAt: freezed == lastPenaltyAt ? _self.lastPenaltyAt : lastPenaltyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDecayAt: freezed == lastDecayAt ? _self.lastDecayAt : lastDecayAt // ignore: cast_nullable_to_non_nullable
as DateTime?,indestructibleUntil: freezed == indestructibleUntil ? _self.indestructibleUntil : indestructibleUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
