import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/data/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRepository dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<void> saveProfile(Profile profile) {
    return dataSource.saveProfile(profile);
  }

  @override
  Future<Profile?> getProfile() {
    return dataSource.getProfile();
  }
}
