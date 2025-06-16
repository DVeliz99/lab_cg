import 'package:lab_cg/domain/citas.dart';
import 'package:lab_cg/data/repositories/cita_repository.dart';

class AgendarCita {
  final CitaRepository repository;

  AgendarCita(this.repository);

  Future<void> call(CitaLaboratorio cita) async {
    await repository.agendarCita(cita);
  }
}

