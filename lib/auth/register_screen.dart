import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/session/app_session.dart';
import '../services/guest_home_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const Color _bg = Color(0xFFFFEEF3);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  bool _obscure = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final pattern = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w]{2,}$');
    return pattern.hasMatch(email);
  }

  bool _isStrongPassword(String pass) {
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
      backgroundColor: RegisterScreen._bg,
      appBar: AppBar(
        backgroundColor: RegisterScreen._bg,
        elevation: 0,
        title: const Text('Registracija'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kreiraj nalog 🌸',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ime
                    TextFormField(
                      controller: _firstNameCtrl,
                      decoration: _inputDecoration('Ime'),
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Ime je obavezno';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Prezime
                    TextFormField(
                      controller: _lastNameCtrl,
                      decoration: _inputDecoration('Prezime'),
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Prezime je obavezno';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Email
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

                    // Lozinka
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
                          return 'Lozinka mora imati najmanje 8 karaktera i sadržati: '
                              'veliko slovo, malo slovo, broj i specijalan karakter.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Potvrda lozinke
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscure2,
                      decoration: _inputDecoration(
                        'Potvrdi lozinku',
                        suffix: IconButton(
                          icon: Icon(
                            _obscure2 ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => _obscure2 = !_obscure2),
                        ),
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        if (v.isEmpty) return 'Potvrda lozinke je obavezna';

                        final pass = _passCtrl.text;
                        if (!_isStrongPassword(pass)) return null;

                        if (v != pass) return 'Lozinke se ne poklapaju';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cityCtrl,
                      decoration: _inputDecoration('Grad'),
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Grad je obavezan';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Dugme registracije
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                       onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {

                          AppSession.login(
                            UserRole.user,
                            userEmail: _emailCtrl.text.trim(),
                            name: _firstNameCtrl.text.trim(),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GuestHomeScreen(isGuest: false),
                            ),
                          );
                        }
                      },

                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Registruj se',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Link ka login-u
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Već imaš nalog? '),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRouter.login),
                          child: const Text(
                            'Prijavi se',
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
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
      ),
    );
  }
}
