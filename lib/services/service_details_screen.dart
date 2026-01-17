// service_details_screen.dart
import 'package:flutter/material.dart';
import 'service.dart';
import '../auth/login_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Service service;
  final bool isGuest; // da li je korisnik gost

  const ServiceDetailsScreen({
    super.key,
    required this.service,
    required this.isGuest,
  });

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  Widget build(BuildContext context) {
    final items = _subServicesFor(service);

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
            // hero slika
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.asset(
                    service.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // naslov + opis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${service.title} tretmani',
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

            // dostupnost
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _AvailabilityCard(),
            ),

            const SizedBox(height: 22),

            // PODVRSTE 
            if (items.isNotEmpty) ...[
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

              ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final it = items[i];

                  return _SubServiceCard(
                    title: it.title,
                    duration: it.duration,
                    text: it.text,
                    onTap: () {
                      // ako je gost da ga vodi na ekran da se mora prijaviti za zakazivanje
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

                    
                    },
                  );
                },
              ),
            ],

            // utisci
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: _InfoPanel(),
            ),

            // footer
            const DetailsFooter(),
          ],
        ),
      ),
    );
  }

  // PODVRSTE 
  List<_SubService> _subServicesFor(Service s) {
    if (s.title.toLowerCase().contains('obrve')) {
      return const [
        _SubService(
          title: 'Bold Brows',
          duration: '60–90 min',
          text:
              'Najprirodnija tehnika iscrtavanja obrva sa mekim prelazima i preciznom formom.',
        ),
        _SubService(
          title: 'HairStroke',
          duration: '90–120 min',
          text:
              'Tehnika koja imitira dlačice i daje realističan i prirodan rezultat.',
        ),
        _SubService(
          title: 'Puder obrve',
          duration: '90–120 min',
          text: 'Senčenje koje daje puderast efekat bez oštrih ivica.',
        ),
        _SubService(
          title: 'Začešljavanje obrva',
          duration: '30–45 min',
          text:
              'Polutrajno oblikovanje koje daje uredan i postojan izgled obrva.',
        ),
      ];
    }

    return const [];
  }
}

class _SubService {
  final String title;
  final String duration;
  final String text;

  const _SubService({
    required this.title,
    required this.duration,
    required this.text,
  });
}

class _SubServiceCard extends StatelessWidget {
  final String title;
  final String duration;
  final String text;
  final VoidCallback onTap;

  const _SubServiceCard({
    required this.title,
    required this.duration,
    required this.text,
    required this.onTap,
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
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.35),
            ),
            const SizedBox(height: 12),
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

class _InfoPanel extends StatelessWidget {
  const _InfoPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Utisci', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text(
            'Naši klijenti',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Sve preporuke! Tretman je bio profesionalan i veoma prijatan.',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 14),
          Text(
            '— Olivera',
            style: TextStyle(color: Colors.white),
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
        Text('O nama',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
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
        Text('Radno vreme',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        SizedBox(height: 8),
        Text('Rad isključivo uz zakazivanje',
            style: TextStyle(color: Colors.white70)),
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
        Text('Kontakt',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        SizedBox(height: 8),
        Text('Bulevar Kralja Petra I 45\n21000 Novi Sad',
            style: TextStyle(color: Colors.white70)),
        Text('+381 64 987 65 43', style: TextStyle(color: Colors.white)),
        Text('info@smartbooking.rs', style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
