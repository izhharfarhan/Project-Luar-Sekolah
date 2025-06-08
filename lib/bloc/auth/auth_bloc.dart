import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;

  AuthBloc({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCred = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        if (userCred.user != null) {
          emit(AuthAuthenticated(userCred.user!.uid));
        } else {
          emit(AuthError('Login gagal: Pengguna tidak ditemukan'));
        }
      } catch (e) {
        emit(AuthError('Login gagal: $e'));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCred = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        if (userCred.user != null) {
          emit(AuthAuthenticated(userCred.user!.uid));
        } else {
          emit(AuthError('Registrasi gagal: Pengguna tidak dibuat'));
        }
      } catch (e) {
        emit(AuthError('Registrasi gagal: $e'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await _auth.signOut();
      emit(AuthInitial());
    });
  }
}