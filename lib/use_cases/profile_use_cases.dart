import 'package:lab_cg/domain/user.dart';
import 'package:lab_cg/data/repositories/user_repository.dart';

class SaveUserProfile {
  final UserRepository repository;

  SaveUserProfile(this.repository);

  // Future<void> call(UserProfile user) async {
  //   await repository.saveUserProfile(user);
  // }
}
