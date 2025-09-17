import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedAdvisoryPage extends StatelessWidget {
  const SavedAdvisoryPage({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> _streamSaved() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Advisory')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _streamSaved(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No saved items'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i].data();
              return Card(
                child: ListTile(
                  title: Text(d['title'] ?? 'Advisory'),
                  subtitle: Text(d['summary'] ?? ''),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
