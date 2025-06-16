import 'package:lab_cg/domain/service.dart';
import 'package:lab_cg/data/data_sources/service_data_source.dart';
import '../repositories/service_respository.dart';


class ExamenRepositoryImpl implements ExamenRepository {
  final ExamenDataSource dataSource;

  ExamenRepositoryImpl(this.dataSource);

  @override
  Future<void> crearExamen(ExamenLaboratorio examen) {
    return dataSource.crearExamen(examen);
  }

  @override
  Future<List<ExamenLaboratorio>> obtenerExamenes() {
    return dataSource.obtenerExamenes();
  }

  @override
  Future<ExamenLaboratorio?> obtenerExamenPorUuid(String uuid) {
    return dataSource.obtenerExamenPorUuid(uuid);
  }

  @override
  Future<void> eliminarExamen(String uuid) {
    return dataSource.eliminarExamen(uuid);
  }
}
