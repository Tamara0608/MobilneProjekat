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
  final bool showAppointmentsTab;
  final bool showTopActions;

  const GuestHomeScreen({
    super.key,
    required this.isGuest,
    this.showAppointmentsTab = true,
    this.showTopActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasTabs = (!isGuest) && showAppointmentsTab;

    final titleText = isGuest
        ? 'Gost'
        : (hasTabs
            ? 'Zdravo, ${AppSession.firstName ?? 'korisniče'}'
            : 'Ponude');

    return DefaultTabController(
      length: hasTabs ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: isGuest,
          title: Text(titleText),
          bottom: hasTabs
              ? const TabBar(
                  tabs: [
                    Tab(text: 'Ponude'),
                    Tab(text: 'Moji termini'),
                  ],
                )
              : null,
          actions: [
            if (!isGuest && showTopActions) ...[
              IconButton(
                icon: const Icon(Icons.person_outline),
                tooltip: 'Moj profil',
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.editProfile);
                },
              ),
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
          ],
        ),
        body: isGuest
            ? const _PonudeTab(isGuest: true)
            : (hasTabs
                ? const TabBarView(
                    children: [
                      _PonudeTab(isGuest: false),
                      MyAppointmentsScreen(),
                    ],
                  )
                : const _PonudeTab(isGuest: false)),
      ),
    );
  }
}

class _PonudeTab extends StatelessWidget {
  final bool isGuest;

  const _PonudeTab({required this.isGuest});

  @override
  Widget build(BuildContext context) {
    final visibleServices = services.where((s) => !s.isDeleted).toList(); //admin moze vratiti iz smeca

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
            child: visibleServices.isEmpty
                ? const Center(
                    child: Text(
                      'Trenutno nema dostupnih ponuda.',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  )
                : GridView.builder(
                    itemCount: visibleServices.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final s = visibleServices[index];

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
