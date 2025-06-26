import 'package:lab_cg/domain/result.dart';
import 'package:lab_cg/data/repositories/result_repository.dart';

class GetResultByCitaUidUseCase {
  final ResultRepository repository;

  GetResultByCitaUidUseCase(this.repository);

  Future<Result?> call(String uid) async {
    try {
      return await repository.getResultbyCitaUid(uid);
    } catch (e) {
      print('Error al obtener resultado: $e');
      return null;
    }
  }
}
