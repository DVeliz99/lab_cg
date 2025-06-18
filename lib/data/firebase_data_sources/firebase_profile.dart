import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/data/repositories/profile_repository.dart';

class FirebaseProfileDataSource implements ProfileRepository {
  @override
  Future<void> saveProfile(Profile profile) async {
    // Aquí se puede integrar Firebase o cualquier otro backend
    print('Guardando perfil de usuario: ${profile.name}');
  }
}
