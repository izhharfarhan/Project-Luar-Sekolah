import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart'; 
import '../profile/ProfileScreen.dart';
import '../home/HomeScreen.dart';
import '../notes_api/NotesApiScreen.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notification/notification_bloc.dart';
import '../bloc/notification/notification_event.dart';
import '../bloc/notification/notification_state.dart';
import '../repository/notification_repository.dart';
import '../di/locator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = ['Note Keeper', 'Catatan API', 'Profil'];

  List<Widget> get _pages => [
        BlocProvider(
          create: (_) => NotesBloc(),
          child: const HomeScreen(key: ValueKey('home')),
        ),
        const NotesApiScreen(key: ValueKey('api')),
        const ProfileScreen(key: ValueKey('profile')),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    final repo = locator<NotificationRepository>();

    // Listener saat app aktif
    repo.onMessage.listen((message) {
      context.read<NotificationBloc>().add(NotificationReceived(message));
    });

    // Listener saat user klik notifikasi (foreground/background/killed)
    repo.onMessageOpenedApp.listen((message) {
      context.read<NotificationBloc>().add(NotificationOpened(message));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationReceivedState) {
          final notif = state.message.notification;
          if (notif != null) {
            final snackBar = SnackBar(
              content: Text("${notif.title} - ${notif.body}"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }

        if (state is NotificationOpenedState) {
          final notif = state.message.notification;
          if (notif != null) {
            Fluttertoast.showToast(
              msg: "notifikasi: ${notif.body}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Note API'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
