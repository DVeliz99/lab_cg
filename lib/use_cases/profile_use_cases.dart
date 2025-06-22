import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/data/repositories/profile_repository.dart';

class SaveProfile {
  final ProfileRepository repository;

  SaveProfile(this.repository);

  Future<void> call(Profile profile) async {
    await repository.saveProfile(profile);
  }
}
