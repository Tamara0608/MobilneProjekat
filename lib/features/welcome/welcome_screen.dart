import 'package:flutter/material.dart';
import '../../core/router/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Pozadina – cvetna slika
          Positioned.fill(
            child: Image.asset(
              'assets/images/cvece.webp',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 110,
                  ),

                  const SizedBox(height: 24),

                  /// Naslov
                  const Text(
                    'Dobrodošli u SmartBooking 🌸',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Opis
                  const Text(
                    'Rezervišite termine brzo i jednostavno.\n'
                    'Pregledajte usluge ili se ulogujte za pun pristup.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 36),

                  /// Dugme: Uloguj se
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.login,
                        );
                      },
                      child: const Text(
                        'Uloguj se',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// Dugme: Nastavi kao gost
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.guestHome,
                        );
                      },
                      child: const Text(
                        'Nastavi kao gost',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
