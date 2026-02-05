import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String serviceTitle;

  const AdminServiceDetailsScreen({
    super.key,
    required this.serviceId,
    required this.serviceTitle,
  });

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  State<AdminServiceDetailsScreen> createState() =>
      _AdminServiceDetailsScreenState();
}

class _AdminServiceDetailsScreenState extends State<AdminServiceDetailsScreen> {
  DocumentReference get _serviceRef =>
      FirebaseFirestore.instance.collection('usluge').doc(widget.serviceId);

  CollectionReference get _podvrsteRef => _serviceRef.collection('podvrste');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminServiceDetailsScreen._bg,
      appBar: AppBar(
        backgroundColor: AdminServiceDetailsScreen._bg,
        elevation: 0,
        title: Text('Podvrste – ${widget.serviceTitle}'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditPodvrsta(),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj podvrstu'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Podvrste tretmana',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          _podvrsteList(),
        ],
      ),
    );
  }

  Widget _podvrsteList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _podvrsteRef.orderBy('order', descending: false).snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return Text('Greška: ${snap.error}');
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Nema podvrsta. Dodaj prvu podvrstu.'),
          );
        }

        return Column(
          children: docs.map((d) {
            final data = d.data() as Map<String, dynamic>;

            final title = (data['title'] ?? '').toString();
            final duration = (data['duration'] ?? '').toString();
            final text = (data['text'] ?? '').toString();
            final order = (data['order'] ?? 0);
            final price = (data['priceRsd'] ?? 0);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$duration • $price RSD • redosled: $order',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.65),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(text),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _addOrEditPodvrsta(
                          id: d.id,
                          initial: data,
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _podvrsteRef.doc(d.id).delete(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _addOrEditPodvrsta({
    String? id,
    Map<String, dynamic>? initial,
  }) async {
    final titleCtrl =
        TextEditingController(text: (initial?['title'] ?? '').toString());
    final durCtrl =
        TextEditingController(text: (initial?['duration'] ?? '').toString());
    final priceCtrl =
        TextEditingController(text: (initial?['priceRsd'] ?? 0).toString());
    final textCtrl =
        TextEditingController(text: (initial?['text'] ?? '').toString());
    final orderCtrl =
        TextEditingController(text: (initial?['order'] ?? 0).toString());

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? 'Dodaj podvrstu' : 'Izmeni podvrstu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Naziv'),
              ),
              TextField(
                controller: durCtrl,
                decoration: const InputDecoration(labelText: 'Trajanje'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Cena (RSD)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: orderCtrl,
                decoration: const InputDecoration(labelText: 'Redosled (broj)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: textCtrl,
                decoration: const InputDecoration(labelText: 'Opis'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Otkaži'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sačuvaj'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final payload = {
      'title': titleCtrl.text.trim(),
      'duration': durCtrl.text.trim(),
      'priceRsd': int.tryParse(priceCtrl.text.trim()) ?? 0,
      'text': textCtrl.text.trim(),
      'order': int.tryParse(orderCtrl.text.trim()) ?? 0,
    };

    if (id == null) {
      await _podvrsteRef.add(payload);
    } else {
      await _podvrsteRef.doc(id).update(payload);
    }
  }
}
