
import '/data/repositories/auth_repository.dart';
import '/domain/auth.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Auth> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
