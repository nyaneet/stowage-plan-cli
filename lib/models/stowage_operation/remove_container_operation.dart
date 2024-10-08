import 'package:stowage_plan/core/failure.dart';
import 'package:stowage_plan/core/result.dart';
import 'package:stowage_plan/core/result_extension.dart';
import 'package:stowage_plan/models/slot/slot.dart';
import 'package:stowage_plan/models/stowage_operation/stowage_operation.dart';
import 'package:stowage_plan/models/stowage_collection/stowage_collection.dart';
///
/// Operation that removes container from stowage slot
/// at specified position.
class RemoveContainerOperation implements StowageOperation {
  /// Minimum possible tier number for hold.
  static const int _baseHoldTier = 2;
  /// Minimum possible tier number for deck.
  static const int _baseDeckTier = 80;
  /// Maximum possible tier number.
  static const int _maxTier = 98;
  /// Bay number of slot where container should be removed.
  final int _bay;
  /// Row number of slot where container should be removed.
  final int _row;
  /// Tier number of slot where container should be removed.
  final int _tier;
  ///
  /// Creates operation that removes the container from stowage slot
  /// at specified position.
  ///
  /// The [bay], [row] and [tier] numbers specify location of slot.
  const RemoveContainerOperation({
    required int bay,
    required int row,
    required int tier,
  })  : _bay = bay,
        _row = row,
        _tier = tier;
  ///
  /// Removes container from slot at specified position in [stowageCollection].
  ///
  /// If container is removed and specified slot is the uppermost existing slot
  /// in its hold or deck, then this slot and all empty slots below it,
  /// except the lowest one, are removed from the stowage plan.
  ///
  /// Returns [Ok] if container successfully removed from [stowageCollection],
  /// and [Err] otherwise.
  @override
  ResultF<void> execute(StowageCollection stowageCollection) {
    return _findSlot(_bay, _row, _tier, stowageCollection).bind(
      (existingSlot) {
        return existingSlot.empty();
      },
    ).map(
      (emptySlot) {
        stowageCollection.addSlot(emptySlot);
        return emptySlot;
      },
    ).bind(
      (updatedSlot) {
        return _clearDanglingSlots(updatedSlot, stowageCollection);
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
        message: 'Slot to remove container not found',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(existingSlot);
  }
  ///
  /// Removes all slots, in bay and row of given [slot]
  /// above which no occupied slots are found, except the lowest one,
  /// within the hold or deck.
  ResultF<void> _clearDanglingSlots(
    Slot slot,
    StowageCollection stowageCollection,
  ) {
    final maxTier = slot.tier < _baseDeckTier ? _baseDeckTier - 2 : _maxTier;
    final baseTier = slot.tier < _baseDeckTier ? _baseHoldTier : _baseDeckTier;
    for (int currentTier = maxTier; currentTier > baseTier; currentTier -= 2) {
      final currentSlot = stowageCollection.findSlot(_bay, _row, currentTier);
      if (currentSlot?.containerId != null) break;
      final belowSlot = stowageCollection.findSlot(_bay, _row, currentTier - 2);
      if (belowSlot?.containerId == null && currentSlot != null) {
        stowageCollection.removeSlot(
          currentSlot.bay,
          currentSlot.row,
          currentSlot.tier,
        );
      }
    }
    return Ok(null);
  }
}
