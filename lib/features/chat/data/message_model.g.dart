// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      senderName: json['sender_name'] as String?,
      senderAura: (json['sender_aura'] as num?)?.toInt() ?? 0,
      isHim: json['is_him'] as bool? ?? false,
      isBroken: json['is_broken'] as bool? ?? false,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'sender_name': instance.senderName,
      'sender_aura': instance.senderAura,
      'is_him': instance.isHim,
      'is_broken': instance.isBroken,
    };
