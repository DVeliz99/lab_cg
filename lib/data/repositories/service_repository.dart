import 'package:lab_cg/domain/service.dart';

abstract class ServiceRepository {
  // Future<void> crearExamen(Service examen);
  // Future<List<Service>> obtenerExamenes();
  Future<Service> getServiceByUid(String uid);
  // Future<void> eliminarExamen(String uuid);
}
