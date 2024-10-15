import 'package:stowage_plan/core/failure.dart';
import 'package:stowage_plan/core/result.dart';
import 'package:stowage_plan/models/slot/slot.dart';
import 'package:stowage_plan/models/slot/standard_slot.dart';
import 'package:test/test.dart';
//
void main() {
  //
  group(
    'StandardSlot createUpperSlot',
    () {
      final double standardHeight = 2.59;
      late StandardSlot slot;
      //
      setUp(
        () {
          slot = StandardSlot(
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
        },
      );
      //
      test(
        'create new slot with correct parameters',
        () {
          final result = slot.createUpperSlot();
          expect(
            result,
            isA<Ok<Slot?, Failure>>(),
            reason: 'Should return [Ok]',
          );
          final upperSlot = (result as Ok<Slot?, Failure>).value;
          expect(
            upperSlot,
            isNotNull,
            reason: 'should return [Ok] with new slot',
          );
          expect(
            upperSlot!.bay,
            equals(slot.bay),
            reason: 'bay should be the same',
          );
          expect(
            upperSlot.row,
            equals(slot.row),
            reason: 'row should be the same',
          );
          expect(
            upperSlot.tier,
            equals(slot.tier + 2),
            reason: 'tier should be incremented by 2',
          );
          expect(
            upperSlot.leftX,
            equals(slot.leftX),
            reason: 'leftX should be the same',
          );
          expect(
            upperSlot.rightX,
            equals(slot.rightX),
            reason: 'rightX should be the same',
          );
          expect(
            upperSlot.leftY,
            equals(slot.leftY),
            reason: 'leftY should be the same',
          );
          expect(
            upperSlot.rightY,
            equals(slot.rightY),
            reason: 'rightY should be the same',
          );
          expect(
            upperSlot.leftZ,
            equals(slot.rightZ + slot.minVerticalSeparation),
            reason: 'leftZ should be calculated correctly',
          );
          expect(
            upperSlot.rightZ,
            equals(upperSlot.leftZ + standardHeight),
            reason: 'rightZ should be calculated correctly',
          );
          expect(
            upperSlot.maxHeight,
            equals(slot.maxHeight),
            reason: 'maxHeight should be the same',
          );
          expect(
            upperSlot.minVerticalSeparation,
            equals(slot.minVerticalSeparation),
            reason: 'minVerticalSeparation should be the same',
          );
          expect(
            upperSlot.containerId,
            isNull,
            reason: 'containerId should be null',
          );
        },
      );
      //
      test(
        'uses given verticalSeparation',
        () {
          final verticalSeparation = slot.minVerticalSeparation + 1.0;
          final result = slot.createUpperSlot(
            verticalSeparation: verticalSeparation,
          );
          expect(
            result,
            isA<Ok<Slot?, Failure>>(),
            reason: 'Should return [Ok]',
          );
          final upperSlot = (result as Ok<Slot?, Failure>).value;
          expect(
            upperSlot,
            isNotNull,
            reason: 'should return [Ok] with new slot',
          );
          expect(
            upperSlot!.leftZ,
            equals(slot.rightZ + verticalSeparation),
            reason: 'Should use given verticalSeparation',
          );
          expect(upperSlot.rightZ, equals(upperSlot.leftZ + standardHeight));
        },
      );
      //
      test(
        'does not create new slot if it exceeds maxHeight',
        () {
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
          final result = slotWithLowMaxHeight.createUpperSlot();
          expect(
            result,
            isA<Ok<Slot?, Failure>>(),
            reason: 'Should return [Ok]',
          );
          final upperSlot = (result as Ok<Slot?, Failure>).value;
          expect(
            upperSlot,
            isNull,
            reason: 'Should return [Ok] with null',
          );
        },
      );
      //
      test(
        'returns [Err] if verticalSeparation is less than minVerticalSeparation',
        () {
          final result = slot.createUpperSlot(
            verticalSeparation: slot.minVerticalSeparation - 1.0,
          );
          expect(
            result,
            isA<Err<Slot?, Failure>>(),
            reason:
                'Should return [Err] if verticalSeparation is less than minVerticalSeparation',
          );
        },
      );
    },
  );
}