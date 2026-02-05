import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  static const Color _bg = Color(0xFFFFF1F4); 

  // Funkcija za brisanje iz baze 
  Future<void> _deleteUser(String docId) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).delete();
  }

  // Funkcija za čuvanje izmena 
  Future<void> _updateUser(String docId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).update(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Korisnički nalozi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Greška pri učitavanju.'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final u = doc.data() as Map<String, dynamic>;
              final String docId = doc.id;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: _bg,
                      child: Icon(
                        u['role'] == 'admin'
                          ? Icons.admin_panel_settings_rounded
                          : Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            u['firstName'] ?? 'Bez imena',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          Text(u['email'] ?? '', style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: [
                            _chip(u['role'] == 'admin' ? 'Admin' : 'Korisnik'),
                            _chip((u['status']?.toString().toLowerCase() == 'neaktivan') ? 'Neaktivan' : 'Aktivan')
                          ],
                        ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _openEditDialog(docId, u),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteUser(docId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }

  void _openEditDialog(String docId, Map<String, dynamic> currentData) {
  String selectedRole = currentData['role'] ?? 'user';
  String selectedStatus = (currentData['status']?.toString().toLowerCase() == 'neaktivan') 
      ? 'Neaktivan' 
      : 'Aktivan';

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Izmeni ulogu i status'),
      content: StatefulBuilder(
        builder: (context, setLocal) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedRole, 
              decoration: const InputDecoration(labelText: 'Uloga'),
              items: const [
                DropdownMenuItem(value: 'user', child: Text('Korisnik')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (v) {
                if (v != null) setLocal(() => selectedRole = v);
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedStatus, 
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'Aktivan', child: Text('Aktivan')),
                DropdownMenuItem(value: 'Neaktivan', child: Text('Neaktivan')),
              ],
              onChanged: (v) {
                if (v != null) setLocal(() => selectedStatus = v);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Otkaži'),
        ),
        ElevatedButton(
          onPressed: () {
            _updateUser(docId, {
              'role': selectedRole,
              'status':  selectedStatus.toLowerCase(),
            });
            Navigator.pop(context);
          },
          child: const Text('Sačuvaj'),
        ),
      ],
    ),
  ); 
  }
}