import 'package:bro_leveling/features/chat/data/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(Supabase.instance.client);
});

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  Stream<List<MessageModel>> getMessagesStream() {
    return _client
        .from('group_messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(50)
        .asyncMap((data) async {
          if (data.isEmpty) return [];

          // Get unique sender IDs
          final senderIds = data
              .map((e) => e['sender_id'] as String)
              .toSet()
              .toList();

          if (senderIds.isEmpty) return [];

          // Fetch sender info
          final users = await _client
              .from('users')
              .select('id, username, aura, is_him, is_broken')
              .filter('id', 'in', senderIds);

          final userMap = {for (final u in users) u['id'] as String: u};

          return data.map((json) {
            final senderInfo = userMap[json['sender_id']];
            return MessageModel.fromJson({
              ...json,
              'sender_name': senderInfo?['username'] ?? 'Unknown',
              'sender_aura': senderInfo?['aura'] ?? 0,
              'is_him': senderInfo?['is_him'] ?? false,
              'is_broken': senderInfo?['is_broken'] ?? false,
            });
          }).toList();
        });
  }

  Future<void> sendMessage(String content) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('group_messages').insert({
      'sender_id': user.id,
      'content': content.trim(),
    });
  }
}
