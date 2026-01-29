import 'package:bro_leveling/core/constants/theme.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          // Center Proposal Button (highlighted)
          buildCenterButton(2, Icons.gavel),
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

  Widget buildCenterButton(int index, IconData icon) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isSelected
                ? [AppColors.gold, AppColors.goldDark]
                : [AppColors.surfaceLight, AppColors.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: (isSelected ? AppColors.gold : Colors.black).withAlpha(80),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.background : AppColors.gold,
          size: 24,
        ),
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
