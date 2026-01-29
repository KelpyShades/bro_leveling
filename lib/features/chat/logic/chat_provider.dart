import 'package:bro_leveling/features/chat/data/chat_repository.dart';
import 'package:bro_leveling/features/chat/data/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatMessagesProvider = StreamProvider.autoDispose<List<MessageModel>>((
  ref,
) {
  return ref.watch(chatRepositoryProvider).getMessagesStream();
});

class ChatLogic {
  final Ref _ref;
  ChatLogic(this._ref);

  Future<void> sendMessage(String content) async {
    await _ref.read(chatRepositoryProvider).sendMessage(content);
  }
}

final chatLogicProvider = Provider<ChatLogic>((ref) => ChatLogic(ref));
