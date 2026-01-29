import 'package:bro_leveling/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gold.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
          buildNavItem(
            1,
            Icons.leaderboard_outlined,
            Icons.leaderboard,
            'Ranks',
          ),
          buildNavItem(2, Icons.chat_bubble_outline, Icons.chat_bubble, 'Chat'),
          buildNavItem(
            3,
            Icons.history_edu_outlined,
            Icons.history_edu,
            'Activity',
          ),
          buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
        ],
      ),
    );
  }

  Widget buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.gold : AppColors.textMuted;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
