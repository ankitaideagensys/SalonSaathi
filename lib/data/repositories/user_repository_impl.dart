import '../sources/remote/api_service.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl({required this.apiService});

  @override
  void getUserData() {
    apiService.fetchData();
  }
}
