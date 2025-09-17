import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  String _language = 'English';
  bool _locationAllowed = false;
  bool _agreed = false;
  final _manualLocationCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _manualLocationCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePreferences() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept Terms & Conditions')));
      return;
    }

    setState(() => _isSaving = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final data = {
      'language': _language,
      'locationAllowed': _locationAllowed,
      'manualLocation': _manualLocationCtrl.text.trim(),
      'termsAccepted': _agreed,
      'prefsCompleted': true,
      'prefsUpdatedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          DropdownButtonFormField<String>(
            value: _language,
            decoration: const InputDecoration(labelText: 'Choose language'),
            items: ['English', 'Hindi', 'Kannada', 'Tamil'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
            onChanged: (v) => setState(() => _language = v ?? 'English'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _locationAllowed,
            onChanged: (v) => setState(() => _locationAllowed = v),
            title: const Text('Allow location access'),
          ),
          TextFormField(
            controller: _manualLocationCtrl,
            decoration: const InputDecoration(labelText: 'Manual location (optional)'),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v ?? false),
            title: const Text('I agree to the Terms & Conditions'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _savePreferences,
              child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Continue'),
            ),
          ),
        ]),
      ),
    );
  }
}
