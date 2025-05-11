import 'package:get_it/get_it.dart';
import '../data/post_provider.dart';
import '../repository/post_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PostProvider());
  locator.registerLazySingleton(() => PostRepository(locator<PostProvider>()));
}
