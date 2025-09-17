import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About & Help')),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('About Farmer Connect', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('A citizen-first advisory platform connecting farmers to AI and expert consultants.'),
          const SizedBox(height: 12),
          const Text('Help & Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ListTile(leading: const Icon(Icons.phone), title: const Text('Helpline: 1800-XXX-XXXX')),
          ListTile(leading: const Icon(Icons.mail), title: const Text('support@farmerconnect.app')),
          const SizedBox(height: 10),
          const Text('Version: 0.1.0 (Hackathon build)'),
        ]),
      ),
    );
  }
}
