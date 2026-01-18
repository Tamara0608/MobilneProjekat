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
            Padding(
              padding:const EdgeInsets.fromLTRB(16, 8, 16, 18),
             child: _InfoPanel(review: _reviewFor(service)),
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
    if (s.title == 'Tretman lica') {
  return const [
    _SubService(
      title: 'Higijenski tretman lica',
      duration: '60–90 min',
      text: 'Dubinsko čišćenje, uklanjanje nečistoća i umirenje kože.',
    ),
    _SubService(
      title: 'Dermaplaning',
      duration: '45–60 min',
      text: 'Eksfolijacija i uklanjanje mrtvih ćelija za glatku i sjajnu kožu.',
    ),
    _SubService(
      title: 'Karbonski piling',
      duration: '45–60 min',
      text: 'Tretman za pore i teksturu kože uz svež i čist izgled.',
    ),
  ];
}
if (s.title == 'Trepavice') {
  return const [
    _SubService(
      title: 'Klasik',
      duration: '90–120 min',
      text: 'Prirodan izgled – jedna ekstenzija na jednu trepavicu.',
    ),
    _SubService(
      title: 'Volume 2D–3D',
      duration: '120–150 min',
      text: 'Puniji izgled uz lagane lepeze za mek rezultat.',
    ),
    _SubService(
      title: 'Lash Lift',
      duration: '45–60 min',
      text: 'Podizanje i uvijanje prirodnih trepavica uz dugotrajan efekat.',
    ),
  ];
}
if (s.title.toLowerCase().contains('masa')) {
  return const [
    _SubService(
      title: 'Terapeutska masaža',
      duration: '30 min',
      text:
          'Ciljano tretiranje problematičnih regija u skladu sa individualnim potrebama klijenta.',
    ),
    _SubService(
      title: 'Masaža dubokog tkiva',
      duration: '30 min',
      text:
          'Dubinska tehnika koja pomaže u otklanjanju jakih mišićnih napetosti i hroničnih bolova.',
    ),
    _SubService(
      title: 'Relax antistres masaža',
      duration: '30 ili 60 min',
      text:
          'Blaga relaksaciona masaža namenjena opuštanju i smanjenju svakodnevnog stresa.',
    ),
  ];
}
if (s.title == 'Nokti' || s.title.toLowerCase().contains('nok')) {
  return const [
    _SubService(
      title: 'Manikir',
      duration: '30 minuta',
      text:
          'Lepi, jaki i zdravi prirodni nokti su osnova savršenog manikira. '
          'Prirodna lepota ruku i noktiju zavisi od zdravlja, godina i spoljašnjih uticaja, '
          'a najviše od redovne nege. Anti-Age Hand & Nail Care tretman štiti kožu i nokte '
          'i usporava proces starenja.',
    ),
    _SubService(
      title: 'LongWear',
      duration: '30 minuta',
      text:
          'LongWear je standard lepote. Dugotrajan lak sa revolucionarnom 1-2-3 tehnologijom '
          'koja obezbeđuje postojanu boju i sjaj. Idealno za uredne nokte savršenog kvaliteta.',
    ),
    _SubService(
      title: 'Gel lak',
      duration: '60 minuta',
      text:
          'Gel lak tehnika pruža besprekoran izgled, jake i uredne nokte sa prirodnim efektom. '
          'Rad sa savremenim gelovima visokih performansi omogućava dugotrajan i elegantan rezultat.',
    ),
    _SubService(
      title: 'Hard Ultra Thin',
      duration: '60 minuta',
      text:
          'Savršeno rešenje za poznavaoce finih tehnika. Omogućava ojačavanje prirodnih noktiju '
          'koji će postati jaki i otporni. Elegantan i prefinjen izgled.',
    ),
  ];
}
    return const [];
  }
_Review _reviewFor(Service s) {
  switch (s.title) {
    case 'Obrve':
      return const _Review(
        headline: 'Naši klijenti',
        text: 'Obrve su ispale savršeno prirodno. Precizno i uredno.',
        author: '— Milica',
      );

    case 'Tretman lica':
      return const _Review(
        headline: 'Utisci',
        text: 'Koža je posle tretmana čistija i sjajnija. Veoma prijatan tretman!',
        author: '— Ivana',
      );

    case 'Trepavice':
      return const _Review(
        headline: 'Utisci',
        text: 'Trepavice su lagane, uredne i izgledaju prelepo. Efekat je top!',
        author: '— Ana',
      );

    case 'Masaža':
      return const _Review(
        headline: 'Utisci',
        text: 'Opuštajuće i profesionalno. Odmah sam se osećala lakše i mirnije.',
        author: '— Marija',
      );

    case 'Nokti':
      return const _Review(
        headline: 'Utisci',
        text: 'Manikir je detaljan i uredan, a rezultat traje dugo. Prezadovoljna!',
        author: '— Jelena',
      );

    default:
      return const _Review(
        headline: 'Utisci',
        text: 'Profesionalno i veoma kvalitetno iskustvo.',
        author: '— Katarina',
      );
  }
}

}
class _Review {
  final String headline;
  final String text;
  final String author;

  const _Review({
    required this.headline,
    required this.text,
    required this.author,
  });
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
   final _Review review;

    const _InfoPanel({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Utisci', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text(
            review.headline,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10),
          Text(
            review.text,
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 14),
          Text(
          review.author,
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
