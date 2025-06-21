import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/data/repositories/profile_repository.dart';
import 'package:lab_cg/data/data_sources/profile_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<void> saveProfile(Profile profile) async {
    await dataSource.saveProfile(profile);
  }
}
