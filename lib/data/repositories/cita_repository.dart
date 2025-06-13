import 'package:lab_cg/domain/citas.dart';

abstract class CitaRepository {
  Future<void> agendarCita(CitaLaboratorio cita);


}


