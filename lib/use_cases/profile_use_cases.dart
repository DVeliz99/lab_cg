import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/core/result.dart';
import 'package:lab_cg/core/failure.dart';
import 'package:lab_cg/data/repositories/profile_repository.dart';

class SaveProfile {
  final ProfileRepository repository;

  SaveProfile(this.repository);

  Future<void> call(Profile profile) async {
    await repository.saveProfile(profile);
  }
}

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Result<Profile>> call() async {
    try {
      final profile = await repository.getProfile();
      if (profile != null) {
        return Result.success(profile);
      } else {
        return Result.failure(ProfileFailure("Perfil no encontrado"));
      }
    } catch (e) {
      return Result.failure(ProfileFailure(e.toString()));
    }
  }
}

// Optional: Create a specific failure if needed
class ProfileFailure extends Failure {
  ProfileFailure(super.message);
}
