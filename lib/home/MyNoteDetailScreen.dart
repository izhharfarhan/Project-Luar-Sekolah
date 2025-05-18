import 'package:flutter/material.dart';
import '../../models/mynote.dart';

class MyNoteDetailScreen extends StatelessWidget {
  final MyNote note;

  const MyNoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Catatan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              note.content,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Text(
              'Dibuat pada: ${note.createdAt.toLocal().toString().split('.')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
