import 'package:lab_cg/domain/citas.dart';
import 'package:lab_cg/data/repositories/cita_repository.dart';

class LocalCitaDataSource implements CitaRepository {
  @override
  Future<void> agendarCita(CitaLaboratorio cita) async {
    await Future.delayed(const Duration(seconds: 1));
    print('Cita agendada: ${cita.nombrePaciente} - ${cita.tipoCita} - ${cita.fecha} ${cita.hora}');
  }
}
