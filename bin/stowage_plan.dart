import 'package:stowage_plan/core/calculate_check_digit.dart';
import 'package:stowage_plan/core/result_extension.dart';
import 'package:stowage_plan/main.dart';
import 'package:stowage_plan/models/container/container_1cc.dart';
import 'package:stowage_plan/models/stowage_operation/put_container_operation.dart';
import 'package:stowage_plan/models/stowage_collection/stowage_map.dart';
import 'package:stowage_plan/models/stowage_collection/pretty_print_plan.dart';
void main(List<String> arguments) {
  final plan = StowageMap.fromSlotList(
    arkSlotOrigins.sublist(0, 24),
    // arkSlotOrigins,
  );
  final tiersToFill = [2, 4, 6, 82, 84, 86];
  final container = Container1CC(id: 1);
  for (final tier in tiersToFill) {
    final slotsInTier = plan.toFilteredSlotList(
      tier: tier,
      shouldIncludeSlot: (slot) => slot.bay.isOdd,
    );
    for (final slot in slotsInTier) {
      PutContainerOperation(
        container: container,
        bay: slot.bay,
        row: slot.row,
        tier: slot.tier,
      ).execute(plan).inspectErr(print);
    }
  }
  plan.printAll(usePairs: false);
  print('\n\n');
  plan.printAll(usePairs: true);
  CheckDigit.fromContainerCode(
    'GVT U 300038',
  ).value().inspect(print);
}
