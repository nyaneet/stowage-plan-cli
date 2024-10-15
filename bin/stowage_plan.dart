import 'package:stowage_plan/core/result_extension.dart';
import 'package:stowage_plan/main.dart';
import 'package:stowage_plan/models/freight_container/container_1cc.dart';
import 'package:stowage_plan/models/stowage_collection/pretty_print_plan.dart';
import 'package:stowage_plan/models/stowage_operation/put_container_operation.dart';
import 'package:stowage_plan/models/stowage_collection/stowage_map.dart';
void main(List<String> arguments) {
  final plan = StowageMap.fromSlotList(
    arkSlotOrigins,
  );
  print(plan.toFilteredSlotList().first.maxHeight);
  final tiersToFill = [2, 4, 6, 82, 84, 86];
  final containerToPut = Container1CC(id: 1, tareWeight: 0.0, cargoWeight: 2.4);
  for (final tier in tiersToFill) {
    final slotsInTier = plan.toFilteredSlotList(
      tier: tier,
      shouldIncludeSlot: (slot) => slot.bay.isOdd,
    );
    for (final slot in slotsInTier) {
      PutContainerOperation(
        container: containerToPut,
        bay: slot.bay,
        row: slot.row,
        tier: slot.tier,
      ).execute(plan).inspectErr(print);
    }
  }
  plan.printAll(usePairs: false);
  // print('Number of slots in collection: ${plan.toFilteredSlotList().length}');
  // final watch = Stopwatch()..start();
  // PutContainerOperation(
  //   container: container,
  //   bay: 1,
  //   row: 2,
  //   tier: 2,
  // ).execute(plan).inspectErr(print);
  // watch.stop();
  // print('Put at 01-02-02: ${watch.elapsedMilliseconds} ms');
  // watch.reset();
  // watch.start();
  // PutContainerOperation(
  //   container: container,
  //   bay: 1,
  //   row: 2,
  //   tier: 32,
  // ).execute(plan).inspectErr(print);
  // watch.stop();
  // print('Put at 01-02-32: ${watch.elapsedMilliseconds} ms');
  // watch.reset();
  // watch.start();
  // PutContainerOperation(
  //   container: container,
  //   bay: 1,
  //   row: 2,
  //   tier: 78,
  // ).execute(plan).inspectErr(print);
  // watch.stop();
  // print('Put at 01-02-78: ${watch.elapsedMilliseconds} ms');
  // plan.printAll(usePairs: false);
  // print('\n\n');
  // CheckDigit.fromContainerCode(
  //   'GVT U 300038',
  // ).value().inspect(print);
}
