import 'package:lab_cg/core/failure.dart';
import 'package:lab_cg/core/result.dart';
import 'package:lab_cg/domain/user.dart';
import '/data/repositories/user_repository.dart';
import '/domain/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class GetUserByUidUseCase {
  final UserRepository repository;

  GetUserByUidUseCase(this.repository);

  //Devuelve un tipo User
  Future<Result<AppUser>> call(String uid) async {
    if (uid != '') {
      try {
        final user = await repository.getUserByUid(uid);
        return Result.success(user!);
      } catch (e) {
        return Result.failure(AuthFailure(e.toString()));
      }
    }
    return Result.failure(AuthFailure('Hubo error de autenticación'));
  }
}

class SetNotificationUseCase {
  final UserRepository repository;

  SetNotificationUseCase(this.repository);

  //Devuelve un tipo User
  Future<Result<AppUser>> call(String uid, bool value) async {
    if (uid != '') {
      try {
        final user = await repository.setNotification(uid, value);
        return Result.success(user);
      } catch (e) {
        return Result.failure(AuthFailure(e.toString()));
      }
    }
    return Result.failure(AuthFailure('Hubo error de autenticación'));
  }
}

class SetContactMethodUseCase {
  final UserRepository repository;

  SetContactMethodUseCase(this.repository);

  //Devuelve un tipo User
  Future<Result<AppUser>> call(String uid, String contactMethod) async {
    if (uid != '') {
      try {
        final user = await repository.setContactMethod(uid, contactMethod);
        return Result.success(user);
      } catch (e) {
        return Result.failure(AuthFailure(e.toString()));
      }
    }
    return Result.failure(AuthFailure('Hubo error de autenticación'));
  }
}
