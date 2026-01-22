import 'package:flutter/material.dart';
import '../services/services_data.dart';
import '../services/service.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  @override
  Widget build(BuildContext context) {
    final active = services.where((s) => !s.isDeleted).toList();

    return Scaffold(
      backgroundColor: AdminServicesScreen._bg,
      appBar: AppBar(
        backgroundColor: AdminServicesScreen._bg,
        elevation: 0,
        title: const Text('Ponude – izmena'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _openTrash,
            tooltip: 'Korpa',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addService,
        child: const Icon(Icons.add),
      ),
      body: active.isEmpty
          ? const Center(
              child: Text(
                'Nema ponuda.',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: active.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final s = active[index];
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
                    subtitle: Text('${_formatPrice(s.priceRsd)} • ${s.duration}'),
                    trailing: Wrap(
                      spacing: 6,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _editService(realIndex),
                          tooltip: 'Izmeni',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _softDelete(realIndex),
                          tooltip: 'Obriši',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _softDelete(int index) {
    setState(() {
      services[index].isDeleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ponuda je premeštena u korpu.')),
    );
  }

  void _openTrash() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminTrashScreen()),
    );
    if (!mounted) return;
    setState(() {});
  }

  String _formatPrice(int rsd) {
    final str = rsd.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromEnd = str.length - i;
      buf.write(str[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write('.');
    }
    return '${buf.toString()} RSD';
  }

  void _addService() async {
    final created = await _openServiceDialog(context, title: 'Dodaj ponudu');
    if (created == null) return;

    setState(() {
      services.add(created);
    });
  }

  void _editService(int index) async {
    final current = services[index];
    final updated = await _openServiceDialog(
      context,
      title: 'Izmeni ponudu',
      initial: current,
    );
    if (updated == null) return;

    setState(() {
      services[index] = updated;
    });
  }

  Future<Service?> _openServiceDialog(
    BuildContext context, {
    required String title,
    Service? initial,
  }) async {
    final formKey = GlobalKey<FormState>();

    final titleCtrl = TextEditingController(text: initial?.title ?? '');
    final descCtrl = TextEditingController(text: initial?.description ?? '');
    final priceCtrl = TextEditingController(
      text: initial != null ? initial.priceRsd.toString() : '',
    );
    final durationCtrl = TextEditingController(text: initial?.duration ?? '');
    final imageCtrl = TextEditingController(text: initial?.imagePath ?? '');

    return showDialog<Service>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Naziv'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obavezno' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Opis'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obavezno' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cena (RSD)'),
                    validator: (v) {
                      final t = (v ?? '').trim();
                      final p = int.tryParse(t);
                      if (p == null || p <= 0) return 'Unesi broj > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: durationCtrl,
                    decoration: const InputDecoration(labelText: 'Trajanje'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obavezno' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: imageCtrl,
                    decoration: const InputDecoration(labelText: 'Putanja slike'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obavezno' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Otkaži'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final result = Service(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  priceRsd: int.parse(priceCtrl.text.trim()),
                  duration: durationCtrl.text.trim(),
                  imagePath: imageCtrl.text.trim(),
                  isDeleted: initial?.isDeleted ?? false,
                );

                Navigator.pop(context, result);
              },
              child: const Text('Sačuvaj'),
            ),
          ],
        );
      },
    );
  }
}

class AdminTrashScreen extends StatefulWidget {
  const AdminTrashScreen({super.key});

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  State<AdminTrashScreen> createState() => _AdminTrashScreenState();
}

class _AdminTrashScreenState extends State<AdminTrashScreen> {
  @override
  Widget build(BuildContext context) {
    final trash = services.where((s) => s.isDeleted).toList();

    return Scaffold(
      backgroundColor: AdminTrashScreen._bg,
      appBar: AppBar(
        backgroundColor: AdminTrashScreen._bg,
        elevation: 0,
        title: const Text('Korpa'),
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
                final s = trash[index];
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
                          onPressed: () => _restore(realIndex),
                          child: const Text('Vrati'),
                        ),
                        TextButton(
                          onPressed: () => _deleteForever(realIndex),
                          child: const Text('Trajno'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _restore(int index) {
    setState(() {
      services[index].isDeleted = false;
    });
  }

  void _deleteForever(int index) {
    setState(() {
      services.removeAt(index);
    });
  }
}
