import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
