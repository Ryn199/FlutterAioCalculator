import 'package:aiocalculator/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Untuk format timestamp

class HistoryPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> _getUserHistory() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];
    try {
      final snapshot = await _firestore
          .collection('history')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('timestamp', descending: true)
          .get();
    
      // Debug: Print data yang diambil
      for (var doc in snapshot.docs) {
        print('Fetched Document: ${doc.data()}');
      }

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error fetching history: $e');
      return [];
    }
  }

  // Memformat timestamp dengan pengecekan tipe data
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final dateTime = timestamp.toDate();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    } else if (timestamp is String) {
      return timestamp; // Jika timestamp disimpan sebagai String
    }
    return 'Unknown time';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('History'),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed:
      () => context.go('/calculator'),
  ),
),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUserHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return const Center(child: Text('No history available.'));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final expression = item['expression'] ?? 'Unknown expression';
              final result = item['result'] ?? 'Unknown result';
              final timestamp = item['timestamp'];

              return ListTile(
                title: Text('$expression = $result'),
                subtitle: Text('Timestamp: ${formatTimestamp(timestamp)}'),
              );
            },
          );
        },
      ),
    );
  }
}
