class CitaLaboratorio {
  final int id;
  final String uid;
  final String nombrePaciente; //un id del paciente
  final String tipoCita; //id de servicio
  //fecha de creacion =>created_at | updated_at
  final DateTime fecha; //fecha en que se agendò la cita
  final String hora; //hora de la cita
  final String address;
  final String estado; //pendiente o completada

  CitaLaboratorio({
    required this.id,
    required this.uid,
    required this.nombrePaciente,
    required this.tipoCita,
    required this.fecha,
    required this.hora,
    required this.address,
    required this.estado,
  });
}
