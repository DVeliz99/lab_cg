import 'package:lab_cg/domain/service.dart';

abstract class ExamenDataSource {
  Future<void> crearExamen(ExamenLaboratorio examen);
  Future<List<ExamenLaboratorio>> obtenerExamenes();
  Future<ExamenLaboratorio?> obtenerExamenPorUuid(String uuid);
  Future<void> eliminarExamen(String uuid);
}
