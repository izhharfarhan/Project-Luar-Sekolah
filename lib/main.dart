import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login/LoginScreen.dart';
import 'home/MainScreen.dart';
import 'di/locator.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/mynote/mynote_bloc.dart';
import 'bloc/notification/notification_bloc.dart';
import 'services/notes_service.dart';
import 'firebase_options.dart';
import 'repository/notification_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  // Inisialisasi FCM
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  messaging.setAutoInitEnabled(true);

  // Ambil token FCM untuk test kirim notifikasi manual dari Firebase Console
  final token = await messaging.getToken();
  debugPrint("FCM Token: $token");

  // Login check
  final user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(initialRoute: user == null ? '/' : '/main'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => locator<AuthBloc>(),
        ),
        BlocProvider<MyNoteBloc>(
          create: (_) => MyNoteBloc(NotesService()),
        ),
        BlocProvider<NotificationBloc>( 
          create: (_) => NotificationBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Note App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        routes: {
          '/': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}
