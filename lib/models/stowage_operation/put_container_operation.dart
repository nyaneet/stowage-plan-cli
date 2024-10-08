import 'package:stowage_plan/core/failure.dart';
import 'package:stowage_plan/core/result.dart';
import 'package:stowage_plan/core/result_extension.dart';
import 'package:stowage_plan/models/slot/slot.dart';
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
  /// The [bay], [row] and [tier] numbers specify location of slot.
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
    return _findSlot(_bay, _row, _tier, stowageCollection).bind(
      (slot) {
        return slot.withContainer(_container);
      },
    ).map(
      (existingSlot) {
        stowageCollection.addSlot(existingSlot);
        return existingSlot;
      },
    ).bind(
      (slotWithContainer) {
        return slotWithContainer.createUpperSlot();
      },
    ).map(
      (upperSlot) {
        stowageCollection.addSlot(upperSlot);
      },
    );
  }
  ///
  /// Find slot in specified position.
  ///
  /// Returns [Ok] with slot if found, and [Err] otherwise.
  ResultF<Slot> _findSlot(
    int bay,
    int row,
    int tier,
    StowageCollection stowageCollection,
  ) {
    final existingSlot = stowageCollection.findSlot(bay, row, tier);
    if (existingSlot == null) {
      return Err(Failure(
        message: 'Slot to put container not found',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(existingSlot);
  }
}
