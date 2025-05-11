import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ Tambahan untuk Bloc
import '../bloc/post_bloc.dart';                 // ✅ Tambahan
import '../bloc/post_event.dart';               // ✅ Tambahan
import '../bloc/post_state.dart';               // ✅ Tambahan
import '../repository/post_repository.dart';    // ✅ Tambahan
import '../di/locator.dart';                    // ✅ Tambahan
import '../models/response/post_response.dart';
import 'NotesDetailScreen.dart';

class NotesApiScreen extends StatefulWidget {
  const NotesApiScreen({super.key});

  @override
  State<NotesApiScreen> createState() => _NotesApiScreenState();
}

class _NotesApiScreenState extends State<NotesApiScreen> {
  late PostBloc _bloc; // ✅ Tambahan: deklarasi Bloc

  @override
  void initState() {
    super.initState();
    _bloc = PostBloc(locator<PostRepository>()); // ✅ Inisialisasi Bloc dengan GetIt
    _bloc.add(FetchPostsEvent());                // ✅ Trigger fetch data saat halaman dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Ganti FutureBuilder dengan BlocConsumer
      body: BlocConsumer<PostBloc, PostState>(
        bloc: _bloc,
        listener: (context, state) {
          // ✅ Menampilkan pesan sukses atau error
          if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("data tidak ditemukan")),
            );
          } else if (state is PostLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("data berhasil ditampikan")),
            );
          }
        },
        builder: (context, state) {
          // ✅ State Loading
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // ✅ State Loaded
          else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text("Belum ada data post"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('👤 ${post.userName ?? ""}'),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotesDetailScreen(post: post),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          // ✅ State Error (jaga-jaga)
          else {
            return const Center(child: Text("Terjadi kesalahan"));
          }
        },
      ),
    );
  }
}
