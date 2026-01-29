import 'package:bro_leveling/core/utils/aura_utils.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
sealed class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    required String id,
    @JsonKey(name: 'sender_id') required String senderId,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Joined data
    @JsonKey(name: 'sender_name') String? senderName,
    @JsonKey(name: 'sender_aura') @Default(0) int senderAura,
    @JsonKey(name: 'is_him') @Default(false) bool isHim,
    @JsonKey(name: 'is_broken') @Default(false) bool isBroken,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  String get title => getTitle(senderAura, isHim: isHim);
  Color get titleColor => getAuraColor(senderAura, isBroken: isBroken);
}
