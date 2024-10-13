import 'package:collection/collection.dart';
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
  /// Minimum possible tier number for hold.
  static const int _minHoldTier = 2;
  /// Minimum possible tier number for deck.
  // static const int _minDeckTier = 80;
  /// Maximum possible tier number for hold.
  static const int _maxHoldTier = 78;
  /// Maximum possible tier number for deck.
  static const int _maxDeckTier = 98;
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
  ResultF<void> execute(StowageCollection collection) {
    final previousCollection = collection.copy();
    collection.removeAllSlots();
    return _copyUnchangedSlots(collection, previousCollection)
        .and(_putContainer(collection))
        .and(_createUpperOddBaySlot(collection))
        .and(_createUpperEvenBaySlot(collection))
        .and(_copyChangedOddBaySlots(collection, previousCollection))
        .and(_copyChangedEvenBaySlots(collection, previousCollection))
        .inspectErr((_) => _restoreFromBackup(collection, previousCollection));
  }
  ///
  Ok<void, Failure> _copyUnchangedSlots(
    StowageCollection collection,
    StowageCollection previousCollection,
  ) {
    final (minTierToSkip, maxTierToSkip) = _tier <= _maxHoldTier
        ? (_tier + 2, _maxHoldTier)
        : (_tier + 2, _maxDeckTier);
    for (var tierToCopy = _minHoldTier;
        tierToCopy <= _maxDeckTier;
        tierToCopy += 2) {
      if (tierToCopy >= minTierToSkip && tierToCopy <= maxTierToSkip) {
        continue;
      }
      collection.addAllSlots(
        previousCollection.toFilteredSlotList(tier: tierToCopy),
      );
    }
    return Ok(null);
  }
  ///
  ResultF<void> _copyChangedOddBaySlots(
    StowageCollection collection,
    StowageCollection previousCollection,
  ) {
    final (minTierToChange, maxTierToChange) = _tier <= _maxHoldTier
        ? (_tier + 2, _maxHoldTier)
        : (_tier + 2, _maxDeckTier);
    for (var tierToChange = minTierToChange;
        tierToChange <= maxTierToChange;
        tierToChange += 2) {
      final oldSlotsInTier = previousCollection.toFilteredSlotList(
        tier: tierToChange,
        shouldIncludeSlot: (slot) => slot.bay.isOdd,
      );
      for (final oldSlot in oldSlotsInTier) {
        final newBottomSlot = collection.findSlot(
          oldSlot.bay,
          oldSlot.row,
          oldSlot.tier - 2,
        );
        final oldBottomSlot = previousCollection.findSlot(
          oldSlot.bay,
          oldSlot.row,
          oldSlot.tier - 2,
        );
        if (newBottomSlot == null || oldBottomSlot == null) {
          return Err(Failure(
            message: 'Collection corrupted during operation execution',
            stackTrace: StackTrace.current,
          ));
        }
        final newLeftZ =
            newBottomSlot.leftZ + newBottomSlot.minVerticalSeparation;
        final oldLeftZ =
            oldBottomSlot.leftZ + oldBottomSlot.minVerticalSeparation;
        final copyResult = oldSlot
            .shiftByZ(newLeftZ - oldLeftZ)
            .map((shiftedSlot) => collection.addSlot(shiftedSlot));
        if (copyResult.isErr()) return copyResult;
      }
    }
    return Ok(null);
  }
  ///
  ResultF<void> _copyChangedEvenBaySlots(
    StowageCollection collection,
    StowageCollection previousCollection,
  ) {
    final (minTierToChange, maxTierToChange) = _tier <= _maxHoldTier
        ? (_tier + 2, _maxHoldTier)
        : (_tier + 2, _maxDeckTier);
    for (var tierToChange = minTierToChange;
        tierToChange <= maxTierToChange;
        tierToChange += 2) {
      final oldSlotsInTier = previousCollection.toFilteredSlotList(
        tier: tierToChange,
        shouldIncludeSlot: (slot) => slot.bay.isEven,
      );
      for (final oldSlot in oldSlotsInTier) {
        final newLeftZ = collection
            .toFilteredSlotList(
              row: oldSlot.row,
              tier: oldSlot.tier - 2,
              shouldIncludeSlot: (slot) =>
                  slot.bay == oldSlot.bay ||
                  slot.bay == oldSlot.bay - 1 ||
                  slot.bay == oldSlot.bay + 1,
            )
            .map((s) => s.rightZ + s.minVerticalSeparation)
            .maxOrNull;
        final oldLeftZ = previousCollection
            .toFilteredSlotList(
              row: oldSlot.row,
              tier: oldSlot.tier - 2,
              shouldIncludeSlot: (slot) =>
                  slot.bay == oldSlot.bay ||
                  slot.bay == oldSlot.bay - 1 ||
                  slot.bay == oldSlot.bay + 1,
            )
            .map((s) => s.rightZ + s.minVerticalSeparation)
            .toList()
            .maxOrNull;
        if (newLeftZ == null || oldLeftZ == null) {
          return Err(Failure(
            message: 'Collection corrupted during operation execution',
            stackTrace: StackTrace.current,
          ));
        }
        final copyResult = oldSlot
            .shiftByZ(newLeftZ - oldLeftZ)
            .map((shiftedSlot) => collection.addSlot(shiftedSlot));
        if (copyResult.isErr()) return copyResult;
      }
    }
    return Ok(null);
  }
  ///
  /// Puts container to slot at specified position in [collection].
  /// And creates new slot for upper tier if needed.
  ResultF<void> _putContainer(StowageCollection collection) {
    return _findSlot(_bay, _row, _tier, collection).andThen(
      (existingSlot) {
        return existingSlot.withContainer(_container);
      },
    ).map((slotWithContainer) {
      collection.addSlot(slotWithContainer);
    });
  }
  ///
  ResultF<void> _createUpperOddBaySlot(StowageCollection collection) {
    if (_bay.isEven) return const Ok(null);
    return _findSlot(_bay, _row, _tier, collection).andThen((slot) {
      return slot.createUpperSlot();
    }).map((upperSlot) {
      if (upperSlot == null) return;
      collection.addSlot(upperSlot);
    });
  }
  ///
  ResultF<void> _createUpperEvenBaySlot(StowageCollection collection) {
    // if (_bay.isOdd) return const Ok(null);
    return _findSlot(_bay, _row, _tier, collection).andThen(
      (slot) {
        return slot.createUpperSlot();
      },
    ).andThen(
      (upperSlot) {
        if (upperSlot == null) return const Ok(null);
        final leftZ = collection
            .toFilteredSlotList(
              row: upperSlot.row,
              tier: upperSlot.tier - 2,
              shouldIncludeSlot: (s) =>
                  s.bay == upperSlot.bay ||
                  s.bay == upperSlot.bay - 1 ||
                  s.bay == upperSlot.bay + 1,
            )
            .map((s) => s.rightZ + s.minVerticalSeparation)
            .maxOrNull;
        if (leftZ == null) {
          return Err(Failure(
            message: 'Collection corrupted during operation execution',
            stackTrace: StackTrace.current,
          ));
        }
        return upperSlot.shiftByZ(leftZ - upperSlot.leftZ);
      },
    ).map(
      (upperSlot) {
        if (upperSlot == null) return;
        collection.addSlot(upperSlot);
      },
    );
  }
  ///
  /// Restores [collection] from [backup].
  void _restoreFromBackup(
    StowageCollection collection,
    StowageCollection backup,
  ) {
    collection.removeAllSlots();
    collection.addAllSlots(backup.toFilteredSlotList());
  }
  ///
  /// Find slot at specified position.
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
