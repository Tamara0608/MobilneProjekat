import 'package:flutter/material.dart';
import '../services/guest_home_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_trash_screen.dart';

class AdminShellScreen extends StatefulWidget {
  const AdminShellScreen({super.key});

  @override
  State<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends State<AdminShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const GuestHomeScreen(
        isGuest: false,
        showAppointmentsTab: false, // adminu ne treba "Moji termini"
        showTopActions: false,      // da ne bude duplo logout/profil
      ),
      const AdminTrashScreen(),
      const AdminProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F4),
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Ponude',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Korpa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
