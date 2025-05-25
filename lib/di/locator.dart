import 'package:get_it/get_it.dart';
import '../data/post_provider.dart';
import '../repository/post_repository.dart';
import '../bloc/auth/auth_bloc.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';
import '../repository/notification_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PostProvider());
  locator.registerLazySingleton(() => PostRepository(locator<PostProvider>()));
  locator.registerLazySingleton(() => FirebaseMessaging.instance);
  locator.registerLazySingleton(() => NotificationRepository(locator<FirebaseMessaging>()));

  //pendaftaran AuthBloc
  if (!locator.isRegistered<AuthBloc>()) {
    locator.registerLazySingleton<AuthBloc>(() => AuthBloc());
  }
}
