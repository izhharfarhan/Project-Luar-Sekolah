import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/note.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final List<Note> _notes = [];

  NotesBloc() : super(NotesInitial()) {
    on<AddNoteEvent>((event, emit) {
      _notes.add(event.note);
      emit(NotesLoaded(List.from(_notes)));
    });

    on<DeleteNoteEvent>((event, emit) {
      _notes.removeWhere((note) => note.id == event.noteId);
      emit(NotesLoaded(List.from(_notes)));
    });

    on<UpdateNoteEvent>((event, emit) {
      if (event.index >= 0 && event.index < _notes.length) {
        _notes[event.index] = event.updatedNote;
        emit(NotesLoaded(List.from(_notes)));
      }
    });

  }
}
