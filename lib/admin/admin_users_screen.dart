import 'package:flutter/material.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  static const Color _bg = Color(0xFFFFF1F4);

  final List<_UserRow> _users = [
    _UserRow(name: 'Tamara Đurković', email: 'tamara@gmail.com', role: 'user', active: true),
    _UserRow(name: 'Milica Jovanović', email: 'milica@gmail.com', role: 'user', active: true),
    _UserRow(name: 'Ana Petrović', email: 'ana@gmail.com', role: 'employee', active: true),
    _UserRow(name: 'Marko Ilić', email: 'marko@gmail.com', role: 'user', active: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Korisnički nalozi'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await _openUserDialog(context);
          if (created != null) {
            setState(() => _users.add(created));
          }
        },
        child: const Icon(Icons.add),
      ),
      body: _users.isEmpty
          ? const Center(
              child: Text(
                'Nema korisnika.',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final u = _users[index];

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
                          u.role == 'admin'
                              ? Icons.admin_panel_settings_rounded
                              : (u.role == 'employee' ? Icons.badge_outlined : Icons.person_outline),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              u.name,
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 2),
                            Text(u.email, style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              children: [
                                _chip(u.role == 'user'
                                    ? 'Korisnik'
                                    : (u.role == 'employee' ? 'Zaposleni' : 'Admin')),
                                _chip(u.active ? 'Aktivan' : 'Neaktivan'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Izmeni',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () async {
                          final updated = await _openUserDialog(context, initial: u);
                          if (updated != null) {
                            setState(() => _users[index] = updated);
                          }
                        },
                      ),
                      IconButton(
                        tooltip: 'Obriši',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() => _users.removeAt(index));
                        },
                      ),
                    ],
                  ),
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
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }

  Future<_UserRow?> _openUserDialog(BuildContext context, {_UserRow? initial}) async {
    final nameCtrl = TextEditingController(text: initial?.name ?? '');
    final emailCtrl = TextEditingController(text: initial?.email ?? '');
    String role = initial?.role ?? 'user';
    bool active = initial?.active ?? true;

    return showDialog<_UserRow>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(initial == null ? 'Dodaj korisnika' : 'Izmeni korisnika'),
          content: StatefulBuilder(
            builder: (context, setLocal) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Ime i prezime'),
                    ),
                    TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: role,
                      decoration: const InputDecoration(labelText: 'Uloga'),
                      items: const [
                        DropdownMenuItem(value: 'user', child: Text('Korisnik')),
                        DropdownMenuItem(value: 'employee', child: Text('Zaposleni')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (v) => setLocal(() => role = v ?? 'user'),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Aktivan nalog'),
                      value: active,
                      onChanged: (v) => setLocal(() => active = v),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Otkaži'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final email = emailCtrl.text.trim();
                if (name.isEmpty || email.isEmpty) return;

                Navigator.pop(
                  context,
                  _UserRow(
                    name: name,
                    email: email,
                    role: role,
                    active: active,
                  ),
                );
              },
              child: const Text('Sačuvaj'),
            ),
          ],
        );
      },
    );
  }
}

class _UserRow {
  final String name;
  final String email;
  final String role;
  final bool active;

  const _UserRow({
    required this.name,
    required this.email,
    required this.role,
    required this.active,
  });
}
