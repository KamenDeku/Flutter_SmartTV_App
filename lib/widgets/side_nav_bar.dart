import 'package:flutter/material.dart';
import 'focusable_item.dart';

class SideNavBar extends StatelessWidget {
  final bool isFocused;
  final int focusedIndex;

  final List<IconData> navIcons = const [
    Icons.home_filled,
    Icons.search,
    Icons.person,
    Icons.cast,
    Icons.settings,
  ];

  final List<String> sectionLabels = const ["MAIN"];

  const SideNavBar({
    super.key,
    required this.isFocused,
    required this.focusedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: const Color(0xFF161A23),
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF2D2F39),
            ),
            child: Icon(
              Icons.gamepad,
              color: const Color(0xFF4EBD5B),
              size: 28,
            ),
          ),
          const SizedBox(height: 30),

          Text(
            sectionLabels[0],
            style: const TextStyle(
              color: Color(0xFF757575),
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          ...List.generate(navIcons.length, (index) {
            final focused = isFocused && focusedIndex == index;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FocusableItem(
                isFocused: focused,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: focused
                        ? const Color(0xFF2D2F39)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    navIcons[index],
                    color: focused
                        ? const Color(0xFF4EBD5B)
                        : const Color(0xFF4EBD5B),
                    size: 28,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
