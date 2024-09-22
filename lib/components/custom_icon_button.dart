import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onPressed; // Made optional
  final EdgeInsetsGeometry? padding; // Optional padding

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
    this.onPressed, // Make onPressed optional
    this.padding, // Make padding optional
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: size),
      onPressed: onPressed,
      padding: padding ?? const EdgeInsets.all(0), // Use provided padding or default to none
    );
  }
}
