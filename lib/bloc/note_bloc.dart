import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/database_helper.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final DatabaseHelper databaseHelper;

  NoteBloc({required this.databaseHelper}) : super(NoteInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      try {
        final notes = await databaseHelper.getAllNotes();
        emit(NoteLoaded(notes));
      } catch (e) {
        emit(NoteError("failed to load notes: ${e.toString()}"));
      }
    });

    on<AddNote>((event, emit) async {
      try {
        await databaseHelper.insertNote(event.note);
        add(LoadNotes());
      } catch (e) {
        emit(NoteError("failed to add note"));
      }
    });

    on<UpdateNote>((event, emit) async {
      try {
        await databaseHelper.updateNote(event.note);
        add(LoadNotes());
      } catch (e) {
        emit(NoteError("failed to update note"));
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        await databaseHelper.deleteNote(event.id);
        add(LoadNotes());
      } catch (e) {
        emit(NoteError("failed to delete note"));
      }
    });
  }
}
