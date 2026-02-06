import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/session/app_session.dart';

class BookingScreen extends StatefulWidget {
  final String serviceTitle;
  final String subServiceTitle;
  final String duration;
  final String? appointmentId;
  final String? initialDateStr;
  final String? initialTime;

  const BookingScreen({
    super.key,
    required this.serviceTitle,
    required this.subServiceTitle,
    required this.duration,
    this.appointmentId,
    this.initialDateStr,
    this.initialTime,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const Color _bg = Color(0xFFFFEEF3);

  CollectionReference<Map<String, dynamic>> get _ref =>
      FirebaseFirestore.instance.collection('appointments');

  late DateTime _date;
  late String _time;

  bool _saving = false;
  bool _loadingBusy = false;

  final List<String> _slots = const [
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '16:00',
    '17:00',
    '18:00',
  ];

  Set<String> _busyTimesForDate = {};

  @override
  void initState() {
    super.initState();

    _date = _parseDate(widget.initialDateStr) ?? DateTime.now();
    _time = widget.initialTime ?? _slots.first;

    _loadBusySlotsForSelectedDate();
  }

  DateTime? _parseDate(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final raw = s.trim().replaceAll(' ', '');
    final parts = raw.split('.');
    if (parts.length < 3) return null;

    final dd = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    final yyyy = int.tryParse(parts[2]);

    if (dd == null || mm == null || yyyy == null) return null;
    return DateTime(yyyy, mm, dd);
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}.';
  }

  String _serviceKey() {
    return '${widget.serviceTitle}__${widget.subServiceTitle}'
        .toLowerCase()
        .trim();
  }

  Future<void> _loadBusySlotsForSelectedDate() async {
    setState(() {
      _loadingBusy = true;
      _busyTimesForDate = {};
    });

    try {
      final dateStr = _formatDate(_date);
      final key = _serviceKey();

      final qs = await _ref
          .where('date', isEqualTo: dateStr)
          .where('serviceKey', isEqualTo: key)
          .where('isCanceled', isEqualTo: false)
          .get();

      if (!mounted) return;

      final busy = <String>{};

      for (final doc in qs.docs) {
        final sameDoc =
            widget.appointmentId != null && doc.id == widget.appointmentId;

        if (!sameDoc) {
          final t = (doc.data()['time'] ?? '').toString();
          if (t.isNotEmpty) busy.add(t);
        }
      }

      setState(() => _busyTimesForDate = busy);
    } finally {
  if (mounted) {
    setState(() => _loadingBusy = false);
  }
}
 }
  Future<void> _save() async {
    final uid = AppSession.uid;
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Niste prijavljeni.')),
      );
      return;
    }

    final dateStr = _formatDate(_date);
    final isBusy = _busyTimesForDate.contains(_time);

    if (isBusy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izabrani termin je zauzet.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final key = _serviceKey();

      final data = <String, dynamic>{
        'userId': uid,
        'serviceTitle': widget.serviceTitle,
        'subServiceTitle': widget.subServiceTitle,
        'serviceKey': key,
        'duration': widget.duration,
        'date': dateStr,
        'time': _time,
        'status': 'Zakazano',
        'isCanceled': false,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.appointmentId == null) {
        data['createdAt'] = FieldValue.serverTimestamp();
        await _ref.add(data);
      } else {
        await _ref.doc(widget.appointmentId).update(data);
      }

      if (mounted) Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firestore greška: ${e.message ?? e.code}')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(_date);
    final isEditing = widget.appointmentId != null;
    final isBusySelected = _busyTimesForDate.contains(_time);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(isEditing ? 'Izmena termina' : 'Zakazivanje'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.serviceTitle} • ${widget.subServiceTitle}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text('Trajanje: ${widget.duration}'),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2025, 1, 1),
                    lastDate: DateTime(2027, 12, 31),
                  );
                  if (picked != null) {
                    setState(() => _date = picked);
                    await _loadBusySlotsForSelectedDate();
                    if (!mounted) return;
                    if (_busyTimesForDate.contains(_time)) {
                      setState(() => _time = _slots.first);
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Datum',
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    controller: TextEditingController(text: dateStr),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Dostupni termini',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 10),
                  if (_loadingBusy)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _slots.map((slot) {
                  final busy = _busyTimesForDate.contains(slot);
                  final selected = _time == slot;

                  return ChoiceChip(
                    label: Text(slot),
                    selected: selected,
                    onSelected: busy ? null : (_) => setState(() => _time = slot),
                    selectedColor: const Color(0xFFFFD6E0),
                    disabledColor: Colors.grey.shade300,
                  );
                }).toList(),
              ),
              const Spacer(),
              if (isBusySelected)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Izabrani termin je zauzet. Izaberite drugi.',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: (_saving || _loadingBusy || isBusySelected)
                      ? null
                      : _save,
                  child: Text(_saving
                      ? 'Čuvanje...'
                      : (isEditing ? 'Sačuvaj izmene' : 'Potvrdi zakazivanje')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
