//mport 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_cg/domain/citas.dart';
import 'package:lab_cg/data/repositories/cita_repository.dart';

/*class FirebaseCitaDataSource implements CitaRepository {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> agendarCita(CitaLaboratorio cita) async {
    try {
      await _firestore.collection('citas').add({
        'uid': cita.uid,
        'nombrePaciente': cita.nombrePaciente,
        'tipoCita': cita.tipoCita,
        'fecha': cita.fecha.toIso8601String(),
        'hora': cita.hora,
        'direccion': cita.direction,
        'estado': cita.estado,
      });
    } catch (e) {
      throw Exception('Error al guardar la cita en Firebase: $e');
    }
  }
}*/
