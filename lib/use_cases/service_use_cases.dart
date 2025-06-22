import 'package:lab_cg/core/failure.dart';
import 'package:lab_cg/core/result.dart';
import 'package:lab_cg/domain/service.dart';
import '/data/repositories/service_repository.dart';

class GetServiceByUid {
  final ServiceRepository repository;

  GetServiceByUid(this.repository);

  //Devuelve un tipo User
  Future<Result<Service>> call(String uid) async {
    if (uid != '') {
      try {
        final service = await repository.getServiceByUid(uid);
        return Result.success(service);
      } catch (e) {
        return Result.failure(AuthFailure(e.toString()));
      }
    }
    return Result.failure(AuthFailure('Hubo error de autenticación'));
  }
}
