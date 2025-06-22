import 'package:lab_cg/domain/auth.dart';
import 'package:lab_cg/domain/user.dart';

abstract class UserDataSource {
  // Future<List<User>> getUsers();
  Future<AppUser?> getUserByUid(String id);
  /*Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(int id);*/
}


/*solicitudes a firebase */

// class FirebaseUserDataSource implements UserDataSource{

//   final FirebaseFirestore firestore;

//   FirebaseUserDataSource({required this.firestore});

//    @override
//   Future<List<User>> getUsers() async {
//     final snapshot = await firestore.collection('users').get();
//     return snapshot.docs
//         .map((doc) => User.fromJson(doc.data(), doc.id))
//         .toList();
//   }
// }