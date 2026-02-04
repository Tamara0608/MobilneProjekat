import 'package:flutter/material.dart';
import '../core/session/app_session.dart';
import '../widgets/section_title.dart';
import '../widgets/primary_outlined_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _isLoading = false;

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

  Future<void> _handleUpdateProfile() async {
    FocusScope.of(context).unfocus();
    if (!_profileKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final newName = _nameCtrl.text.trim();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'firstName': newName});

      AppSession.firstName = newName;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil uspešno ažuriran!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Greška pri čuvanju profila.'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleChangePassword() async {
    FocusScope.of(context).unfocus();
 
    if (!_passKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    setState(() => _isLoading = true);

    try {
      
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPassCtrl.text,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(_newPassCtrl.text.trim());

     
      _currentPassCtrl.clear();
      _newPassCtrl.clear();
      _confirmPassCtrl.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lozinka uspešno promenjena!')),
        );
      }
    } on FirebaseAuthException catch (e) {
     
      String msg = 'Došlo je do greške.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        msg = 'Trenutna lozinka nije tačna.';
      } else if (e.code == 'weak-password') {
        msg = 'Nova lozinka je preslaba.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sistemska greška. Pokušajte kasnije.'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isStrongPassword(String pass) {
    final hasUpper = RegExp(r'[A-Z]').hasMatch(pass);
    final hasLower = RegExp(r'[a-z]').hasMatch(pass);
    final hasDigit = RegExp(r'\d').hasMatch(pass);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]~`+=;]').hasMatch(pass);
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
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
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
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            validator: (v) => v!.trim().isEmpty ? 'Ime je obavezno' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailCtrl,
                            readOnly: true,
                            decoration: _inputDecoration('Email').copyWith(
                              fillColor: const Color(0xFFF2F2F2),
                            ),
                          ),
                          const SizedBox(height: 14),
                          PrimaryOutlinedButton(
                            text: 'Sačuvaj izmene',
                            onPressed: _handleUpdateProfile,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                                icon: Icon(_hideCurrent ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _hideCurrent = !_hideCurrent),
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Unesite trenutnu lozinku' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _newPassCtrl,
                            obscureText: _hideNew,
                            decoration: _inputDecoration(
                              'Nova lozinka',
                              suffix: IconButton(
                                icon: Icon(_hideNew ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _hideNew = !_hideNew),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Unesite novu lozinku';
                              if (!_isStrongPassword(v)) return 'Lozinka je slaba';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmPassCtrl,
                            obscureText: _hideConfirm,
                            decoration: _inputDecoration(
                              'Potvrdi lozinku',
                              suffix: IconButton(
                                icon: Icon(_hideConfirm ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Potvrdite novu lozinku';
                              if (v != _newPassCtrl.text) return 'Lozinke se ne poklapaju';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          PrimaryOutlinedButton(
                            text: 'Ažuriraj lozinku',
                            onPressed: _handleChangePassword,
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