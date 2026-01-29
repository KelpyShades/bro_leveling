import 'package:bro_leveling/features/chat/logic/chat_provider.dart';
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:bro_leveling/features/proposals/logic/proposal_provider.dart';
import 'package:bro_leveling/features/leaderboard/logic/leaderboard_provider.dart';
import 'package:bro_leveling/features/activity/logic/activity_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A wrapper widget that watches essential providers to keep them alive
/// even when navigating between standalone screens and the tab shell.
class DataShell extends ConsumerWidget {
  final Widget child;
  const DataShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We listen to these providers to prevent them from auto-disposing
    // without triggering rebuilds of the shell itself.
    ref.listen(userProvider, (_, _) {});
    ref.listen(proposalsProvider, (_, _) {});
    ref.listen(userVotesProvider, (_, _) {});
    ref.listen(chatMessagesProvider, (_, _) {});
    ref.listen(leaderboardProvider, (_, _) {});
    ref.listen(personalActivityProvider, (_, _) {});
    ref.listen(globalActivityProvider, (_, _) {});

    return child;
  }
}
