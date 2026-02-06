import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/session/app_session.dart';
import '../widgets/empty_state.dart';
import 'booking_screen.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  static const Color _bg = Color(0xFFFFEEF3);

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  CollectionReference<Map<String, dynamic>> get _ref =>
      FirebaseFirestore.instance.collection('appointments');

  @override
  Widget build(BuildContext context) {
    final uid = AppSession.uid;

    if (uid == null || uid.isEmpty) {
      return const Scaffold(
        backgroundColor: MyAppointmentsScreen._bg,
        body: Center(child: Text('Niste prijavljeni.')),
      );
    }

    return Scaffold(
      backgroundColor: MyAppointmentsScreen._bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyAppointmentsScreen._bg,
        elevation: 0,
        title: const Text('Moji termini'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _ref
            .where('userId', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Greška: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const EmptyState(message: 'Nema zakazanih termina.');
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();

              final serviceTitle = (data['serviceTitle'] ?? '').toString();
              final subServiceTitle = (data['subServiceTitle'] ?? '').toString();
              final duration = (data['duration'] ?? '').toString();
              final date = (data['date'] ?? '').toString();
              final time = (data['time'] ?? '').toString();
              final status = (data['status'] ?? 'Zakazano').toString();

              final isCanceled =
                  data['isCanceled'] == true || status.toLowerCase() == 'otkazano';

              return Opacity(
                opacity: isCanceled ? 0.55 : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isCanceled ? Colors.grey.shade200 : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isCanceled
                          ? Colors.grey.withValues(alpha: 0.35)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$serviceTitle • $subServiceTitle',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: isCanceled ? Colors.grey.shade700 : Colors.black,
                          decoration:
                              isCanceled ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Trajanje: $duration',
                        style: TextStyle(
                          color: isCanceled ? Colors.grey.shade700 : Colors.black,
                        ),
                      ),
                      Text(
                        'Datum: $date  •  Vreme: $time',
                        style: TextStyle(
                          color: isCanceled ? Colors.grey.shade700 : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isCanceled ? Colors.grey.shade700 : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isCanceled
                                  ? null
                                  : () async {
                                      final ok = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title:
                                              const Text('Otkazivanje termina'),
                                          content: const Text(
                                            'Da li ste sigurni da želite da otkažete termin?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Ne'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Da'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (ok == true) {
                                        await _ref.doc(d.id).update({
                                          'status': 'Otkazano',
                                          'isCanceled': true,
                                          'canceledAt':
                                              FieldValue.serverTimestamp(),
                                          'updatedAt':
                                              FieldValue.serverTimestamp(),
                                        });
                                      }
                                    },
                              child: const Text('Otkaži'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isCanceled
                                  ? null
                                  : () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookingScreen(
                                            serviceTitle: serviceTitle,
                                            subServiceTitle: subServiceTitle,
                                            duration: duration,
                                            appointmentId: d.id,
                                            initialDateStr: date,
                                            initialTime: time,
                                          ),
                                        ),
                                      );
                                    },
                              child: const Text('Izmeni'),
                            ),
                          ),
                        ],
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
}
