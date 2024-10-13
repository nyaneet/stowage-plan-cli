import 'package:stowage_plan/core/result.dart';
///
extension Boolean<V, E> on Result<V, E> {
  ///
  Result<U, E> and<U>(Result<U, E> result) {
    return switch (this) {
      Ok() => result,
      Err(:final error) => Err(error),
    };
  }
  ///
  Result<U, E> andThen<U>(Result<U, E> Function(V value) f) {
    return switch (this) {
      Ok(:final value) => f(value),
      Err(:final error) => Err(error),
    };
  }
  ///
  Result<V, E> or(Result<V, E> result) {
    return switch (this) {
      Ok(:final value) => Ok(value),
      Err() => result,
    };
  }
  ///
  Result<V, E> orElse(Result<V, E> Function(E error) f) {
    return switch (this) {
      Ok(:final value) => Ok(value),
      Err(:final error) => f(error),
    };
  }
}
///
extension Querying<V, E> on Result<V, E> {
  ///
  bool isOk() {
    return switch (this) {
      Ok() => true,
      Err() => false,
    };
  }
  ///
  bool isOkAnd(bool Function(V value) f) {
    return switch (this) {
      Ok(:final V value) => f(value),
      Err() => false,
    };
  }
  ///
  bool isErr() {
    return switch (this) {
      Ok() => false,
      Err() => true,
    };
  }
  ///
  bool isErrAnd(bool Function(E error) f) {
    return switch (this) {
      Ok() => false,
      Err(:final E error) => f(error),
    };
  }
}
///
extension Transform<V, E> on Result<V, E> {
  ///
  Result<U, E> map<U>(U Function(V value) op) {
    return switch (this) {
      Ok(:final V value) => Ok(op(value)),
      Err(:final E error) => Err(error),
    };
  }
  ///
  U mapOr<U>(U d, U Function(V value) f) {
    return switch (this) {
      Ok(:final V value) => f(value),
      Err() => d,
    };
  }
  ///
  U mapOrElse<U>(U Function(E value) d, U Function(V value) f) {
    return switch (this) {
      Ok(:final V value) => f(value),
      Err(:final E error) => d(error),
    };
  }
  ///
  Result<V, E> inspect(Function(V value) f) {
    if (this case Ok(:final value)) {
      f(value);
    }
    return this;
  }
  ///
  Result<V, E> inspectErr(Function(E error) f) {
    if (this case Err(:final error)) {
      f(error);
    }
    return this;
  }
}
///
extension Extract<V, E> on Result<V, E> {
  ///
  V unwrapOr(V d) {
    return switch (this) {
      Ok(:final V value) => value,
      Err() => d,
    };
  }
  ///
  V unwrapOrElse(V Function(E error) d) {
    return switch (this) {
      Ok(:final V value) => value,
      Err(:final E error) => d(error),
    };
  }
  ///
  E unwrapErrOr(E d) {
    return switch (this) {
      Ok() => d,
      Err(:final E error) => error,
    };
  }
  ///
  E unwrapErrOrElse(E Function(V value) d) {
    return switch (this) {
      Ok(:final V value) => d(value),
      Err(:final E error) => error,
    };
  }
}
