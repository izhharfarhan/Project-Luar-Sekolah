import '../models/note.dart';

abstract class NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final Note note;
  AddNoteEvent(this.note);
}

class DeleteNoteEvent extends NotesEvent {
  final int noteId;
  DeleteNoteEvent(this.noteId);
}

class UpdateNoteEvent extends NotesEvent {
  final int index;
  final Note updatedNote;

  UpdateNoteEvent({required this.index, required this.updatedNote});
}

