import 'package:lab_cg/domain/service.dart';

abstract class ServiceDataSource {
  // Future<void> crearExamen(Service examen);
  Future<Service> getServiceByUid(String uid);
  // Future<Service?> obtenerExamenPorUuid(String uuid);
  // Future<void> eliminarExamen(String uuid);
}
