import 'package:flutter/material.dart';

class AdvisoryPage extends StatelessWidget {
  const AdvisoryPage({super.key});

  Widget _card(String title, IconData icon, String subtitle) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon, color: Colors.white), backgroundColor: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: expand into domain-specific advisory pages
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(12), children: [
      const SizedBox(height: 8),
      const Text('Advisory Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      _card('Agriculture', Icons.agriculture, 'Crop advisory, pest control, best practices'),
      _card('Government Schemes', Icons.policy, 'Find subsidies, loan schemes, welfare programs'),
      _card('Health Advisory', Icons.local_hospital, 'Maternal and general health guidance'),
      _card('Market Prices', Icons.trending_up, 'Local mandi rates & price forecasts'),
      _card('Weather & Alerts', Icons.cloud, 'Seasonal advisories and warnings'),
    ]);
  }
}
