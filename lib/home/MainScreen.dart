import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import '../profile/ProfileScreen.dart';
import '../notes_api/NotesApiScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    BlocProvider(
      create: (_) => NotesBloc(),
      child: const HomeScreen(key: ValueKey('home')),
    ),
    const NotesApiScreen(key: ValueKey('api')),
    const ProfileScreen(key: ValueKey('profile')),
  ];

  final List<String> _titles = ['Note Keeper', 'Catatan API', 'Profil'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
