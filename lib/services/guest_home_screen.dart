import 'package:flutter/material.dart';
import '../services/services_data.dart';
import '../widgets/service_card.dart';
import '../services/service_details_screen.dart';
import '../appointments/my_appointments_screen.dart';
import '../core/session/app_session.dart';
import '../core/router/app_router.dart';
import '../widgets/section_title.dart';

class GuestHomeScreen extends StatelessWidget {
  final bool isGuest;

  const GuestHomeScreen({
    super.key,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: isGuest ? 1 : 2,
      child: Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: isGuest,
          title: Text(isGuest ? 'Gost' :'Zdravo, ${AppSession.firstName ?? 'korisniče'}',),
          bottom: isGuest
              ? null
              : const TabBar(
                  tabs: [
                    Tab(text: 'Ponude'),
                    Tab(text: 'Moji termini'),
                  ],
                ),
          actions: [
            if (!isGuest)
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Odjavi se',
                onPressed: () {
                  AppSession.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.welcome,
                    (_) => false,
                  );
                },
              ),
          ],
        ),
        body: isGuest
            ? _PonudeTab(isGuest: isGuest)
            : const TabBarView(
                children: [
                  _PonudeTab(isGuest: false),
                  MyAppointmentsScreen(),
                ],
              ),
      ),
    );
  }
}
class _PonudeTab extends StatelessWidget {
  final bool isGuest;

  const _PonudeTab({required this.isGuest});

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isGuest) ...[
          const SectionTitle(text: 'Ponude'),
          const SizedBox(height: 8),
        ],

        Expanded(
          child: GridView.builder(
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final s = services[index];
              return ServiceCard(
                service: s,
                onMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceDetailsScreen(
                        service: s,
                        isGuest: isGuest,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
}