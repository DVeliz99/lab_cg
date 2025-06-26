import 'package:lab_cg/domain/profile.dart';

abstract class ProfileRepository {
  Future<void> saveProfile(Profile profile);
  Future<Profile?> getProfile();
}
