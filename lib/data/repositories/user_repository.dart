import 'package:lab_cg/domain/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(int id);
  Future<void> createUser(
    User user,
  ); // puede servir para el usuario administrador
  Future<void> updateUser(User user);
}
