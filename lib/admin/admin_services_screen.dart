import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../services/service.dart';
import '../../admin/admin_trash_screen.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});
  static const Color _bg = Color(0xFFFFF1F4);

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  final CollectionReference _uslugeRef = FirebaseFirestore.instance.collection('usluge');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminServicesScreen._bg,
      appBar: AppBar(
        backgroundColor: AdminServicesScreen._bg,
        elevation: 0,
        title: const Text('Ponude – izmena'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const AdminTrashScreen())
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addService,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _uslugeRef.where('isDeleted', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Greška: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Nema aktivnih usluga. Dodajte novu.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final String imagePath = data['imagePath'] ?? '';

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(18)
                ),
                child: ListTile(
                leading:imagePath.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Builder(
                            builder: (context) {
                              // Provera da li je asset ili fajl sa telefona
                              if (imagePath.startsWith('assets/')) {
                                return Image.asset(
                                  imagePath,
                                  width: 50, height: 50, fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                                );
                              }
                              
                              final file = File(imagePath);
                              if (file.existsSync()) {
                                return Image.file(
                                  file,
                                  width: 50, height: 50, fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                                );
                              }
                              
                              return const Icon(Icons.image_not_supported, color: Colors.grey);
                            },
                          ),
                        )
                      : const Icon(Icons.image, color: Colors.grey),
                  title: Text(data['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text('${data['priceRsd']} RSD • ${data['duration'] ?? 'Nema trajanja'}'),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined), 
                        onPressed: () => _editService(docId, data)
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _uslugeRef.doc(docId).update({'isDeleted': true}),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _addService() async {
    final created = await _openServiceDialog(context, title: 'Dodaj ponudu');
    if (created == null) return;
    await _uslugeRef.add({
      'title': created.title,
      'description': created.description,
      'priceRsd': created.priceRsd,
      'duration': created.duration,
      'imagePath': created.imagePath,
      'isDeleted': false,
    });
  }

  void _editService(String id, Map<String, dynamic> data) async {
    final current = Service(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      priceRsd: data['priceRsd'] ?? 0,
      duration: data['duration'] ?? '',
      imagePath: data['imagePath'] ?? '',
    );
    final updated = await _openServiceDialog(context, title: 'Izmeni ponudu', initial: current);
    if (updated == null) return;
    await _uslugeRef.doc(id).update({
      'title': updated.title,
      'description': updated.description,
      'priceRsd': updated.priceRsd,
      'duration': updated.duration,
      'imagePath': updated.imagePath,
    });
  }

  Future<Service?> _openServiceDialog(BuildContext context, {required String title, Service? initial}) async {
    final titleCtrl = TextEditingController(text: initial?.title ?? '');
    final descCtrl = TextEditingController(text: initial?.description ?? '');
    final priceCtrl = TextEditingController(text: initial?.priceRsd.toString() ?? '');
    final durCtrl = TextEditingController(text: initial?.duration ?? '');
    String currentPath = initial?.imagePath ?? '';

    return showDialog<Service>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Naziv')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Opis')),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Cena (RSD)'), keyboardType: TextInputType.number),
              TextField(controller: durCtrl, decoration: const InputDecoration(labelText: 'Trajanje')),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    currentPath = image.path;
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('Izaberi sliku iz galerije'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Otkaži')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, Service(
              title: titleCtrl.text,
              description: descCtrl.text,
              priceRsd: int.tryParse(priceCtrl.text) ?? 0,
              duration: durCtrl.text,
              imagePath: currentPath,
            )),
            child: const Text('Sačuvaj'),
          ),
        ],
      ),
    );
  }
}