import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/widgets/bottom_nav_bar.dart';
import 'package:bro_leveling/features/chat/logic/unseen_chat_provider.dart';
import 'package:bro_leveling/features/proposals/logic/proposal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Map shell index (0,1,2,3) to visual index (0,1,3,4)
    final shellIndex = navigationShell.currentIndex;
    final visualIndex = shellIndex < 2 ? shellIndex : shellIndex + 1;

    final chatCount = ref.watch(unseenChatCountProvider);
    final activeProposals = ref.watch(activeProposalsCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: navigationShell,
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () => context.go('/proposals'),
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.black,
            // shape: const RoundedRectangleBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(16)),
            // ),
            elevation: 8,
            child: const Icon(Icons.gavel),
          ),
          if (activeProposals > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  '$activeProposals',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavBar(
        currentIndex: visualIndex,
        chatBadgeCount: chatCount,
        onTap: (index) {
          if (index == 2) {
            ref.read(lastReadChatTimeProvider.notifier).markAsRead();
            context.go('/chat');
            return;
          }

          // Map visual index (0,1,3,4) back to shell index (0,1,2,3)
          final branchIndex = index < 2 ? index : index - 1;

          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == shellIndex,
          );
        },
      ),
    );
  }
}
