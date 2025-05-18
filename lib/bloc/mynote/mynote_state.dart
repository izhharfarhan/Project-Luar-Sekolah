import '../../models/mynote.dart';

abstract class MyNoteState {}

class MyNoteInitial extends MyNoteState {}

class MyNoteLoading extends MyNoteState {}

class MyNoteLoaded extends MyNoteState {
  final List<MyNote> notes;
  MyNoteLoaded(this.notes);
}

class MyNoteError extends MyNoteState {
  final String message;
  MyNoteError(this.message);
}