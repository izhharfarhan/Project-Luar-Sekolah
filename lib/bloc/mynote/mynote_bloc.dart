import 'package:flutter_bloc/flutter_bloc.dart';
import 'mynote_event.dart';
import 'mynote_state.dart';
import '../../models/mynote.dart';
import '../../services/notes_service.dart';

class MyNoteBloc extends Bloc<MyNoteEvent, MyNoteState> {
  final NotesService notesService;

  MyNoteBloc(this.notesService) : super(MyNoteInitial()) {
    on<LoadMyNotes>((event, emit) async {
      emit(MyNoteLoading());
      try {
        final notes = await notesService.getNotes(event.uid);
        final converted = notes.map((e) => MyNote(
          id: e.id,
          title: e.title,
          content: e.content,
          createdAt: e.createdAt,
        )).toList();
        emit(MyNoteLoaded(converted));
      } catch (e) {
        emit(MyNoteError("Gagal memuat catatan"));
      }
    });

    on<AddMyNote>((event, emit) async {
      await notesService.addNote(event.uid, event.title, event.content);
      add(LoadMyNotes(event.uid));
    });

    on<UpdateMyNote>((event, emit) async {
      await notesService.updateNote(event.uid, event.noteId, event.title, event.content);
      add(LoadMyNotes(event.uid));
    });

    on<DeleteMyNote>((event, emit) async {
      await notesService.deleteNote(event.uid, event.noteId);
      add(LoadMyNotes(event.uid));
    });
  }
}
