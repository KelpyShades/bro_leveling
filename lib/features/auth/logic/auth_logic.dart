import 'package:bro_leveling/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple logic layer for Authentication actions.
class AuthLogic {
  final Ref _ref;

  AuthLogic(this._ref);

  Future<void> signIn({required String email, required String password}) async {
    await _ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password}) async {
    await _ref
        .read(authRepositoryProvider)
        .signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }
}

final authLogicProvider = Provider<AuthLogic>((ref) => AuthLogic(ref));
