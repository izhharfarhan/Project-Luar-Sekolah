import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pbi_luarsekolah/bloc/auth/auth_bloc.dart';
import 'package:project_pbi_luarsekolah/bloc/auth/auth_event.dart';
import 'package:project_pbi_luarsekolah/bloc/auth/auth_state.dart';
import 'package:project_pbi_luarsekolah/login/LoginScreen.dart';
import 'mocks.mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late MockNavigatorObserver mockNavigatorObserver;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockNavigatorObserver = MockNavigatorObserver();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    // Mock perilaku
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');
    when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
    SharedPreferences.setMockInitialValues({});
  });

  Widget createWidgetUnderTest() {
  return MaterialApp(
    home: BlocProvider(
      create: (_) => AuthBloc(auth: mockFirebaseAuth),
      child: LoginScreen(sharedPreferences: mockSharedPreferences),
    ),
    navigatorObservers: [mockNavigatorObserver],
    routes: {
      '/main': (context) => const Scaffold(body: Text('Main Screen')),
    },
  );
}

  group('LoginScreen Tests', () {
    testWidgets('Menampilkan pesan error jika email kosong', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Pastikan tombol tidak aktif sebelum input
      expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed, isNull);

      // Masukkan email kosong untuk memicu onChanged
      await tester.enterText(find.byType(TextFormField).at(0), '');
      await tester.pump();

      // Paksa validasi form
      final formKey = tester.widget<Form>(find.byType(Form)).key as GlobalKey<FormState>;
      formKey.currentState!.validate();
      await tester.pump();

      // Verifikasi pesan error
      expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    });

    testWidgets('Mengaktifkan tombol login saat formulir valid', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Masukkan email dan password valid
      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pump();

      // Verifikasi tombol aktif
      final button = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(button).onPressed, isNotNull);
    });

    testWidgets('Memicu LoginRequested dan berpindah halaman saat sukses', (WidgetTester tester) async {
      // Mock login berhasil
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      await tester.pumpWidget(createWidgetUnderTest());

      // Masukkan email dan password
      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pump();

      // Tap tombol login
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verifikasi SharedPreferences dipanggil
      verify(mockSharedPreferences.setString('uid', 'test-uid')).called(1);
      verify(mockSharedPreferences.setString('email', 'test@example.com')).called(1);

      // Verifikasi navigasi ke '/main'
      expect(find.text('Main Screen'), findsOneWidget);
    });
  });
}