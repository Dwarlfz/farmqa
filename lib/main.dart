import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/preferences/preference_page.dart';
import 'screens/home/home_page.dart';
import 'screens/drawer_pages/profile_page.dart';
import 'screens/drawer_pages/query_history_page.dart';
import 'screens/drawer_pages/saved_advisory_page.dart';
import 'screens/drawer_pages/settings_page.dart';
import 'screens/drawer_pages/about_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Farmer Connect',
            theme: ThemeData(
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: const Color(0xFFF1F8E9),
              useMaterial3: true,
            ),
            initialRoute: '/splash',
            routes: {
              '/splash': (_) => const SplashScreen(),
              '/login': (_) => const LoginPage(),
              '/register': (_) => const RegisterPage(),
              '/preferences': (_) => const PreferencePage(),
              '/home': (_) => const HomePage(),
              '/profile': (_) => const ProfilePage(),
              '/history': (_) => const QueryHistoryPage(),
              '/saved': (_) => const SavedAdvisoryPage(),
              '/settings': (_) => const SettingsPage(),
              '/about': (_) => const AboutPage(),
            },
          );
        },
      ),
    );
  }
}
