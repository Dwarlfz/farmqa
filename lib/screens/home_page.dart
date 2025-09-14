// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Signed in as: ${auth.user?.email ?? 'Google User'}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
            child: const Text('Sign out'),
          ),
        ]),
      ),
    );
  }
}
