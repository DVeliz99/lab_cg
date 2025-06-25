import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_cg/data/data_sources/result_data_source.dart';
import 'package:lab_cg/domain/result.dart';
import 'package:lab_cg/domain/parameter_result.dart';

class FirebaseResultDataSource implements ResultDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result?> getResultByUserUid(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('results')
          .where('uid_user', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        print("📄 Resultado obtenido: ${doc.data()}");
        return Result.fromMap(doc.data(), doc.id);
      } else {
        print("⚠️ No se encontró resultado con uid_user: $uid");
        return null;
      }
    } catch (e) {
      print('❌ Error al obtener resultado por UID: $e');
      return null;
    }
  }

  @override
  Future<List<ParameterResult>> getSubcollectionParameters(
      String resultUid, String serviceUid) async {
    try {
      final snapshot = await _firestore
          .collection('results')
          .doc(resultUid)
          .collection(serviceUid)
          .doc(resultUid)
          .collection('parametros')
          .get();

      print("📥 Parámetros encontrados: ${snapshot.docs.length}");
      for (var doc in snapshot.docs) {
        print("📄 Param: ${doc.data()}");
      }

      return snapshot.docs
          .map((doc) => ParameterResult.fromMap(doc.data()))
          .toList();
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