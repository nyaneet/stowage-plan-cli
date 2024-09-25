import 'package:stowage_plan/models/container/container.dart';
import 'package:stowage_plan/models/stowage/stowage_plan.dart';
import 'package:stowage_plan/models/stowage/stowage_slot.dart';
///
class StowageCollection implements StowagePlan {
  ///
  final Map<String, ({StowageSlot slot, Container? container})> _plan;
  ///
  /// Creates stowage plan from given [plan].
  const StowageCollection(
    Map<String, ({StowageSlot slot, Container? container})> plan,
  ) : _plan = plan;
  ///
  /// For testing.
  /// Creates stowage plan from stowage slots list.
  factory StowageCollection.fromStowageSlotList(List<StowageSlot> slots) =>
      StowageCollection(
        Map.fromEntries(
          slots.map((slot) => MapEntry(
                '${slot.bay.toString().padLeft(2, '0')}${slot.row.toString().padLeft(2, '0')}${slot.tier.toString().padLeft(2, '0')}',
                (slot: slot, container: null),
              )),
        ),
      );
  //
  String _slotKey(int bay, int row, int tier) =>
      '${bay.toString().padLeft(2, '0')}${row.toString().padLeft(2, '0')}${tier.toString().padLeft(2, '0')}';
  //
  @override
  ({Container? container, StowageSlot slot})? stowageAtOrNull(
    int bay,
    int row,
    int tier,
  ) =>
      _plan[_slotKey(bay, row, tier)];
  //
  @override
  List<({StowageSlot slot, Container? container})> toStowageList({
    int? bay,
    int? row,
    int? tier,
  }) =>
      _plan.values.where((stowage) {
        if (bay != null && stowage.slot.bay != bay) return false;
        if (row != null && stowage.slot.row != row) return false;
        if (tier != null && stowage.slot.tier != tier) return false;
        return true;
      }).toList();
  //
  @override
  void putContainerAt(
    Container container, {
    required int bay,
    required int row,
    required int tier,
  }) {
    final slotKey = _slotKey(bay, row, tier);
    if (!_plan.containsKey(slotKey)) return;
    _plan[slotKey] = (
      container: container,
      slot: _plan[slotKey]!.slot.fitted(container: container)!,
    );
    final newSlot = _plan[slotKey]!.slot.upper();
    print(newSlot);
    if (newSlot == null) return;
    final newSlotKey = _slotKey(newSlot.bay, newSlot.row, newSlot.tier);
    print(newSlotKey);
    _plan[newSlotKey] = (container: null, slot: newSlot);
  }
  //
  @override
  void removeContainerAt({
    required int bay,
    required int row,
    required int tier,
  }) {
    throw UnimplementedError();
  }
  @override
  String toString() => _plan.toString();
}
