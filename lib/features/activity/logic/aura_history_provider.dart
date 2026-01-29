import 'package:bro_leveling/features/dashboard/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final auraHistoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      final repository = ref.watch(userRepositoryProvider);
      return repository.getAuraHistory();
    });
