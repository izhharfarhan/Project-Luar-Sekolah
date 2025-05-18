import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/mynote/mynote_bloc.dart';
import '../bloc/mynote/mynote_event.dart';
import '../models/mynote.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteFormScreen extends StatefulWidget {
  final MyNote note;

  const NoteFormScreen({super.key, required this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  void _updateNote() {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      context.read<MyNoteBloc>().add(UpdateMyNote(
        uid: _uid,
        noteId: widget.note.id,
        title: _titleController.text,
        content: _contentController.text,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _updateNote,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
