import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/drawer_menu.dart';
import '../../widgets/bottom_navbar.dart';
import 'chatbot_page.dart';
import 'advisory_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    ChatbotPage(),
    AdvisoryPage(),
    NotificationsPage(),
    // For profile bottom-tab we will navigate to drawer profile to avoid duplicating pages
    Center(child: Text('Profile tab - open drawer for full profile')),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Connect'),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          // if user tapped profile tab (index 3) -> open profile page
          if (i == 3) {
            Navigator.pushNamed(context, '/profile');
            return;
          }
          setState(() => _currentIndex = i);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // quick query shortcut
          setState(() => _currentIndex = 0);
        },
        child: const Icon(Icons.question_answer),
      ),
    );
  }
}
