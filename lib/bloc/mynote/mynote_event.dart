abstract class MyNoteEvent {}

class LoadMyNotes extends MyNoteEvent {
  final String uid;
  LoadMyNotes(this.uid);
}

class AddMyNote extends MyNoteEvent {
  final String uid;
  final String title;
  final String content;
  AddMyNote({required this.uid, required this.title, required this.content});
}

class UpdateMyNote extends MyNoteEvent {
  final String uid;
  final String noteId;
  final String title;
  final String content;
  UpdateMyNote({required this.uid, required this.noteId, required this.title, required this.content});
}

class DeleteMyNote extends MyNoteEvent {
  final String uid;
  final String noteId;
  DeleteMyNote({required this.uid, required this.noteId});
}