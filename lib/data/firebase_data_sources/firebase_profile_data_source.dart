import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/data/repositories/profile_repository.dart';

class FirebaseProfileDataSource implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }
    return user.uid;
  }

  final String _collection = 'profile';

  @override
  Future<void> saveProfile(Profile profile) async {
    final uid = _userId;
    await _firestore.collection(_collection).doc(uid).set({
      'name': profile.name,
      'gender': profile.gender,
      'age': profile.age,
      'height': profile.height,
      'weight': profile.weight,
      'blood_type': profile.bloodType,
      'phone': profile.phone,
      'email': profile.email,
      'address': profile.address,
    });
  }

  @override
  Future<Profile?> getProfile() async {
    final uid = _userId;
    final doc = await _firestore.collection(_collection).doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      return Profile(
        name: data['name'] ?? '',
        gender: data['gender'] ?? 'Masculino',
        age: (data['age'] as num?)?.toInt() ?? 0,
        height: (data['height'] as num?)?.toDouble() ?? 0.0,
        weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
        bloodType: data['blood_type'] ?? 'A+',
        phone: data['phone'] ?? '',
        email: data['email'] ?? '',
        address: data['address'] ?? '',
      );
    }
    return null;
  }
}
