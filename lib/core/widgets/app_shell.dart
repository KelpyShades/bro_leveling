import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // Map shell index (0,1,2,3) to visual index (0,1,3,4)
    final shellIndex = navigationShell.currentIndex;
    final visualIndex = shellIndex < 2 ? shellIndex : shellIndex + 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/proposals'),
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(16)),
        // ),
        elevation: 8,
        child: const Icon(Icons.gavel),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavBar(
        currentIndex: visualIndex,
        onTap: (index) {
          if (index == 2) {
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
