import 'package:lab_cg/core/failure.dart';
import 'package:lab_cg/core/result.dart';
import 'package:lab_cg/domain/citas.dart';
import 'package:lab_cg/data/repositories/cita_repository.dart';

class AgendarCita {
  final CitaRepository repository;

  AgendarCita(this.repository);

  Future<void> call(CitaLaboratorio cita) async {
    await repository.agendarCita(cita);
  }
}

class GetCitaFromUserIdUseCase {
  final CitaRepository repository;

  GetCitaFromUserIdUseCase(this.repository);

  //Devuelve un tipo Cita
  Future<Result<CitaLaboratorio>> call(String uid) async {
    if (uid != '') {
      try {
        final cita = await repository.getCitaFromUserId(uid);
        return Result.success(cita!);
      } catch (e) {
        return Result.failure(AuthFailure(e.toString()));
      }
    }
    return Result.failure(AuthFailure('Hubo error de autenticación'));
  }
}
