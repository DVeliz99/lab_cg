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
