class User {
  int? id;
  String? uuid;
  String? nombreUsuario;
  String? password;
  String? rol;

  User({this.id, this.uuid, this.nombreUsuario, this.password, this.rol});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    nombreUsuario = json['nombre_usuario'];
    password = json['constraseña'];
    rol = json['rol'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'nombre_usuario': nombreUsuario,
      'password': password,
      'rol': rol,
    };
  }
}

class UserProfile {
  final String nombre;
  final String sexo;
  final int edad;
  final double altura;
  final double peso;
  final String tipoSangre;
  final String telefono;
  final String correo;
  final String direccion;

  UserProfile({
    required this.nombre,
    required this.sexo,
    required this.edad,
    required this.altura,
    required this.peso,
    required this.tipoSangre,
    required this.telefono,
    required this.correo,
    required this.direccion,
  });
}
