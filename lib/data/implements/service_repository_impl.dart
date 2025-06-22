import 'package:lab_cg/domain/service.dart';
import 'package:lab_cg/data/data_sources/service_data_source.dart';
import '../repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceDataSource dataSource;

  ServiceRepositoryImpl(this.dataSource);

  // @override
  // Future<void> crearExamen(Service examen) {
  //   return dataSource.crearExamen(examen);
  // }

  @override
  Future<Service> getServiceByUid(String uid) {
    return dataSource.getServiceByUid(uid);
  }

  // @override
  // Future<void> eliminarExamen(String uuid) {
  //   return dataSource.eliminarExamen(uuid);
  // }
}
