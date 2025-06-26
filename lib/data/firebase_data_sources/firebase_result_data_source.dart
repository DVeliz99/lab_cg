import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_cg/data/data_sources/result_data_source.dart';
import 'package:lab_cg/domain/result.dart';
import 'package:lab_cg/domain/parameter_result.dart';

class FirebaseResultDataSource implements ResultDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result?> getResultbyCitaUid(String citaUid) async {
    print('El cita uid es $citaUid para hacer consulta');
    try {
      final docSnapshot =
          await _firestore.collection('results').doc(citaUid).get();

      if (docSnapshot.exists) {
        print("📄 Resultado obtenido: ${docSnapshot.data()}");
        return Result.fromMap(docSnapshot.data()!, docSnapshot.id);
      } else {
        print("⚠️ No se encontró resultado con citaUid: $citaUid");
        return null;
      }
    } catch (e) {
      print('❌ Error al obtener resultado por citaUid: $e');
      return null;
    }
  }

  @override
  Future<List<dynamic>> getSubcollectionParameters(
    String resultUid,
    String serviceUid,
  ) async {
    print('uid_service para consultar en firebase $serviceUid');
    print('resultUid para consultar en firebase $resultUid');
    try {
      final snapshot =
          await _firestore
              .collection('results')
              .doc(resultUid)
              .collection(serviceUid)
              .get();

      final entries =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return {'id': doc.id, 'value': data['value']};
          }).toList();

      print('entries $entries');

      return entries;
    } catch (e) {
      print('❌ Error al obtener parámetros de la subcolección: $e');
      return [];
    }
  }
}



/*un metodo para obtener el resultado, un metodo para obtener los valores de set_value de la
coleccion parametros.
Una consulta que con el uid obtenido de la pantalla historial se obtenga el resultado (metodo)
obteniendo el resultado de firebase se obtiene tambien el uid del servicio con el que se va a obtener
el nombre del servicio, el resultado obtenido de firebase contiene el uid de los parametos junto con
sus valores y los uid de los parametros seran utilizados para obtener los valores set_value de cada
parametro

 */