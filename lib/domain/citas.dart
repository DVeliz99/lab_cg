
class CitaLaboratorio {
  final int id;
  final String uid;
  final String nombrePaciente;
  final String tipoCita;
  final DateTime fecha;
  final String hora;
  final String direction;
  final String estado;

  CitaLaboratorio({
    required this.id,
    required this.uid,
    required this.nombrePaciente,
    required this.tipoCita,
    required this.fecha,
    required this.hora,
    required this.direction,
    required this.estado,
  });
}
