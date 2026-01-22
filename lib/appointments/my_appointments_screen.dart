import 'package:flutter/material.dart';
import '../core/session/app_session.dart';
import 'booking_screen.dart';
import '../widgets/empty_state.dart';


class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  static const Color _bg = Color(0xFFFFEEF3);

  @override
  Widget build(BuildContext context) {
    final items = AppSession.appointments;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Moji termini'),
      ),
        body: items.isEmpty
          ? const EmptyState(message: 'Nema zakazanih termina.')
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final a = items[i];

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${a.serviceTitle} • ${a.subServiceTitle}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text('Trajanje: ${a.duration}'),
                      Text('Datum: ${a.date}  •  Vreme: ${a.time}'),
                      const SizedBox(height: 8),
                      Text('Status: ${a.status}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Otkazivanje termina'),
                                    content: const Text(
                                      'Da li ste sigurni da želite da otkažete termin?',
                                    ),
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
                                    AppSession.appointments.removeAt(i);
                                  });
                                }
                              },
                              child: const Text('Otkaži'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookingScreen(
                                      serviceTitle: a.serviceTitle,
                                      subServiceTitle: a.subServiceTitle,
                                      duration: a.duration,
                                      editIndex: i,
                                      initialTime: a.time,
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                              child: const Text('Izmeni'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
