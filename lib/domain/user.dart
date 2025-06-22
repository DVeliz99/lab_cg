class AppUser {
  String? uid;
  String? nombre;
  String? rol;

  AppUser({this.uid, this.nombre, this.rol});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(uid: json['uid'], nombre: json['nombre'], rol: json['rol']);
  }

  //Convierte a string la instancia AppUser
  @override
  String toString() {
    return 'AppUser(uid: $uid, nombre: $nombre, rol: $rol)';
  }
}
