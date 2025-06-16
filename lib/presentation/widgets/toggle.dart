import 'package:flutter/material.dart';

class ToggleIcon extends StatelessWidget {
  final bool isOn;
  final VoidCallback onToggle;

  const ToggleIcon({super.key, required this.isOn, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isOn ? Icons.toggle_on : Icons.toggle_off,
        size: 60,
        color: isOn ? Colors.green : Colors.black,
      ),
      onPressed: onToggle,
    );
  }
}
