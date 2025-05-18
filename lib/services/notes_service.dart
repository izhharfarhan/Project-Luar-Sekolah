import 'package:firebase_database/firebase_database.dart';
import '../models/mynote.dart';

class NotesService {
  final _db = FirebaseDatabase.instance;

  Future<List<MyNote>> getNotes(String uid) async {
    final ref = _db.ref('notes/$uid');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((entry) {
        return MyNote.fromMap(entry.key, Map<String, dynamic>.from(entry.value));
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> addNote(String uid, String title, String content) async {
    final ref = _db.ref('notes/$uid').push();
    final note = MyNote(
      id: ref.key!,
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    await ref.set(note.toMap());
  }

  Future<void> updateNote(String uid, String noteId, String title, String content) async {
    final ref = _db.ref('notes/$uid/$noteId');
    await ref.update({
      'title': title,
      'content': content,
    });
  }

  Future<void> deleteNote(String uid, String noteId) async {
    final ref = _db.ref('notes/$uid/$noteId');
    await ref.remove();
  }
}
