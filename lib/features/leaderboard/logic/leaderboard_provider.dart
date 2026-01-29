import 'package:bro_leveling/features/dashboard/data/user_model.dart';
import 'package:bro_leveling/features/dashboard/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaderboardProvider = StreamProvider.autoDispose<List<UserModel>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getLeaderboardStream();
});
