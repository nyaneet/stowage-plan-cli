import 'package:stowage_plan/models/stowage/stowage_collection.dart';
///
/// Operation to execute with stowage collection.
abstract interface class StowageOperation {
  ///
  /// Execute operation with given [stowageCollection].
  void execute(StowageCollection stowageCollection);
}
