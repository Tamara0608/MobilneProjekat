import 'package:flutter/material.dart';

import '../../features/welcome/welcome_screen.dart';
import '../../auth/login_screen.dart';
import '../../services/guest_home_screen.dart';

class AppRouter {
  static const welcome = '/';
  static const login = '/login';
  static const guestHome = '/guest';

  static final Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomeScreen(),
    login: (_) => const LoginScreen(),
    guestHome: (_) => const GuestHomeScreen(),
  };
}
