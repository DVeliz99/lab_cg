import 'package:lab_cg/domain/result.dart';

abstract class ResultRepository {
  Future<Result?> getResultByUserUid(String uid);
}


