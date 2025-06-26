class AppUser {
  String? uid;
  String? nombre;
  String? rol;
  String? contactMethod;
  bool? notifications;

  AppUser({
    this.uid,
    this.nombre,
    this.rol,
    this.contactMethod,
    this.notifications,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      nombre: json['nombre'],
      rol: json['rol'],
      contactMethod: json['contact_method'],
      notifications: json['notifications'],
    );
  }

  //Convierte a string la instancia AppUser
  @override
  String toString() {
    return 'AppUser(uid: $uid, nombre: $nombre, rol: $rol,contact_method: $contactMethod, notifications: $notifications)';
  }
}
