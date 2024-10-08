import 'package:stowage_plan/core/result.dart';
///
extension ResultFExtension<V> on ResultF<V> {
  ///
  ResultF<N> bind<N>(ResultF<N> Function(V value) f) {
    return switch (this) {
      Ok(:final value) => f(value),
      Err(:final error) => Err(error),
    };
  }
  ///
  ResultF<N> map<N>(N Function(V value) f) {
    return switch (this) {
      Ok(:final value) => Ok(f(value)),
      Err(:final error) => Err(error),
    };
  }
}
