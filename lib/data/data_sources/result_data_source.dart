import 'package:lab_cg/domain/result.dart';

abstract class ResultDataSource {
  Future<Result?> getResultbyCitaUid(String citaUid);
}
