import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'service.dart';
import '../auth/login_screen.dart';
import '../appointments/booking_screen.dart';
import '../core/session/app_session.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Service service;
  final bool isGuest;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
    required this.isGuest,
  });

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  Widget build(BuildContext context) {
    final isAdmin = AppSession.role == UserRole.admin;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(service.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Builder(
                    builder: (context) {
                      final p = service.imagePath;

                      if (p.startsWith('assets/')) {
                        return Image.asset(
                          p,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imageFallback(),
                        );
                      }

                      final file = File(p);
                      if (file.existsSync()) {
                        return Image.file(
                          file,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imageFallback(),
                        );
                      }

                      return _imageFallback();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                service.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                service.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _AvailabilityCard(),
            ),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Podvrste tretmana',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usluge')
                  .doc(service.id)
                  .collection('podvrste')
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Greška: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nema podvrsta za ovu uslugu.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;

                    final title = (data['title'] ?? '').toString();
                    final duration = (data['duration'] ?? '').toString();
                    final text = (data['text'] ?? '').toString();
                    final priceRsd = (data['priceRsd'] ?? 0);

                    return _SubServiceCard(
                      title: title,
                      duration: duration,
                      text: text,
                      priceRsd: priceRsd,
                      isAdmin: isAdmin,
                      onTap: () {
                        if (isAdmin) return;

                        if (isGuest) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(
                                infoMessage:
                                    'Za zakazivanje termina potrebno je da se prijaviš ili registruješ.',
                              ),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(
                              serviceTitle: service.title,
                              subServiceTitle: title,
                              duration: duration,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const DetailsFooter(),
          ],
        ),
      ),
    );
  }

  static Widget _imageFallback() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported, size: 50),
    );
  }
}

class _SubServiceCard extends StatelessWidget {
  final String title;
  final String duration;
  final String text;
  final int priceRsd;
  final VoidCallback onTap;
  final bool isAdmin;

  const _SubServiceCard({
    required this.title,
    required this.duration,
    required this.text,
    required this.priceRsd,
    required this.onTap,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (priceRsd > 0)
              Text(
                '$priceRsd RSD',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ),
            if (priceRsd > 0) const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.35),
            ),
            const SizedBox(height: 12),
            if (!isAdmin)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Izaberi',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withValues(alpha: 0.65),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: const Row(
        children: [
          Icon(Icons.schedule),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dostupnost: tretmani se obavljaju isključivo uz prethodno zakazivanje.',
              style: TextStyle(fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsFooter extends StatelessWidget {
  const DetailsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FooterAbout(),
          SizedBox(height: 18),
          _FooterWorkTime(),
          SizedBox(height: 18),
          _FooterContact(),
        ],
      ),
    );
  }
}

class _FooterAbout extends StatelessWidget {
  const _FooterAbout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'O nama',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 8),
        Text(
          'SmartBooking je moderna aplikacija za pregled i zakazivanje usluga.',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

class _FooterWorkTime extends StatelessWidget {
  const _FooterWorkTime();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Radno vreme',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 8),
        Text(
          'Rad isključivo uz zakazivanje',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

class _FooterContact extends StatelessWidget {
  const _FooterContact();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kontakt',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 8),
        Text(
          'Bulevar Kralja Petra I 45\n21000 Novi Sad',
          style: TextStyle(color: Colors.white70),
        ),
        Text('+381 64 987 65 43', style: TextStyle(color: Colors.white)),
        Text('info@smartbooking.rs', style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
