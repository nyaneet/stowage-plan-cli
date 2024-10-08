import 'package:stowage_plan/core/failure.dart';
import 'package:stowage_plan/core/result.dart';
import 'package:stowage_plan/models/slot/slot.dart';
import 'package:stowage_plan/models/slot/standard_slot.dart';
import 'package:test/test.dart';
void main() {
  //
  group(
    'StandardSlot empty',
    () {
      //
      test(
        'returns [Ok] with new empty slot',
        () {
          final slotWithContainer = StandardSlot(
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
            containerId: 1,
          );
          final result = slotWithContainer.empty();
          expect(
            result,
            isA<Ok<Slot, Failure>>(),
            reason: 'Should return [Ok] with a new slot',
          );
          final emptySlot = (result as Ok<Slot, Failure>).value;
          expect(
            emptySlot.containerId,
            isNull,
            reason: 'Container ID should be null',
          );
        },
      );
      //
      test(
        'returns [Err] if slot is already empty',
        () {
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
          final result = emptySlot.empty();
          expect(
            result,
            isA<Err<Slot, Failure>>(),
            reason: 'Should return [Err]',
          );
        },
      );
      //
      test(
        'does not modify the original slot',
        () {
          final slotWithContainer = StandardSlot(
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
            containerId: 1,
          );
          final result = slotWithContainer.empty();
          expect(
            result,
            isA<Ok<Slot, Failure>>(),
            reason: 'Should return [Ok] with a new slot',
          );
          final emptySlot = (result as Ok<Slot, Failure>).value;
          expect(
            emptySlot.bay,
            1,
            reason: 'bay should not be changed',
          );
          expect(
            emptySlot.row,
            2,
            reason: 'row should not be changed',
          );
          expect(
            emptySlot.tier,
            4,
            reason: 'tier should not be changed',
          );
          expect(
            emptySlot.leftX,
            10.0,
            reason: 'leftX should not be changed',
          );
          expect(
            emptySlot.rightX,
            16.0,
            reason: 'rightX should not be changed',
          );
          expect(
            emptySlot.leftY,
            2.0,
            reason: 'leftY should not be changed',
          );
          expect(
            emptySlot.rightY,
            6.0,
            reason: 'rightY should not be changed',
          );
          expect(
            emptySlot.leftZ,
            1.0,
            reason: 'leftZ should not be changed',
          );
          expect(
            emptySlot.rightZ,
            3.59,
            reason: 'rightZ should not be changed',
          );
          expect(
            emptySlot.maxHeight,
            10.0,
            reason: 'maxHeight should not be changed',
          );
          expect(
            emptySlot.minVerticalSeparation,
            0.5,
            reason: 'minVerticalSeparation should not be changed',
          );
        },
      );
    },
  );
}
