// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proposal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProposalModel {

 String get id;@JsonKey(name: 'proposer_id') String get proposerId;@JsonKey(name: 'target_user_id') String get targetUserId; int get amount; String get type;// 'boost' or 'penalty'
 String get reason; String get status;// 'pending', 'approved', 'rejected'
@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'closes_at') DateTime get closesAt;@JsonKey(name: 'target_username') String? get targetUsername;@JsonKey(name: 'support_voter_ids') List<String> get supportVoterIds;@JsonKey(name: 'reject_voter_ids') List<String> get rejectVoterIds; bool get shielded;
/// Create a copy of ProposalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProposalModelCopyWith<ProposalModel> get copyWith => _$ProposalModelCopyWithImpl<ProposalModel>(this as ProposalModel, _$identity);

  /// Serializes this ProposalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProposalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.proposerId, proposerId) || other.proposerId == proposerId)&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.targetUsername, targetUsername) || other.targetUsername == targetUsername)&&const DeepCollectionEquality().equals(other.supportVoterIds, supportVoterIds)&&const DeepCollectionEquality().equals(other.rejectVoterIds, rejectVoterIds)&&(identical(other.shielded, shielded) || other.shielded == shielded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,proposerId,targetUserId,amount,type,reason,status,createdAt,closesAt,targetUsername,const DeepCollectionEquality().hash(supportVoterIds),const DeepCollectionEquality().hash(rejectVoterIds),shielded);

@override
String toString() {
  return 'ProposalModel(id: $id, proposerId: $proposerId, targetUserId: $targetUserId, amount: $amount, type: $type, reason: $reason, status: $status, createdAt: $createdAt, closesAt: $closesAt, targetUsername: $targetUsername, supportVoterIds: $supportVoterIds, rejectVoterIds: $rejectVoterIds, shielded: $shielded)';
}


}

/// @nodoc
abstract mixin class $ProposalModelCopyWith<$Res>  {
  factory $ProposalModelCopyWith(ProposalModel value, $Res Function(ProposalModel) _then) = _$ProposalModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'proposer_id') String proposerId,@JsonKey(name: 'target_user_id') String targetUserId, int amount, String type, String reason, String status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'closes_at') DateTime closesAt,@JsonKey(name: 'target_username') String? targetUsername,@JsonKey(name: 'support_voter_ids') List<String> supportVoterIds,@JsonKey(name: 'reject_voter_ids') List<String> rejectVoterIds, bool shielded
});




}
/// @nodoc
class _$ProposalModelCopyWithImpl<$Res>
    implements $ProposalModelCopyWith<$Res> {
  _$ProposalModelCopyWithImpl(this._self, this._then);

  final ProposalModel _self;
  final $Res Function(ProposalModel) _then;

/// Create a copy of ProposalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? proposerId = null,Object? targetUserId = null,Object? amount = null,Object? type = null,Object? reason = null,Object? status = null,Object? createdAt = null,Object? closesAt = null,Object? targetUsername = freezed,Object? supportVoterIds = null,Object? rejectVoterIds = null,Object? shielded = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,proposerId: null == proposerId ? _self.proposerId : proposerId // ignore: cast_nullable_to_non_nullable
as String,targetUserId: null == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,closesAt: null == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetUsername: freezed == targetUsername ? _self.targetUsername : targetUsername // ignore: cast_nullable_to_non_nullable
as String?,supportVoterIds: null == supportVoterIds ? _self.supportVoterIds : supportVoterIds // ignore: cast_nullable_to_non_nullable
as List<String>,rejectVoterIds: null == rejectVoterIds ? _self.rejectVoterIds : rejectVoterIds // ignore: cast_nullable_to_non_nullable
as List<String>,shielded: null == shielded ? _self.shielded : shielded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProposalModel].
extension ProposalModelPatterns on ProposalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProposalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProposalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProposalModel value)  $default,){
final _that = this;
switch (_that) {
case _ProposalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProposalModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProposalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'proposer_id')  String proposerId, @JsonKey(name: 'target_user_id')  String targetUserId,  int amount,  String type,  String reason,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'closes_at')  DateTime closesAt, @JsonKey(name: 'target_username')  String? targetUsername, @JsonKey(name: 'support_voter_ids')  List<String> supportVoterIds, @JsonKey(name: 'reject_voter_ids')  List<String> rejectVoterIds,  bool shielded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProposalModel() when $default != null:
return $default(_that.id,_that.proposerId,_that.targetUserId,_that.amount,_that.type,_that.reason,_that.status,_that.createdAt,_that.closesAt,_that.targetUsername,_that.supportVoterIds,_that.rejectVoterIds,_that.shielded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'proposer_id')  String proposerId, @JsonKey(name: 'target_user_id')  String targetUserId,  int amount,  String type,  String reason,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'closes_at')  DateTime closesAt, @JsonKey(name: 'target_username')  String? targetUsername, @JsonKey(name: 'support_voter_ids')  List<String> supportVoterIds, @JsonKey(name: 'reject_voter_ids')  List<String> rejectVoterIds,  bool shielded)  $default,) {final _that = this;
switch (_that) {
case _ProposalModel():
return $default(_that.id,_that.proposerId,_that.targetUserId,_that.amount,_that.type,_that.reason,_that.status,_that.createdAt,_that.closesAt,_that.targetUsername,_that.supportVoterIds,_that.rejectVoterIds,_that.shielded);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'proposer_id')  String proposerId, @JsonKey(name: 'target_user_id')  String targetUserId,  int amount,  String type,  String reason,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'closes_at')  DateTime closesAt, @JsonKey(name: 'target_username')  String? targetUsername, @JsonKey(name: 'support_voter_ids')  List<String> supportVoterIds, @JsonKey(name: 'reject_voter_ids')  List<String> rejectVoterIds,  bool shielded)?  $default,) {final _that = this;
switch (_that) {
case _ProposalModel() when $default != null:
return $default(_that.id,_that.proposerId,_that.targetUserId,_that.amount,_that.type,_that.reason,_that.status,_that.createdAt,_that.closesAt,_that.targetUsername,_that.supportVoterIds,_that.rejectVoterIds,_that.shielded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProposalModel extends ProposalModel {
  const _ProposalModel({required this.id, @JsonKey(name: 'proposer_id') required this.proposerId, @JsonKey(name: 'target_user_id') required this.targetUserId, required this.amount, required this.type, required this.reason, required this.status, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'closes_at') required this.closesAt, @JsonKey(name: 'target_username') this.targetUsername, @JsonKey(name: 'support_voter_ids') final  List<String> supportVoterIds = const [], @JsonKey(name: 'reject_voter_ids') final  List<String> rejectVoterIds = const [], this.shielded = false}): _supportVoterIds = supportVoterIds,_rejectVoterIds = rejectVoterIds,super._();
  factory _ProposalModel.fromJson(Map<String, dynamic> json) => _$ProposalModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'proposer_id') final  String proposerId;
@override@JsonKey(name: 'target_user_id') final  String targetUserId;
@override final  int amount;
@override final  String type;
// 'boost' or 'penalty'
@override final  String reason;
@override final  String status;
// 'pending', 'approved', 'rejected'
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'closes_at') final  DateTime closesAt;
@override@JsonKey(name: 'target_username') final  String? targetUsername;
 final  List<String> _supportVoterIds;
@override@JsonKey(name: 'support_voter_ids') List<String> get supportVoterIds {
  if (_supportVoterIds is EqualUnmodifiableListView) return _supportVoterIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportVoterIds);
}

 final  List<String> _rejectVoterIds;
@override@JsonKey(name: 'reject_voter_ids') List<String> get rejectVoterIds {
  if (_rejectVoterIds is EqualUnmodifiableListView) return _rejectVoterIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rejectVoterIds);
}

@override@JsonKey() final  bool shielded;

/// Create a copy of ProposalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProposalModelCopyWith<_ProposalModel> get copyWith => __$ProposalModelCopyWithImpl<_ProposalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProposalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProposalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.proposerId, proposerId) || other.proposerId == proposerId)&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.targetUsername, targetUsername) || other.targetUsername == targetUsername)&&const DeepCollectionEquality().equals(other._supportVoterIds, _supportVoterIds)&&const DeepCollectionEquality().equals(other._rejectVoterIds, _rejectVoterIds)&&(identical(other.shielded, shielded) || other.shielded == shielded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,proposerId,targetUserId,amount,type,reason,status,createdAt,closesAt,targetUsername,const DeepCollectionEquality().hash(_supportVoterIds),const DeepCollectionEquality().hash(_rejectVoterIds),shielded);

@override
String toString() {
  return 'ProposalModel(id: $id, proposerId: $proposerId, targetUserId: $targetUserId, amount: $amount, type: $type, reason: $reason, status: $status, createdAt: $createdAt, closesAt: $closesAt, targetUsername: $targetUsername, supportVoterIds: $supportVoterIds, rejectVoterIds: $rejectVoterIds, shielded: $shielded)';
}


}

/// @nodoc
abstract mixin class _$ProposalModelCopyWith<$Res> implements $ProposalModelCopyWith<$Res> {
  factory _$ProposalModelCopyWith(_ProposalModel value, $Res Function(_ProposalModel) _then) = __$ProposalModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'proposer_id') String proposerId,@JsonKey(name: 'target_user_id') String targetUserId, int amount, String type, String reason, String status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'closes_at') DateTime closesAt,@JsonKey(name: 'target_username') String? targetUsername,@JsonKey(name: 'support_voter_ids') List<String> supportVoterIds,@JsonKey(name: 'reject_voter_ids') List<String> rejectVoterIds, bool shielded
});




}
/// @nodoc
class __$ProposalModelCopyWithImpl<$Res>
    implements _$ProposalModelCopyWith<$Res> {
  __$ProposalModelCopyWithImpl(this._self, this._then);

  final _ProposalModel _self;
  final $Res Function(_ProposalModel) _then;

/// Create a copy of ProposalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? proposerId = null,Object? targetUserId = null,Object? amount = null,Object? type = null,Object? reason = null,Object? status = null,Object? createdAt = null,Object? closesAt = null,Object? targetUsername = freezed,Object? supportVoterIds = null,Object? rejectVoterIds = null,Object? shielded = null,}) {
  return _then(_ProposalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,proposerId: null == proposerId ? _self.proposerId : proposerId // ignore: cast_nullable_to_non_nullable
as String,targetUserId: null == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,closesAt: null == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetUsername: freezed == targetUsername ? _self.targetUsername : targetUsername // ignore: cast_nullable_to_non_nullable
as String?,supportVoterIds: null == supportVoterIds ? _self._supportVoterIds : supportVoterIds // ignore: cast_nullable_to_non_nullable
as List<String>,rejectVoterIds: null == rejectVoterIds ? _self._rejectVoterIds : rejectVoterIds // ignore: cast_nullable_to_non_nullable
as List<String>,shielded: null == shielded ? _self.shielded : shielded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
