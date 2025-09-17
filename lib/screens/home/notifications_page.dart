import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder notifications
    final items = List.generate(6, (i) => 'Notification ${i + 1}: sample advisory / alert');

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.notifications, color: Colors.green),
            title: Text(items[i]),
            subtitle: const Text('Tap for details'),
            onTap: () {},
          ),
        );
      },
    );
  }
}
