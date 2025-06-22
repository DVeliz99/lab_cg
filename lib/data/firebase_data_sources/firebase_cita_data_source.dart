import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:lab_cg/data/data_sources/cita_data_source.dart';
import 'package:lab_cg/domain/citas.dart';

class FirebaseCitaDataSource implements CitaDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<CitaLaboratorio?> getCitaFromUserId(String uidUser) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('appoinments')
              .where('uid_user', isEqualTo: uidUser)
              .orderBy('created_at', descending: true)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return CitaLaboratorio.fromMap(doc.data(), doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener la cita: $e');
      return null;
    }
  }

  @override
  Future<void> agendarCita(CitaLaboratorio cita) async {
    try {
      await _firestore.collection('appoinments').add({
        'uid': '',
        'address': '',
        'requested': '',
        'hora': '',
        'active': true,
      });
    } catch (e) {
      throw Exception('Error al guardar la cita en Firebase: $e');
    }
  }
}
