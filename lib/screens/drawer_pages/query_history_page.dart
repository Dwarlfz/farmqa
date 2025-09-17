import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QueryHistoryPage extends StatelessWidget {
  const QueryHistoryPage({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> _stream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('queries')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query History')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _stream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading queries'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No queries yet'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i].data();
              return Card(
                child: ListTile(
                  title: Text(d['question'] ?? 'Question'),
                  subtitle: Text(d['answer'] ?? 'Pending'),
                  trailing: Text(d['resolved'] == true ? 'Resolved' : 'Open'),
                  onTap: () {
                    // open details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
