import 'package:lab_cg/domain/profile.dart';

class ProfileDataSource {
  final List<Profile> _profiles = [];

  Future<void> saveProfile(Profile profile) async {
    _profiles.clear();
    _profiles.add(profile);
  }

  Profile? getProfile() {
    if (_profiles.isEmpty) return null;
    return _profiles.first;
  }

  Future<void> addNotification(String uid) {
    // TODO: implement addNotification
    throw UnimplementedError();
  }
}
