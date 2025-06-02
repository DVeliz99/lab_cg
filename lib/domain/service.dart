/*nombre,id, uuid, precio,cod, tipo, fecha creación?, fecha solicitada?, hora solicitada?, categoria, creado por?, descripcion */

/*id,uid,fecha, cod, hora  => para poder obtener las fechas y horas disponibles de los examenes*/

class ExamenLaboratorio {
  final int id;
  final String uuid;
  final String nombre;
  final double precio;
  final String cod;
  final String tipo;
  final DateTime? fechaCreacion;
  final DateTime? fechaSolicitada;
  final String? horaSolicitada;
  final String categoria;
  final String? creadoPor;
  final String descripcion;

  ExamenLaboratorio({
    required this.id,
    required this.uuid,
    required this.nombre,
    required this.precio,
    required this.cod,
    required this.tipo,
    this.fechaCreacion,
    this.fechaSolicitada,
    this.horaSolicitada,
    required this.categoria,
    this.creadoPor,
    required this.descripcion,
  });
}
