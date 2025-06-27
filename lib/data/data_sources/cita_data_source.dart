import 'package:lab_cg/domain/citas.dart';

abstract class CitaDataSource {
  Future<CitaLaboratorio?> getCitaFromUserId(String id);
  Future<void> agendarCita(CitaLaboratorio cita);

  //  Future<void> agendarCita(CitaLaboratorio cita) async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   print(
  //     'Cita agendada: ${cita.uidUser} - ${cita.uidService} - ${cita.requestedAt} ${cita.hora}',
  //   );
  // }
}
