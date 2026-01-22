import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/session/app_session.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  Widget build(BuildContext context) {
    final name = AppSession.firstName ?? 'Admin';
    final email = AppSession.email ?? 'admin@smartbooking.rs';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _header(name: name, email: email),
          const SizedBox(height: 16),

          _tile(
            context,
            title: 'Ponude – dodavanje / izmena',
            subtitle: 'Upravljaj nazivom, opisom, cenom i trajanjem',
            icon: Icons.design_services_outlined,
            route: AppRouter.adminServices,
          ),

          _tile(
            context,
            title: 'Korpa',
            subtitle: 'Vrati obrisane ponude ili obriši trajno',
            icon: Icons.delete_outline,
            route: AppRouter.adminTrash,
          ),

          _tile(
            context,
            title: 'Upravljanje korisnicima',
            subtitle: 'Pregled i promena uloga (demo podaci)',
            icon: Icons.people_alt_outlined,
            route: AppRouter.adminUsers,
          ),

          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                AppSession.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.welcome,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Odjavi se'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header({required String name, required String email}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            child: Icon(Icons.admin_panel_settings_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Admin pristup',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
