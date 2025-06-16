import 'package:lab_cg/domain/service.dart';

abstract class ExamenRepository {
  Future<void> crearExamen(ExamenLaboratorio examen);
  Future<List<ExamenLaboratorio>> obtenerExamenes();
  Future<ExamenLaboratorio?> obtenerExamenPorUuid(String uuid);
  Future<void> eliminarExamen(String uuid);
}
