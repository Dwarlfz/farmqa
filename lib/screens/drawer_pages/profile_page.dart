import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _data = null;
        _loading = false;
      });
      return;
    }
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    setState(() {
      _data = doc.exists ? doc.data() : null;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 40, backgroundColor: Colors.green.shade700, child: const Icon(Icons.person, size: 44, color: Colors.white)),
            const SizedBox(height: 12),
            Text(_data?['name'] ?? 'No name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(_data?['email'] ?? 'No email'),
            const SizedBox(height: 16),
            ListTile(title: const Text('Language'), subtitle: Text(_data?['language'] ?? 'English')),
            ListTile(title: const Text('Location'), subtitle: Text(_data?['manualLocation'] ?? 'Not set')),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: const Text('Edit Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
