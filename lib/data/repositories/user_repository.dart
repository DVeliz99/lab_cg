import 'package:lab_cg/domain/auth.dart';
import 'package:lab_cg/domain/user.dart';

abstract class UserRepository {
  // Future<List<User>> getUsers();
  Future<AppUser?> getUserByUid(String id);
  // Future<void> createUser(
  //   User user,
  // ); // puede servir para el usuario administrador
  // Future<void> updateUser(User user);
  // Future<void> deleteUser(int id);
  // Future<void> saveUserProfile(UserProfile user);
}
