import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  Future<AppUser> setNotification(String uid, bool value) async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users');

      await usersRef.doc(uid).update({'notifications': value});

      print('Notificación cambiad a $value para el usuario $uid');

      final doc = await usersRef.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return AppUser.fromJson(doc.data()!);
      } else {
        throw Exception(
          'Usuario no encontrado después de activar la notificación.',
        );
      }
    } catch (e) {
      print('Error al activar la notificación: $e');
      throw Exception('Error al activar la notificación: $e');
    }
  }

  @override
  Future<AppUser> setContactMethod(String uid, String contactMethod) async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users');

      await usersRef.doc(uid).update({'contact_Method': contactMethod});

      print('Método de contacto actualizado para el usuario $uid');

      final doc = await usersRef.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return AppUser.fromJson(doc.data()!);
      } else {
        throw Exception(
          'Usuario no encontrado después de actualizar el método de contacto.',
        );
      }
    } catch (e) {
      print('Error al actualizar el método de contacto: $e');
      throw Exception('Error al actualizar el método de contacto: $e');
    }
  }
}
