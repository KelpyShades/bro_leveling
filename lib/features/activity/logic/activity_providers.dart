import 'package:bro_leveling/features/dashboard/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches the current user's personal activity history.
final personalActivityProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      final repository = ref.watch(userRepositoryProvider);
      return repository.getAuraHistory();
    });

/// Fetches the global activity feed (last 24 hours of events).
final globalActivityProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      final repository = ref.watch(userRepositoryProvider);
      return repository.getGlobalAuraHistory();
    });
