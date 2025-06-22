import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_cg/data/data_sources/user_data_source.dart';
import 'package:lab_cg/domain/user.dart';

class FirebaseUserDataSource implements UserDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getUserByUid(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        return AppUser.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener usuario por UID: $e');
      return null;
    }
  }
}
