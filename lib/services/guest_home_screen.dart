import 'package:flutter/material.dart';
import '../services/services_data.dart';
import '../widgets/service_card.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gost')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final s = services[index];
            return ServiceCard(
              service: s,
              onMore: () {
                
              },
            );
          },
        ),
      ),
    );
  }
}