import 'package:lab_cg/domain/result.dart';
import 'package:lab_cg/data/data_sources/result_data_source.dart';
import 'package:lab_cg/data/repositories/result_repository.dart';

class ResultRepositoryImpl implements ResultRepository {
  final ResultDataSource dataSource;

  ResultRepositoryImpl(this.dataSource);

  @override
  Future<Result?> getResultByUserUid(String uid) {
    return dataSource.getResultByUserUid(uid);
  }
}
