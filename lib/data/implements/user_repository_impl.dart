import 'package:lab_cg/domain/user.dart';
import 'package:lab_cg/data/data_sources/user_data_source.dart';
import 'package:lab_cg/data/repositories/user_repository.dart';


class UserRepositoryImpl {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<List<User>> getUsers() {
    return dataSource.getUsers();
  }

  @override
  Future<User?> getUserById(int id) {
    return dataSource.getUserById(id);
  }

  @override
  Future<void> createUser(User user) {
    return dataSource.createUser(user);
  }

  @override
  Future<void> deleteUser(int id) {
    return dataSource.deleteUser(id);
  }
}
