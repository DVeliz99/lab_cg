

import 'package:lab_cg/domain/result.dart';
import 'package:lab_cg/data/repositories/result_repository.dart';

class GetResultByUserUidUseCase {
  final ResultRepository repository;

  GetResultByUserUidUseCase(this.repository);

  Future<Result?> call(String uid) async {
    try {
      return await repository.getResultByUserUid(uid);
    } catch (e) {
      print('Error al obtener resultado: $e');
      return null;
    }
  }
}
