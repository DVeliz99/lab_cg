// para inicio de sesión

class Auth {
  String? uid;
  //id_usuario
  String email;
  String? password;

  Auth({this.uid, required this.email, this.password});

  //Convierte a string la instancia Auth
  @override
  String toString() {
    return 'Auth(uid: $uid, email: $email)';
  }
}
