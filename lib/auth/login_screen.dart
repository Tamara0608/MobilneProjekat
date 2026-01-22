import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/session/app_session.dart';
import '../services/guest_home_screen.dart'; 


class LoginScreen extends StatefulWidget {
  final String? infoMessage;

  const LoginScreen({
    super.key,
    this.infoMessage,
  });

  static const Color _bg = Color(0xFFFFEEF3);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
// da li je lozinka skrivena
  bool _obscure = true;
//cisti memoriju
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    // validacija za mejl
    final pattern = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w]{2,}$');
    return pattern.hasMatch(email);
  }

  bool _isStrongPassword(String pass) {
    // ograničenja za lozinku
    final hasUpper = RegExp(r'[A-Z]').hasMatch(pass);
    final hasLower = RegExp(r'[a-z]').hasMatch(pass);
    final hasDigit = RegExp(r'\d').hasMatch(pass);
    final hasSpecial =
        RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]~`+=;]').hasMatch(pass);
    return pass.length >= 8 && hasUpper && hasLower && hasDigit && hasSpecial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoginScreen._bg,
      appBar: AppBar(
        backgroundColor: LoginScreen._bg,
        elevation: 0,
        title: const Text('Prijava'),
      ), 
      //omogucava skrol
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 50),

            // poruka kad gost pokuša da zakaže
            if (widget.infoMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: Text(
                  widget.infoMessage!,
                  style: const TextStyle(fontSize: 14, height: 1.35),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // kartica sa login formom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back 🌸',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // email
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email'),
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Email je obavezan';
                        if (!_isValidEmail(v)) {
                          return 'Email mora biti u formatu naziv@domen.com';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    //loz
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: _inputDecoration(
                        'Lozinka',
                        suffix: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        if (v.isEmpty) return 'Lozinka je obavezna';

                        if (!_isStrongPassword(v)) {
                          return 'Lozinka mora imati najmanje 8 karaktera i sadržati: veliko slovo, malo slovo, broj i specijalan karakter.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                           
                           final email = _emailCtrl.text.trim();
                            UserRole role = UserRole.user;
                            if (email.toLowerCase() == 'admin@smartbooking.rs') role = UserRole.admin;
                            if (email.toLowerCase() == 'zaposleni@smartbooking.rs') role = UserRole.employee;
                             
                          AppSession.login(
                            role,
                            userEmail: email,
                            name: 'Tamara',
                          );

                          if (role == UserRole.admin) {
                            Navigator.pushReplacementNamed(context, AppRouter.adminHome);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GuestHomeScreen(isGuest: false),
                              ),
                            );
                          }

                          }        
                       },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Prijavi se',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    //link za reg
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Nemaš nalog? '),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRouter.register),
                          child: const Text(
                            'Registruj se',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
  return InputDecoration(
    hintText: hint,
    suffixIcon: suffix,
    filled: true,
    fillColor: const Color(0xFFFFF8FA),

  
    errorMaxLines: 3,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.black.withValues(alpha: 0.08),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.black.withValues(alpha: 0.08),
      ),
    ),
  );
}
}
