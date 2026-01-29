import 'package:bro_leveling/features/dashboard/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple notifier to handle UI actions for User/Home features.
class UserLogic {
  final Ref _ref;

  UserLogic(this._ref);

  Future<Map<String, dynamic>> claimDaily() async {
    return await _ref.read(userRepositoryProvider).claimDaily();
  }

  Future<void> claimWeeklyRecovery() async {
    await _ref.read(userRepositoryProvider).claimWeeklyRecovery();
  }

  Future<bool> checkUserExists() async {
    return await _ref.read(userRepositoryProvider).userExists();
  }

  Future<void> shareAura({
    required String toUserId,
    required int amount,
  }) async {
    await _ref
        .read(userRepositoryProvider)
        .shareAura(toUserId: toUserId, amount: amount);
  }

  Future<void> createUser(String username) async {
    await _ref.read(userRepositoryProvider).createUser(username);
  }
}

final userLogicProvider = Provider<UserLogic>((ref) => UserLogic(ref));
