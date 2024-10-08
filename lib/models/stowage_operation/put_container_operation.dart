import 'package:stowage_plan/core/failure.dart';
import 'package:stowage_plan/core/result.dart';
import 'package:stowage_plan/models/stowage_operation/stowage_operation.dart';
import 'package:stowage_plan/models/container/container.dart';
import 'package:stowage_plan/models/stowage_collection/stowage_collection.dart';
///
/// Operation that puts container to stowage slot
/// at specified position.
class PutContainerOperation implements StowageOperation {
  /// The container to be put to stowage slot.
  final Container _container;
  /// Bay number of slot where container should be put.
  final int _bay;
  /// Row number of slot where container should be put.
  final int _row;
  /// Tier number of slot where container should be put.
  final int _tier;
  ///
  /// Creates operation that puts the given [container] to stowage slot
  /// at specified position.
  ///
  /// The [bay], [row], and [tier] parameters specify location of slot.
  const PutContainerOperation({
    required Container container,
    required int bay,
    required int row,
    required int tier,
  })  : _container = container,
        _bay = bay,
        _row = row,
        _tier = tier;
  ///
  /// Puts container to slot at specified position in [stowageCollection].
  ///
  /// If container is added, new slot for upper tier is created
  /// and added to [stowageCollection], if possible (e.g., new slot does not exceed
  /// its maximum height).
  ///
  /// Returns [Ok] if container successfully added to [stowageCollection],
  /// and [Err] otherwise.
  @override
  ResultF<void> execute(StowageCollection stowageCollection) {
    // Find and update specified slot if exists
    final existingSlot = stowageCollection.findSlot(_bay, _row, _tier);
    if (existingSlot == null) {
      return Err(Failure(
        message: 'Slot not found',
        stackTrace: StackTrace.current,
      ));
    }
    final updatedSlot = existingSlot.withContainer(_container);
    if (updatedSlot == null) {
      return Err(Failure(
        message: 'Slot already occupied',
        stackTrace: StackTrace.current,
      ));
    }
    stowageCollection.addSlot(updatedSlot);
    // Add new slot for upper tier if possible
    final upperSlot = updatedSlot.createUpperSlot();
    if (upperSlot == null) {
      return Err(Failure(
        message: 'Cannot create upper slot, it exceeds maximum height',
        stackTrace: StackTrace.current,
      ));
    }
    stowageCollection.addSlot(upperSlot);
    return Ok(null);
  }
}
