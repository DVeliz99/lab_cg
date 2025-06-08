import '/domain/auth.dart';

abstract class AuthDataSource {
  Future<void> logout();
  Future<Auth> getCurrentUser();
  Future<Auth> login(String email, String password);
}


// class FirebaseAuthDataSource implements AuthDataSource {
//   final FirebaseAuth _firebaseAuth;

//   FirebaseAuthDataSource(this._firebaseAuth);

//   @override
//   Future<void> logout() async {
//     await _firebaseAuth.signOut();
//   }
// }