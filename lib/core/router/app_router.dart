import 'package:flutter/material.dart';
import '../../profile/edit_profile_screen.dart';
import '../../features/welcome/welcome_screen.dart';
import '../../auth/login_screen.dart';
import '../../auth/register_screen.dart';
import '../../services/guest_home_screen.dart';

import '../../admin/admin_shell_screen.dart';
import '../../admin/admin_services_screen.dart';
import '../../admin/admin_users_screen.dart';
import '../../admin/admin_trash_screen.dart';

class AppRouter {
  static const welcome = '/';
  static const login = '/login';
  static const register = '/register';
  static const guestHome = '/guest';
  static const editProfile = '/edit-profile';
  static const adminHome = '/admin';
  static const adminServices = '/admin/services';
  static const adminProducts = '/admin/products';
  static const adminUsers = '/admin/users';
  static const String adminTrash = '/admin/trash';

  static final Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomeScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    guestHome: (_) => const GuestHomeScreen(isGuest: true),
    editProfile: (context) => const EditProfileScreen(),
    adminHome: (_) => const AdminShellScreen(),
    adminServices: (_) => const AdminServicesScreen(),
    adminUsers: (_) => const AdminUsersScreen(),
    AppRouter.adminTrash: (_) => const AdminTrashScreen(),


  };
}
