///
/// Basic failure with chaining support.
abstract interface class Failure implements Exception {
  ///
  String get message;
  ///
  StackTrace get stackTrace;
  ///
  Failure? get innerFailure;
  ///
  const factory Failure({
    required String message,
    required StackTrace stackTrace,
  }) = _Failure;
  ///
  factory Failure.withInnerFailure({
    required String message,
    required StackTrace stackTrace,
    required Failure innerFailure,
  }) = _WithInnerFailure;
  //
  @override
  String toString();
}
///
class _Failure implements Failure {
  //
  @override
  final String message;
  //
  @override
  final StackTrace stackTrace;
  //
  @override
  final Failure? innerFailure = null;
  ///
  const _Failure({
    required this.message,
    required this.stackTrace,
  });
  //
  @override
  String toString() {
    return 'Failure: $message';
  }
}
///
class _WithInnerFailure implements Failure {
  //
  @override
  final String message;
  //
  @override
  final StackTrace stackTrace;
  //
  @override
  final Failure innerFailure;
  ///
  _WithInnerFailure({
    required this.message,
    required this.stackTrace,
    required Failure innerFailure,
  }) : innerFailure = innerFailure.innerFailure != null
            ? _WithInnerFailure(
                message: message,
                stackTrace: StackTrace.empty,
                innerFailure: innerFailure,
              )
            : _Failure(
                message: message,
                stackTrace: StackTrace.empty,
              );
  //
  @override
  String toString() {
    final innerFailureString = '\n\tInnerFailure: ${innerFailure.toString()}';
    return 'Failure: $message$innerFailureString';
  }
}
