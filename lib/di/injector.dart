import 'package:get_it/get_it.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/sources/remote/api_service.dart';
import '../domain/repositories/user_repository.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> initDependencies() async {
  // ✅ Data sources
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // ✅ Repositories
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(apiService: sl()),
  );

  // ✅ ViewModels / Controllers (optional)
  // sl.registerFactory(() => AuthViewModel(userRepository: sl()));
}
