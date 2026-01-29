import 'package:bro_leveling/features/dashboard/data/user_repository.dart';
import 'package:bro_leveling/features/dashboard/data/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserStream();
});
