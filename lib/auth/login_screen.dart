// login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final String? infoMessage;

  const LoginScreen({
    super.key,
    this.infoMessage,
  });

  static const Color _bg = Color(0xFFFFF1F4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Prijava / Registracija'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ✅ poruka se prikazuje SAMO kad postoji (dakle kad si gost i klikneš Izaberi)
            if (infoMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: Text(
                  infoMessage!,
                  style: const TextStyle(fontSize: 14, height: 1.35),
                ),
              ),

            if (infoMessage != null) const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: const Text('Prijavi se'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () {
                  
                },
                child: const Text('Registruj se'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
