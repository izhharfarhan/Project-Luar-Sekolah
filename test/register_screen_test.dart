import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_pbi_luarsekolah/bloc/auth/auth_bloc.dart';
import 'package:project_pbi_luarsekolah/bloc/auth/auth_event.dart';
import 'package:project_pbi_luarsekolah/bloc/auth/auth_state.dart';
import 'package:project_pbi_luarsekolah/login/RegisterScreen.dart';

import 'mocks.mocks.dart'; // pastikan sudah generate mock-nya pakai @GenerateMocks

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockDatabaseReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();

    when(mockFirebaseDatabase.ref()).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.set(any)).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest(AuthBloc bloc) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (_) => bloc,
        child: RegisterScreen(firebaseDatabase: mockFirebaseDatabase),
      ),
    );
  }

  testWidgets('Menampilkan pesan error jika email kosong', (tester) async {
  final bloc = AuthBloc(auth: mockFirebaseAuth);
  await tester.pumpWidget(createWidgetUnderTest(bloc));

  // Isi semua kecuali email agar form bisa mencoba validasi
  await tester.enterText(find.byType(TextFormField).at(1), 'password123');
  await tester.enterText(find.byType(TextFormField).at(2), 'John Doe');
  await tester.enterText(find.byType(TextFormField).at(3), 'Developer');
  await tester.enterText(find.byType(TextFormField).at(4), '123456789');
  await tester.pump();

  // Klik tombol
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();

  // Cek error muncul di field email
  expect(find.text('Wajib diisi'), findsOneWidget);
});


  testWidgets('Mengaktifkan tombol register saat form valid', (tester) async {
    final bloc = AuthBloc(auth: mockFirebaseAuth);
    await tester.pumpWidget(createWidgetUnderTest(bloc));

    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).at(2), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(3), 'Developer');
    await tester.enterText(find.byType(TextFormField).at(4), '123456789');
    await tester.pump();

    final button = find.byType(ElevatedButton);
    expect(tester.widget<ElevatedButton>(button).onPressed, isNotNull);
  });

  testWidgets('Memicu RegisterRequested dan menyimpan ke database saat sukses', (tester) async {
    final bloc = AuthBloc(auth: mockFirebaseAuth);
    await tester.pumpWidget(createWidgetUnderTest(bloc));

    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).at(2), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(3), 'Developer');
    await tester.enterText(find.byType(TextFormField).at(4), '123456789');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Simulasikan emit AuthAuthenticated dari Bloc
    bloc.emit(AuthAuthenticated('test-uid'));
    await tester.pump();

    verify(mockDatabaseReference.set({
      'name': 'John Doe',
      'job': 'Developer',
      'phone': '123456789',
      'email': 'test@example.com',
    })).called(1);

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
