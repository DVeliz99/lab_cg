import 'package:lab_cg/core/failure.dart';
import 'package:lab_cg/core/result.dart';

import '/data/repositories/auth_repository.dart';
import '/domain/auth.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Result<Auth>> call() async {
    try {
      final user = await repository.getCurrentUser();
      return Result.success(user);
    } catch (e) {
      return Result.failure(AuthFailure(e.toString()));
    }
  }
}

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Result<Auth>> call(String email, String password) async {
    try {
      final user = await repository.login(email, password);
      return Result.success(user);
    } catch (e) {
      return Result.failure(AuthFailure(e.toString()));
    }
  }
}
