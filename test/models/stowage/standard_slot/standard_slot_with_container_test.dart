import 'package:stowage_plan/models/container/container.dart';
import 'package:stowage_plan/models/stowage/standard_slot.dart';
import 'package:test/test.dart';
///
/// Fake implementation of [Container]
class FakeContainer implements Container {
  @override
  final int id;
  @override
  int get width => 2438;
  @override
  int get length => 6058;
  @override
  int get height => 2591;
  @override
  double get grossWeight => 0.0;
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
        'returns a new slot with container',
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
          final slotWithContainer = emptySlot.withContainer(container);
          expect(
            slotWithContainer,
            isNotNull,
            reason: 'Should return a new slot with container',
          );
          expect(
            slotWithContainer!.containerId,
            equals(container.id),
            reason: 'Container ID should be set correctly',
          );
          expect(
            slotWithContainer.rightZ,
            equals(emptySlot.leftZ + container.height / 1000),
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
      test(
        'returns null if slot already contains a container',
        () {
          final container = FakeContainer(id: 1);
          final slotWithContainer = StandardSlot(
            containerId: 1,
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
          final result = slotWithContainer.withContainer(container);
          expect(
            result,
            isNull,
            reason: 'Should return null if slot already has a container',
          );
        },
      );
      //
      test(
        'returns null if container exceeds maxHeight',
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
            isNull,
            reason: 'Should return null if container exceeds maxHeight',
          );
        },
      );
    },
  );
}
