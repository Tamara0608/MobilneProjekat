import 'package:flutter/material.dart';
import '../core/session/app_session.dart';
import '../widgets/section_title.dart';
import '../widgets/primary_outlined_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const Color _bg = Color(0xFFFFEEF3);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _profileKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = AppSession.firstName ?? '';
    _emailCtrl.text = AppSession.email ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
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

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EditProfileScreen._bg,
      appBar: AppBar(
        backgroundColor: EditProfileScreen._bg,
        elevation: 0,
        title: const Text('Moj profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(text: 'Informacije o profilu'),
            _card(
              Form(
                key: _profileKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: _inputDecoration('Ime i prezime'),
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Ime i prezime je obavezno';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 14),
                    PrimaryOutlinedButton(
                      text: 'Sačuvaj izmene',
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_profileKey.currentState!.validate()) {
                          AppSession.firstName = _nameCtrl.text.trim();
                          AppSession.email = _emailCtrl.text.trim();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sačuvane izmene profila'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const SectionTitle(text: 'Promeni lozinku'),
            _card(
              Form(
                key: _passKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _currentPassCtrl,
                      obscureText: _hideCurrent,
                      decoration: _inputDecoration(
                        'Trenutna lozinka',
                        suffix: IconButton(
                          icon: Icon(
                            _hideCurrent ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _hideCurrent = !_hideCurrent),
                        ),
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        if (v.isEmpty) return 'Trenutna lozinka je obavezna';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _newPassCtrl,
                      obscureText: _hideNew,
                      decoration: _inputDecoration(
                        'Nova lozinka',
                        suffix: IconButton(
                          icon: Icon(
                            _hideNew ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => _hideNew = !_hideNew),
                        ),
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        if (v.isEmpty) return 'Nova lozinka je obavezna';
                        if (!_isStrongPassword(v)) {
                          return 'Lozinka mora imati najmanje 8 karaktera i sadržati: veliko slovo, malo slovo, broj i specijalan karakter.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmPassCtrl,
                      obscureText: _hideConfirm,
                      decoration: _inputDecoration(
                        'Potvrdi novu lozinku',
                        suffix: IconButton(
                          icon: Icon(
                            _hideConfirm ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _hideConfirm = !_hideConfirm),
                        ),
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        if (v.isEmpty) return 'Potvrda lozinke je obavezna';
                        if (v != _newPassCtrl.text) return 'Lozinke se ne poklapaju';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    PrimaryOutlinedButton(
                      text: 'Ažuriraj lozinku',
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_passKey.currentState!.validate()) {
                          _currentPassCtrl.clear();
                          _newPassCtrl.clear();
                          _confirmPassCtrl.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lozinka je ažurirana'),
                            ),
                          );
                        }
                      },
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
}
