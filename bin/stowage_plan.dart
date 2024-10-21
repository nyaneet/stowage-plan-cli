import 'package:stowage_plan/core/extension_transform.dart';
import 'package:stowage_plan/core/result.dart';
import 'package:stowage_plan/main.dart';
import 'package:stowage_plan/models/freight_container/container_1a.dart';
import 'package:stowage_plan/models/freight_container/container_1aa.dart';
import 'package:stowage_plan/models/freight_container/container_1c.dart';
import 'package:stowage_plan/models/freight_container/container_1cc.dart';
import 'package:stowage_plan/models/freight_container/freight_container.dart';
import 'package:stowage_plan/models/slot/slot.dart';
import 'package:stowage_plan/models/stowage_collection/pretty_print_plan.dart';
import 'package:stowage_plan/models/stowage_collection/stowage_collection.dart';
import 'package:stowage_plan/models/stowage_operation/add_container_operation.dart';
import 'package:stowage_plan/models/stowage_operation/put_container_operation.dart';
import 'package:stowage_plan/models/stowage_collection/stowage_map.dart';

StowageCollection allTiersPlan() {
  final plan = StowageMap.fromSlotList(
    arkSlotOrigins,
  );
  print(plan.toFilteredSlotList().first.maxHeight);
  final tiersToFill = [
    2, //
    4, 6, 8, 10, //
    // 12, 14, 16, 18, 20, //
    // 22, 24, 26, 28, 30, //
    82, 84, //
    86, 88, 90, //
    // 92, 94, 96, 98, 100, //
    // 102, 104, 106, 108, 110, //
    // 112, 114, 116, 118, 120, //
  ];
  FreightContainer containerToPut =
      Container1A(id: 1, tareWeight: 0.0, cargoWeight: 2.4);
  // ignore: prefer_function_declarations_over_variables
  var shouldIncludeSlot = (Slot slot) => slot.bay.isEven;
  for (final tier in tiersToFill) {
    final slotsInTier = plan.toFilteredSlotList(
      tier: tier,
      shouldIncludeSlot: shouldIncludeSlot,
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
  containerToPut = Container1C(id: 1, tareWeight: 0.0, cargoWeight: 2.4);
  // ignore: prefer_function_declarations_over_variables
  shouldIncludeSlot = (Slot slot) => slot.bay.isOdd;
  for (final tier in tiersToFill) {
    final slotsInTier = plan.toFilteredSlotList(
      tier: tier,
      shouldIncludeSlot: shouldIncludeSlot,
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
  final resultPlan = StowageMap.fromSlotList(
    plan
        .toFilteredSlotList()
        .map((s) => switch (s.empty()) {
              Ok(:final value) => value,
              Err() => null,
            })
        .whereType<Slot>()
        .map((s) => switch (s.tier) {
              2 || 82 => s.activate(),
              _ => s.deactivate(),
            })
        .toList(),
  );
  // resultPlan.printAll(usePairs: false);
  // print(
  //   'Number of slots in collection: ${resultPlan.toFilteredSlotList().length}',
  // );
  // final pgCollection = PgStowageCollection(collection: resultPlan);
  // pgCollection.save('all_tiers_min_height');
  return resultPlan;
}

void main(List<String> arguments) {
  final plan = allTiersPlan();
  FreightContainer container = Container1CC(
    id: 1,
    tareWeight: 0.0,
    cargoWeight: 2.4,
  );
  final watch = Stopwatch()..start();
  AddContainerOperation(
    container: container,
    bay: 3,
    row: 2,
    tier: 2,
  ).execute(plan).inspectErr(print);
  watch.stop();
  print('Put at 03-02-02: ${watch.elapsedMilliseconds} ms');
  // watch.reset();
  // container = Container1AA(
  //   id: 2,
  //   tareWeight: 0.0,
  //   cargoWeight: 2.4,
  // );
  // AddContainerOperation(
  //   container: container,
  //   bay: 2,
  //   row: 1,
  //   tier: 2,
  // ).execute(plan).inspectErr(print);
  // watch.stop();
  // print('Put at 02-01-02: ${watch.elapsedMilliseconds} ms');
  // watch.reset();
  plan.printAll(usePairs: true, printOnlyActive: true);
  // print('\n\n');
  // CheckDigit.fromContainerCode(
  //   'GVT U 300038',
  // ).value().inspect(print);
}
