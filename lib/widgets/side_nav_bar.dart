import 'package:flutter/material.dart';
import 'focusable_item.dart';

class SideNavBar extends StatelessWidget {
  final bool isFocused;
  final int focusedIndex;
  final List<String> navItems = const [
    "Home",
    "Series",
    "Movies",
    "My List",
    "Search",
  ];

  const SideNavBar({
    super.key,
    required this.isFocused,
    required this.focusedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'StreaMAX',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 60),
          ...List.generate(navItems.length, (index) {
            return FocusableItem(
              isFocused: isFocused && focusedIndex == index,
              child: Text(
                navItems[index],
                style: const TextStyle(fontSize: 22),
              ),
            );
          }),
        ],
      ),
    );
  }
}
