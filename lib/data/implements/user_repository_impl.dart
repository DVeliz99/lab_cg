import 'package:lab_cg/data/repositories/user_repository.dart';
import 'package:lab_cg/domain/auth.dart';
import 'package:lab_cg/domain/user.dart';
import 'package:lab_cg/data/data_sources/user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  /*
  @override
  Future<List<User>> getUsers() {
    return dataSource.getUsers();
  }*/

  @override
  Future<AppUser?> getUserByUid(String id) {
    return dataSource.getUserByUid(id);
  }

  /*
  @override
  Future<void> createUser(User user) {
    return dataSource.createUser(user);
  }

  */

  /*
  @override
  Future<void> deleteUser(int id) {
    return dataSource.deleteUser(id);
  }

  */
}
