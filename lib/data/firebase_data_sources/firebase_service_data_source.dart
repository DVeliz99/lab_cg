import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_cg/data/data_sources/service_data_source.dart';
import 'package:lab_cg/domain/service.dart';

class FirebaseServiceDataSource implements ServiceDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Service> getServiceByUid(String uid) async {
    try {
      final docRef = _firestore.collection('services').doc(uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return Service.fromJson(data);
        } else {
          throw Exception('El documento con ID $uid no tiene datos.');
        }
      } else {
        throw Exception('No existe un servicio con el ID: $uid');
      }
    } catch (e) {
      print('Error al obtener el servicio con ID $uid: $e');
      throw Exception('Error al obtener el servicio con ID $uid: $e');
    }
  }
}
