import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.black,
      thickness: 2,
      height: 5,
      indent: 10,
      endIndent: 10,
    );
  }
}
