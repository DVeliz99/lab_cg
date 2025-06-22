import 'failure.dart';

class Result<T> {
  final T? data;
  final Failure? failure;

  Result._(this.data, this.failure);

  factory Result.success(T data) => Result._(data, null);
  factory Result.failure(Failure failure) => Result._(null, failure);

  bool get isSuccess => data != null;
  bool get isFailure => failure != null;
}
