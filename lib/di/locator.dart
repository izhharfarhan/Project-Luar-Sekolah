import 'package:get_it/get_it.dart';
import '../data/post_provider.dart';
import '../repository/post_repository.dart';
import '../bloc/auth/auth_bloc.dart'; 

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PostProvider());
  locator.registerLazySingleton(() => PostRepository(locator<PostProvider>()));

  //pendaftaran AuthBloc
  if (!locator.isRegistered<AuthBloc>()) {
    locator.registerLazySingleton<AuthBloc>(() => AuthBloc());
  }
}
