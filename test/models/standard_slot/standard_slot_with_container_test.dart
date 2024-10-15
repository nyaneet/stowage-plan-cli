import 'package:stowage_plan/core/failure.dart';
import 'package:stowage_plan/core/result.dart';
import 'package:stowage_plan/models/freight_container/freight_container.dart';
import 'package:stowage_plan/models/freight_container/freight_container_type.dart';
import 'package:stowage_plan/models/slot/slot.dart';
import 'package:stowage_plan/models/slot/standard_slot.dart';
import 'package:test/test.dart';
///
/// Fake implementation of [FreightContainer]
class FakeContainer implements FreightContainer {
  @override
  final int id;
  @override
  double get width => 2438 / 1000;
  @override
  double get length => 6058 / 1000;
  @override
  double get height => 2591 / 1000;
  @override
  double get grossWeight => 0.0;
  @override
  double get tareWeight => 0.0;
  @override
  double get cargoWeight => 0.0;
  @override
  FreightContainerType get type => FreightContainerType.type1AA;
  //
  const FakeContainer({required this.id});
}
//
void main() {
  group(
    'StandardSlot withContainer',
    () {
      //
      test(
        'creates slot with container',
        () {
          final container = FakeContainer(id: 1);
          final emptySlot = StandardSlot(
            bay: 1,
            row: 2,
            tier: 4,
            leftX: 10.0,
            rightX: 16.0,
            leftY: 2.0,
            rightY: 6.0,
            leftZ: 1.0,
            rightZ: 3.59,
            maxHeight: 10.0,
            minVerticalSeparation: 0.5,
          );
          final slotWithContainerResult = emptySlot.withContainer(container);
          expect(
            slotWithContainerResult,
            isA<Ok<Slot, Failure>>(),
            reason: 'Should return [Ok] with new slot',
          );
          final slotWithContainer =
              (slotWithContainerResult as Ok<Slot, Failure>).value;
          expect(
            slotWithContainer.containerId,
            equals(container.id),
            reason: 'container ID should be set correctly',
          );
          expect(
            slotWithContainer.rightZ,
            equals(emptySlot.leftZ + container.height),
            reason: 'rightZ should be adjusted to container height',
          );
          expect(
            slotWithContainer.bay,
            emptySlot.bay,
            reason: 'bay should not be changed',
          );
          expect(
            slotWithContainer.row,
            emptySlot.row,
            reason: 'row should not be changed',
          );
          expect(
            slotWithContainer.tier,
            emptySlot.tier,
            reason: 'tier should not be changed',
          );
          expect(
            slotWithContainer.leftX,
            emptySlot.leftX,
            reason: 'leftX should not be changed',
          );
          expect(
            slotWithContainer.rightX,
            emptySlot.rightX,
            reason: 'rightX should not be changed',
          );
          expect(
            slotWithContainer.leftY,
            emptySlot.leftY,
            reason: 'leftY should not be changed',
          );
          expect(
            slotWithContainer.rightY,
            emptySlot.rightY,
            reason: 'rightY should not be changed',
          );
          expect(
            slotWithContainer.leftZ,
            emptySlot.leftZ,
            reason: 'leftZ should not be changed',
          );
          expect(
            slotWithContainer.maxHeight,
            emptySlot.maxHeight,
            reason: 'maxHeight should not be changed',
          );
          expect(
            slotWithContainer.minVerticalSeparation,
            emptySlot.minVerticalSeparation,
            reason: 'minVerticalSeparation should not be changed',
          );
        },
      );
      //
      // test(
      //   'returns [Err] if slot already contains a container',
      //   () {
      //     final container = FakeContainer(id: 1);
      //     final slotWithContainer = StandardSlot(
      //       containerId: 1,
      //       bay: 1,
      //       row: 2,
      //       tier: 4,
      //       leftX: 10.0,
      //       rightX: 16.0,
      //       leftY: 2.0,
      //       rightY: 6.0,
      //       leftZ: 1.0,
      //       rightZ: 3.59,
      //       maxHeight: 10.0,
      //       minVerticalSeparation: 0.5,
      //     );
      //     final result = slotWithContainer.withContainer(container);
      //     expect(
      //       result,
      //       isA<Err<Slot, Failure>>(),
      //       reason: 'Should return [Err]',
      //     );
      //   },
      // );
      //
      test(
        'returns [Err] if container exceeds maxHeight',
        () {
          final container = FakeContainer(id: 1);
          final slotWithLowMaxHeight = StandardSlot(
            bay: 1,
            row: 2,
            tier: 4,
            leftX: 10.0,
            rightX: 16.0,
            leftY: 2.0,
            rightY: 6.0,
            leftZ: 1.0,
            rightZ: 3.59,
            maxHeight: 0.0,
            minVerticalSeparation: 0.5,
          );
          final result = slotWithLowMaxHeight.withContainer(container);
          expect(
            result,
            isA<Err<Slot, Failure>>(),
            reason: 'Should return [Err] if container exceeds maxHeight',
          );
        },
      );
    },
  );
}
