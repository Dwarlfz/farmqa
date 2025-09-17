import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBar({required this.currentIndex, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.green.shade800,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Query'),
        BottomNavigationBarItem(icon: Icon(Icons.view_agenda), label: 'Advisory'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Alerts'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
