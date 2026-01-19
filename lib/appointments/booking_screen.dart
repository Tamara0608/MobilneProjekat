import 'package:flutter/material.dart';
import '../core/session/app_session.dart';

class BookingScreen extends StatefulWidget {
  final String serviceTitle;
  final String subServiceTitle;
  final String duration;

  final int? editIndex;
  final DateTime? initialDate;
  final String? initialTime;

  const BookingScreen({
    super.key,
    required this.serviceTitle,
    required this.subServiceTitle,
    required this.duration,
    this.editIndex,
    this.initialDate,
    this.initialTime,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const Color _bg = Color(0xFFFFEEF3);

  late DateTime _date;
  late String _time;

  final List<String> _slots = const [
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '16:00',
    '17:00',
    '18:00',
  ];

  final Map<String, Set<String>> _busySlots = const {
    '20.01.2026.': {'11:00', '13:00'},
    '21.01.2026.': {'10:00', '18:00'},
    '22.01.2026.': {'12:00'},
  };

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate ?? DateTime(2026, 1, 20);
    _time = widget.initialTime ?? '10:00';
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}.';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(_date);
    final isBusy = _busySlots[dateStr]?.contains(_time) ?? false;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(widget.editIndex == null ? 'Zakazivanje' : 'Izmena termina'),
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
                    firstDate: DateTime(2026, 1, 1),
                    lastDate: DateTime(2026, 12, 31),
                  );
                  if (picked != null) {
                    setState(() => _date = picked);
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
              const Text(
                'Dostupni termini',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _slots.map((slot) {
                  final busy = _busySlots[dateStr]?.contains(slot) ?? false;
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
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isBusy
                      ? null
                      : () {
                          final a = Appointment(
                            serviceTitle: widget.serviceTitle,
                            subServiceTitle: widget.subServiceTitle,
                            duration: widget.duration,
                            date: dateStr,
                            time: _time,
                            status: 'Zakazano',
                          );

                          if (widget.editIndex != null) {
                            AppSession.appointments[widget.editIndex!] = a;
                          } else {
                            AppSession.appointments.add(a);
                          }

                          Navigator.pop(context);
                        },
                  child: Text(widget.editIndex == null
                      ? 'Potvrdi zakazivanje'
                      : 'Sačuvaj izmene'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
