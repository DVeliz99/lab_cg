import 'package:firebase_auth/firebase_auth.dart';
import '/domain/auth.dart';
import '../data_sources/auth_data_source.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      // Maneja errores si quieres o simplemente relanza
      throw Exception('Error during logout: $e');
    }
  }

  @override
  Future<Auth> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return Auth(uid: user.uid, email: user.email ?? '');
      } else {
        throw Exception('No hay usuario autenticado');
      }
    } catch (e) {
      throw Exception('Hubo un error al obtener el usuario autenticado: $e');
    }
  }

  @override
  Future<Auth> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        return Auth(uid: user.uid, email: user.email ?? '');
      } else {
        throw Exception('Login failed: Usuario no encontrado');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('FirebaseAuthException: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido durante login: $e');
    }
  }
}
