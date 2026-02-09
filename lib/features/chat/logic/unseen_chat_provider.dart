import 'package:bro_leveling/features/chat/logic/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastReadChatTimeNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('last_read_chat_time');
    if (stored != null) {
      state = DateTime.parse(stored);
    }
  }

  Future<void> markAsRead() async {
    final now = DateTime.now();
    state = now;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_read_chat_time', now.toIso8601String());
  }
}

final lastReadChatTimeProvider =
    NotifierProvider<LastReadChatTimeNotifier, DateTime?>(() {
      return LastReadChatTimeNotifier();
    });

final unseenChatCountProvider = Provider.autoDispose<int>((ref) {
  final messages = ref.watch(chatMessagesProvider).value ?? [];
  final lastRead = ref.watch(lastReadChatTimeProvider);

  if (lastRead == null) {
    return messages.length;
  }

  return messages.where((m) => m.createdAt.isAfter(lastRead)).length;
});
