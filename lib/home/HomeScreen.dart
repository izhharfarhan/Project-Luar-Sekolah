import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/mynote/mynote_bloc.dart';
import '../bloc/mynote/mynote_event.dart';
import '../bloc/mynote/mynote_state.dart';
import '../models/mynote.dart';
import 'NoteFormScreen.dart';
import 'MyNoteDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _name = '';
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _loadName();
    _uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<MyNoteBloc>().add(LoadMyNotes(_uid));
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
    });
  }

  void _addNote() {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      context.read<MyNoteBloc>().add(AddMyNote(
        uid: _uid,
        title: _titleController.text,
        content: _contentController.text,
      ));
      _titleController.clear();
      _contentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_name.isNotEmpty) ...[
              Text('Hallo, $_name!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Hari ini kamu mau mencatat apa?', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
            ],
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Catatan',
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
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<MyNoteBloc, MyNoteState>(
                builder: (context, state) {
                  if (state is MyNoteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MyNoteLoaded) {
                    if (state.notes.isEmpty) {
                      return const Center(child: Text("Belum ada catatan"));
                    }

                    return ListView.builder(
                      itemCount: state.notes.length,
                      itemBuilder: (context, index) {
                        final note = state.notes[index];
                        return Dismissible(
                          key: ValueKey(note.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            context.read<MyNoteBloc>().add(DeleteMyNote(uid: _uid, noteId: note.id));
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(note.content),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MyNoteDetailScreen(note: note),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<MyNoteBloc>(),
                                        child: NoteFormScreen(note: note),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("Gagal memuat catatan"));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Tambah Catatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
