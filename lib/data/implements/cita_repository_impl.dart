import 'package:lab_cg/data/repositories/cita_repository.dart';
import 'package:lab_cg/domain/citas.dart';
import 'package:lab_cg/data/data_sources/cita_data_source.dart';

class CitasRepositoryImpl implements CitaRepository {
  final CitaDataSource dataSource;

  CitasRepositoryImpl(this.dataSource);
  @override
  Future<void> agendarCita(CitaLaboratorio cita) {
    return dataSource.agendarCita(cita);
  }

  @override
  Future<CitaLaboratorio?> getCitaFromUserId(String uid) {
    return dataSource.getCitaFromUserId(uid);
  }
}
