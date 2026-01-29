import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartbooking/core/router/app_router.dart';
import 'package:smartbooking/core/theme/app_theme.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const SmartBookingApp());
}

class SmartBookingApp extends StatelessWidget {
  const SmartBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRouter.welcome,
      routes: AppRouter.routes,
    );
  }
}
