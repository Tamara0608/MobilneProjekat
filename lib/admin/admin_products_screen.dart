import 'package:flutter/material.dart';
import '../services/services_data.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminProductsScreen._bg,
      appBar: AppBar(
        backgroundColor: AdminProductsScreen._bg,
        elevation: 0,
        title: const Text('Brisanje ponuda'),
      ),
      body: services.isEmpty
          ? const Center(
              child: Text(
                'Nema ponuda.',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final s = services[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        s.imagePath,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      s.title,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(s.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmDelete(index),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(int index) async {
    final s = services[index];
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Brisanje'),
        content: Text('Obrisati ponudu: "${s.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ne'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Da'),
          ),
        ],
      ),
    );

    if (ok == true) {
      setState(() {
        services.removeAt(index);
      });
    }
  }
}
