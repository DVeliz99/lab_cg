import '/domain/auth.dart';

abstract class AuthRepository {
  Future<void> logout();
  Future<Auth> getCurrentUser();
  Future<Auth> login(String email, String password);
}
