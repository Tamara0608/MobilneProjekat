import 'package:flutter/material.dart';
import '../services/services_data.dart';
import '../services/service.dart';
import '../core/router/app_router.dart';

class AdminTrashScreen extends StatefulWidget {
  const AdminTrashScreen({super.key});

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  State<AdminTrashScreen> createState() => _AdminTrashScreenState();
}

class _AdminTrashScreenState extends State<AdminTrashScreen> {
  void _goBackToAdminHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.adminHome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final trash = services.where((s) => s.isDeleted).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _goBackToAdminHome();
      },
      child: Scaffold(
        backgroundColor: AdminTrashScreen._bg,
        appBar: AppBar(
          backgroundColor: AdminTrashScreen._bg,
          elevation: 0,
          title: const Text('Korpa'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBackToAdminHome,
          ),
        ),
        body: trash.isEmpty
            ? const Center(
                child: Text(
                  'Korpa je prazna.',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: trash.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final Service s = trash[index];
                  final realIndex = services.indexOf(s);

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
                      subtitle: Text('${s.priceRsd} RSD • ${s.duration}'),
                      trailing: Wrap(
                        spacing: 6,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                services[realIndex].isDeleted = false;
                              });
                            },
                            child: const Text('Vrati'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                services.removeAt(realIndex);
                              });
                            },
                            child: const Text('Trajno'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
