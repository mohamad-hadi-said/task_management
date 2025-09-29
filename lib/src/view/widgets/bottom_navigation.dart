import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D2E),
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.2),
        ),
        
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.check_circle_outline,
            label: 'المهام',
            index: 0,
            isSelected: currentIndex == 0,
          ),
          // _buildNavItem(
          //   icon: Icons.notifications,
          //   label: 'الإشعارات',
          //   index: 1,
          //   isSelected: currentIndex == 1,
          // ),
          _buildNavItem(
            icon: Icons.settings_outlined,
            label: 'الإعدادات',
            index: 2,
            isSelected: currentIndex == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap?.call(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
            icon,
            color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
            size: 28,
          ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
