import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/data/repositories/profile_repository.dart';

class DataProfile implements ProfileRepository {
  final List<Profile> _profiles = [];

  @override
  Future<void> saveProfile(Profile profile) async {
    _profiles.clear();
    _profiles.add(profile);
  }

  Profile? getProfile() {
    if (_profiles.isEmpty) return null;
    return _profiles.first;
  }
}
