import 'package:flutter/material.dart';
import '../models/response/post_response.dart';

class NotesDetailScreen extends StatelessWidget {
  final PostResponse post;
  const NotesDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ditulis oleh: ${post.userName ?? "Anonim"}',
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
                const Divider(height: 24),
                Text(
                  post.body,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}