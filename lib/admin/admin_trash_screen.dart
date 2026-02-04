import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/router/app_router.dart';

class AdminTrashScreen extends StatefulWidget {
  const AdminTrashScreen({super.key});
  static const Color _bg = Color(0xFFFFF1F4);

  @override
  State<AdminTrashScreen> createState() => _AdminTrashScreenState();
}

class _AdminTrashScreenState extends State<AdminTrashScreen> {
  final CollectionReference _uslugeRef = FirebaseFirestore.instance.collection('usluge');

  void _goBackToAdminHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.adminHome, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goBackToAdminHome();
      },
      child: Scaffold(
        backgroundColor: AdminTrashScreen._bg,
        appBar: AppBar(
          backgroundColor: AdminTrashScreen._bg,
          elevation: 0,
          title: const Text('Korpa'),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBackToAdminHome),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _uslugeRef.where('isDeleted', isEqualTo: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text('Korpa je prazna.', style: TextStyle(fontWeight: FontWeight.w800)),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final docId = docs[index].id;

                return Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: ListTile(
                    title: Text(data['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text('${data['priceRsd']} RSD'),
                    trailing: Wrap(
                      children: [
                        TextButton(
                          onPressed: () => _uslugeRef.doc(docId).update({'isDeleted': false}),
                          child: const Text('Vrati'),
                        ),
                        TextButton(
                          onPressed: () => _uslugeRef.doc(docId).delete(),
                          child: const Text('Trajno', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}