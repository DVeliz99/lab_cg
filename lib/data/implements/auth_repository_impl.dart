import '/domain/auth.dart';
import '../repositories/auth_repository.dart';
import '../data_sources/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
  Future<void> logout() async {
    await authDataSource.logout();
  }

  @override
  Future<Auth> getCurrentUser() async {
    return await authDataSource.getCurrentUser();
  }

  @override
  Future<Auth> login(String email, String password) async {
    return await authDataSource.login(email, password);
  }
}
