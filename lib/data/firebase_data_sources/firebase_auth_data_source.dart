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
        return Auth(
          uid: user.uid,
          nombreUsuario: user.email ?? 'usuario_sin_email',
          displayname: user.displayName,
        );
      } else {
        throw Exception('No user signed in');
      }
    } catch (e) {
      throw Exception('Error getting current user: $e');
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
        return Auth(
          uid: user.uid,
          nombreUsuario: user.email ?? 'usuario_sin_email',
          displayname: user.displayName,
        );
      } else {
        throw Exception('Login failed');
      }
    } on FirebaseAuthException catch (e) {
      // Aquí capturas los errores específicos de autenticación Firebase
      throw Exception('FirebaseAuthException: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error during login: $e');
    }
  }
}
