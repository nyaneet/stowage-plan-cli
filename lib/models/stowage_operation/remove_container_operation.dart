import 'package:stowage_plan/core/failure.dart';
import 'package:stowage_plan/core/result.dart';
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
  /// The [bay], [row], and [tier] parameters specify location of slot.
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
    final existingSlot = stowageCollection.findSlot(_bay, _row, _tier);
    switch (existingSlot) {
      case final Slot existingSlot:
        final updatedSlot = existingSlot.empty();
        switch (updatedSlot) {
          case Ok(value: final updatedSlot):
            stowageCollection.addSlot(updatedSlot);
            _clearDanglingSlots(updatedSlot, stowageCollection);
            return Ok(null);
          case Err(:final error):
            return Err(error);
        }
      case null:
        return Err(Failure(
          message: 'Slot not found',
          stackTrace: StackTrace.current,
        ));
    }
  }
  ///
  /// Removes all slots, in bay and row of given [slot]
  /// above which no occupied slots are found, except the lowest one,
  /// within the hold or deck.
  void _clearDanglingSlots(
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
  }
}
