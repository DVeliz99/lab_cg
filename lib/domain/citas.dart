import 'package:cloud_firestore/cloud_firestore.dart';

class CitaLaboratorio {
  final String? uid;
  final String uidUser; //un id del paciente
  final String uidService; //id de servicio
  //fecha de creacion =>created_at | updated_at
  final DateTime requestedAt; //fecha en que se agendò la cita
  final String hora; //hora de la cita
  final String address;
  final bool active; //pendiente o completada

  CitaLaboratorio({
    this.uid,
    required this.uidUser,
    required this.uidService,
    required this.requestedAt,
    required this.hora,
    required this.address,
    required this.active,
  });

  factory CitaLaboratorio.fromMap(Map<String, dynamic> map, String uid) {
    return CitaLaboratorio(
      uid: uid,
      uidUser: map['uid_user'] ?? '',
      uidService: map['uid_service'] ?? '',
      requestedAt: (map['created_at'] as Timestamp).toDate(),
      hora: map['hora'] ?? '',
      address: map['address'] ?? '',
      active: map['active'] ?? false,
    );
  }

  @override
  String toString() {
    return 'CitaLaboratorio(uid: $uid, uidUser: $uidUser, uidService: $uidService, requestedAt: $requestedAt, hora: $hora, address: $address, active: $active)';
  }
}
