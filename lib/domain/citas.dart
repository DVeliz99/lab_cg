
class CitaLaboratorio {
  final int id;                      // ID interno de la cita
  final String uid;                  // UID único de la cita
  final String nombrePaciente;       // Nombre del paciente
  final String tipoCita;             // Tipo de cita o examen
  final DateTime fecha;              // Fecha seleccionada
  final String hora;                 // Hora seleccionada
  final String direccion;            // Dirección del domicilio
  final String estado;               // Estado: pendiente, confirmada, etc.

  CitaLaboratorio({
    required this.id,
    required this.uid,
    required this.nombrePaciente,
    required this.tipoCita,
    required this.fecha,
    required this.hora,
    required this.direccion,
    required this.estado,
  });
}
