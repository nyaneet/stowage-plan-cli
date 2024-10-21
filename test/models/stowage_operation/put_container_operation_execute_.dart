import 'package:collection/collection.dart';
import 'package:stowage_plan/core/result.dart';
import 'package:stowage_plan/models/freight_container/freight_container.dart';
import 'package:stowage_plan/models/freight_container/freight_container_type.dart';
import 'package:stowage_plan/models/slot/slot.dart';
import 'package:stowage_plan/models/slot/standard_slot.dart';
import 'package:stowage_plan/models/stowage_collection/pretty_print_plan.dart';
import 'package:stowage_plan/models/stowage_collection/stowage_collection.dart';
import 'package:stowage_plan/models/stowage_operation/put_container_operation.dart';
import 'package:test/test.dart';
///
class FakeStowageCollection implements StowageCollection {
  List<Slot> _slots = [];
  ///
  FakeStowageCollection._(List<Slot> slots) : _slots = slots;
  ///
  factory FakeStowageCollection.fromSlots(List<Slot> slots) {
    return FakeStowageCollection._(slots
        .map(
          (s) => s.copy(),
        )
        .toList());
  }
  //
  @override
  Slot? findSlot(int bay, int row, int tier) {
    return _slots.firstWhereOrNull(
      (slot) => slot.bay == bay && slot.row == row && slot.tier == tier,
    );
  }
  //
  @override
  void addSlot(Slot slot) {
    removeSlot(slot.bay, slot.row, slot.tier);
    _slots.add(slot);
  }
  //
  @override
  void addAllSlots(List<Slot> slots) {
    for (final slot in slots) {
      addSlot(slot);
    }
  }
  //
  @override
  void removeSlot(int bay, int row, int tier) {
    _slots.removeWhere(
      (slot) => slot.bay == bay && slot.row == row && slot.tier == tier,
    );
  }
  //
  @override
  void removeAllSlots() {
    _slots.clear();
  }
  //
  @override
  List<Slot> toFilteredSlotList({
    int? bay,
    int? row,
    int? tier,
    bool Function(Slot slot)? shouldIncludeSlot,
  }) {
    List<Slot> filteredSlots = _slots;
    if (bay != null) {
      filteredSlots = filteredSlots.where((slot) => slot.bay == bay).toList();
    }
    if (row != null) {
      filteredSlots = filteredSlots.where((slot) => slot.row == row).toList();
    }
    if (tier != null) {
      filteredSlots = filteredSlots.where((slot) => slot.tier == tier).toList();
    }
    if (shouldIncludeSlot != null) {
      filteredSlots =
          filteredSlots.where((slot) => shouldIncludeSlot(slot)).toList();
    }
    return filteredSlots;
  }
  //
  @override
  StowageCollection copy() {
    return FakeStowageCollection.fromSlots(_slots);
  }
}
///
class FakeContainer implements FreightContainer {
  @override
  final int id;
  @override
  final double height; // m
  @override
  final double length = 1;
  @override
  final double width = 1;
  @override
  final double grossWeight = 0.0;
  @override
  double get tareWeight => 0.0;
  @override
  double get cargoWeight => 0.0;
  @override
  FreightContainerType get type => FreightContainerType.type1AA;
  ///
  const FakeContainer({
    required this.id,
    this.height = 1,
  });
}
//
void main() {
  //
  group('PutContainerOperation.execute', () {
    late FakeStowageCollection collection;
    //
    setUp(() {
      // BAY No. 01
      // 04     [ ]
      // 02     [▥] [ ] [ ]
      //     04  02  01  03
      collection = FakeStowageCollection.fromSlots([
        StandardSlot(
          bay: 1,
          row: 1,
          tier: 2,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 1,
          row: 2,
          tier: 2,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minVerticalSeparation: 0.5,
          containerId: 1,
        ),
        StandardSlot(
          bay: 1,
          row: 2,
          tier: 4,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 1.0,
          rightY: 2.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 1,
          row: 3,
          tier: 2,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 2.0,
          rightY: 3.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 2.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
      ]);
      collection.printAll();
    });
    tearDown(() {
      collection.printAll();
    });
    //
    test('adds slot with container to collection', () {
      final container = FakeContainer(id: 1);
      final operation = PutContainerOperation(
        bay: 1,
        row: 1,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      final slot = collection.findSlot(1, 1, 2);
      expect(
        slot,
        isNotNull,
        reason: 'slot should not be null after adding container to collection',
      );
      expect(
        slot!.containerId,
        container.id,
        reason: 'slot.containerId should be equal to container.id',
      );
    });
    //
    test('adds upper slot to collection if possible', () {
      final container = FakeContainer(id: 1);
      final operation = PutContainerOperation(
        bay: 1,
        row: 1,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      final upperSlot = collection.findSlot(1, 1, 4);
      expect(
        upperSlot,
        isNotNull,
        reason:
            'upper slot should not be null after adding container to collection',
      );
      expect(
        upperSlot!.containerId,
        isNull,
        reason: 'upper slot.containerId should be null',
      );
    });
    //
    test('does not add upper slot to collection if impossible', () {
      final container = FakeContainer(id: 1);
      final operation = PutContainerOperation(
        bay: 1,
        row: 3,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      final upperSlot = collection.findSlot(1, 3, 4);
      expect(
        upperSlot,
        isNull,
        reason:
            'upper slot should be null after adding container to collection',
      );
    });
    // test('does not add container if slot is already occupied', () {
    //   final container = FakeContainer(id: 1);
    //   final operation = PutContainerOperation(
    //     bay: 1,
    //     row: 2,
    //     tier: 2,
    //     container: container,
    //   );
    //   final result = operation.execute(collection);
    //   expect(
    //     result,
    //     isA<Err>(),
    //     reason: 'operation.execute should return Err',
    //   );
    // });
    //
    test('updates slot z coordinates when container is put', () {
      final containerHeight = 1.0; // in m
      final container = FakeContainer(id: 1, height: containerHeight);
      final operation = PutContainerOperation(
        bay: 1,
        row: 1,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      final slot = collection.findSlot(1, 1, 2);
      expect(
        slot,
        isNotNull,
        reason: 'slot should not be null after adding container to collection',
      );
      expect(
        slot!.leftZ,
        0.0,
        reason: 'slot.leftZ should be equal to 0.0',
      );
      expect(
        slot.rightZ,
        containerHeight,
        reason: 'slot.rightZ should be equal to container.height',
      );
    });
    //
    test('creates slot above with correct z coordinates', () {
      final containerHeight = 1.0; // in m
      final standardSlotHeight = 2.59; // in m
      final container = FakeContainer(id: 1, height: containerHeight);
      final operation = PutContainerOperation(
        bay: 1,
        row: 1,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      final slotBelow = collection.findSlot(1, 1, 2);
      expect(
        slotBelow,
        isNotNull,
        reason:
            'slotBelow should not be null after adding container to collection',
      );
      final slotAbove = collection.findSlot(1, 1, 4);
      expect(
        slotAbove,
        isNotNull,
        reason:
            'slotAbove should not be null after adding container to collection',
      );
      expect(
        slotAbove!.leftZ,
        slotBelow!.rightZ + slotBelow.minVerticalSeparation,
        reason:
            'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
      );
      expect(
        slotAbove.rightZ,
        slotAbove.leftZ + standardSlotHeight,
        reason:
            'slotAbove.rightZ should be equal to slotAbove.leftZ + standardSlotHeight',
      );
    });
  });
}
