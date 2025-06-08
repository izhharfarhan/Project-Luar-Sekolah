import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_pbi_luarsekolah/bloc/auth/auth_bloc.dart';
import 'package:project_pbi_luarsekolah/bloc/auth/auth_event.dart';
import 'package:project_pbi_luarsekolah/bloc/auth/auth_state.dart';
import 'mocks.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    
    // Inisialisasi AuthBloc dengan MockFirebaseAuth
    authBloc = AuthBloc(auth: mockFirebaseAuth);

    // Mock perilaku
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');
  });

  tearDown(() {
    authBloc.close(); // Tutup bloc setelah setiap pengujian
  });

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'Mengeluarkan [AuthLoading, AuthAuthenticated] saat login berhasil',
      build: () {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        )).thenAnswer((_) async => mockUserCredential);
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('test@example.com', 'password123')),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated('test-uid'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Mengeluarkan [AuthLoading, AuthError] saat login gagal',
      build: () {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrongpassword',
        )).thenThrow(FirebaseAuthException(code: 'wrong-password', message: 'Password salah'));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('test@example.com', 'wrongpassword')),
      expect: () => [
        AuthLoading(),
        AuthError('Login gagal: [firebase_auth/wrong-password] Password salah'),
      ],
    );
  });

  group('RegisterRequested', () {
    blocTest<AuthBloc, AuthState>(
      'Mengeluarkan [AuthLoading, AuthAuthenticated] saat registrasi berhasil',
      build: () {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'new@example.com',
          password: 'password123',
        )).thenAnswer((_) async => mockUserCredential);
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterRequested('new@example.com', 'password123')),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated('test-uid'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Mengeluarkan [AuthLoading, AuthError] saat registrasi gagal',
      build: () {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'new@example.com',
          password: 'weak',
        )).thenThrow(FirebaseAuthException(code: 'weak-password', message: 'Password terlalu lemah'));
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterRequested('new@example.com', 'weak')),
      expect: () => [
        AuthLoading(),
        AuthError('Registrasi gagal: [firebase_auth/weak-password] Password terlalu lemah'),
      ],
    );
  });

  group('LogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'Mengeluarkan [AuthInitial] saat logout berhasil',
      build: () {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async => Future<void>.value());
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [
        AuthInitial(),
      ],
    );
  });
}