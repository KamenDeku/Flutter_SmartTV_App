import 'package:flutter/material.dart';

class FocusableItem extends StatelessWidget {
  final bool isFocused;
  final Widget child;

  const FocusableItem({
    super.key,
    required this.isFocused,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: isFocused
          ? (Matrix4.identity()..scale(1.1))
          : Matrix4.identity(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFocused ? Colors.red : Colors.transparent,
          width: 3,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ]
            : [],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(4), child: child),
    );
  }
}
