import 'package:flutter/material.dart';

class ModeSelector extends StatelessWidget {
  final bool isScientific;
  final VoidCallback onToggle;

  const ModeSelector({super.key, required this.isScientific, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isScientific ? Icons.calculate : Icons.science),
      onPressed: onToggle,
    );
  }
}
