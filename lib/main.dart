import 'package:flutter/material.dart';
import 'package:smartbooking/core/router/app_router.dart';
import 'package:smartbooking/core/theme/app_theme.dart';

void main() {
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
