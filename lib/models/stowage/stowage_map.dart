import 'package:stowage_plan/models/container/container.dart';
import 'package:stowage_plan/models/stowage/stowage_collection.dart';
import 'package:stowage_plan/models/stowage/slot.dart';
///
/// [StowageCollection] that uses [Map] to store stowage plan.
///
/// Each key of [Map] is string representation of slot key in format BBRRTT
/// in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html).
/// Each value of [Map] is a [Slot] of stowage plan.
class StowageMap implements StowageCollection {
  ///
  /// Minimal possible tier number for hold.
  static const int _baseHoldTier = 2;
  ///
  /// Minimal possible tier number for deck.
  static const int _baseDeckTier = 80;
  ///
  /// Maximal possible tier number.
  static const int _maxTier = 99;
  ///
  /// [Map] that used to store stowage slots of plan.
  ///
  /// Key of [Map] entry is string representation of slot key in format BBRRTT
  /// in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html).
  final Map<String, Slot> _plan;
  ///
  /// Creates stowage plan from given [plan].
  StowageMap._(Map<String, Slot> plan) : _plan = plan;
  ///
  /// Creates stowage plan from list of [slots].
  ///
  /// Copies of given [slots] are used to create stowage plan.
  factory StowageMap.fromSlotList(List<Slot> slots) =>
      StowageMap._(Map.fromEntries(
        slots.map((slot) => MapEntry(
              _SlotKey.fromSlot(slot).value(),
              slot.copy(),
            )),
      ));
  //
  @override
  Slot? findSlot(
    int bay,
    int row,
    int tier,
  ) =>
      _plan[_SlotKey(bay, row, tier).value()];
  //
  @override
  List<Slot> toFilteredSlotList({
    int? bay,
    int? row,
    int? tier,
    bool Function(Slot slot)? shouldIncludeSlot,
  }) =>
      _plan.values.where((slot) {
        if (bay != null && slot.bay != bay) return false;
        if (row != null && slot.row != row) return false;
        if (tier != null && slot.tier != tier) return false;
        if (shouldIncludeSlot?.call(slot) == false) return false;
        return true;
      }).toList();
  //
  @override
  void addContainer(
    Container container, {
    required int bay,
    required int row,
    required int tier,
  }) {
    // Find and update specified slot if exists
    final existingSlot = findSlot(bay, row, tier);
    if (existingSlot == null) return;
    final updatedSlot = existingSlot.withContainer(container);
    if (updatedSlot == null) return;
    _plan[_SlotKey.fromSlot(updatedSlot).value()] = updatedSlot;
    // Add new slot for next tier if possible
    final upperSlot = updatedSlot.createUpperSlot();
    if (upperSlot == null) return;
    _plan[_SlotKey.fromSlot(upperSlot).value()] = upperSlot;
  }
  //
  @override
  void removeContainer({
    required int bay,
    required int row,
    required int tier,
  }) {
    // Remove container form specified slot
    final existingSlot = findSlot(bay, row, tier);
    if (existingSlot == null) return;
    final updatedSlot = existingSlot.empty();
    if (updatedSlot == null) return;
    _plan[_SlotKey.fromSlot(updatedSlot).value()] = updatedSlot;
    // Clear all slots above which there are no occupied slots
    // within the hold or deck except for the last one
    final maxTier =
        updatedSlot.tier < _baseDeckTier ? _baseDeckTier - 2 : _maxTier;
    final baseTier =
        updatedSlot.tier >= _baseHoldTier ? _baseHoldTier : _baseDeckTier;
    for (int currentTier = maxTier; currentTier > baseTier; currentTier -= 2) {
      final currentSlot = findSlot(bay, row, currentTier);
      if (currentSlot?.containerId != null) break;
      final belowSlot = findSlot(bay, row, currentTier - 2);
      if (belowSlot?.containerId == null && currentSlot != null) {
        _plan.remove(_SlotKey.fromSlot(currentSlot).value());
      }
    }
  }
  //
  @override
  String toString() => _plan.toString();
}
///
/// Generates a unique key for a slot based on its bay, row, and tier numbers
/// in format BBRRTT in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html).
class _SlotKey {
  ///
  /// Bay number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.1](https://www.iso.org/ru/standard/17568.html)
  final int _bay;
  ///
  /// Row number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.2](https://www.iso.org/ru/standard/17568.html)
  final int _row;
  ///
  /// Tier number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  final int _tier;
  ///
  /// Creates [_SlotKey] from given [bay], [row] and [tier] numbers.
  const _SlotKey(
    int bay,
    int row,
    int tier,
  )   : _tier = tier,
        _row = row,
        _bay = bay;
  ///
  /// Creates [_SlotKey] from given [slot].
  factory _SlotKey.fromSlot(Slot slot) => _SlotKey(
        slot.bay,
        slot.row,
        slot.tier,
      );
  ///
  /// Returns string representation of slot key in format BBRRTT.
  String value() => toString();
  ///
  /// Returns string representation of slot key in format BBRRTT.
  @override
  String toString() =>
      '${_bay.toString().padLeft(2, '0')}${_row.toString().padLeft(2, '0')}${_tier.toString().padLeft(2, '0')}';
}
