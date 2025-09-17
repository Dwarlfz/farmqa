import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_page.dart';
import '../home/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // show splash for 2.2s and route based on auth state
    Timer(const Duration(milliseconds: 2200), () {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logos/farmer_logo.png', height: 120),
              const SizedBox(height: 16),
              const Text(
                'Farmer Connect',
                style: TextStyle(
                    color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Smart Advisory Partner',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
