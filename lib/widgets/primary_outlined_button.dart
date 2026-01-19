import 'package:flutter/material.dart';

class PrimaryOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
