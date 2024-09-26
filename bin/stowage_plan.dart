import 'package:stowage_plan/main.dart';
import 'package:stowage_plan/models/container/container_1cc.dart';
import 'package:stowage_plan/models/stowage/stowage_collection.dart';
import 'package:stowage_plan/models/stowage/pretty_print_plan.dart';
void main(List<String> arguments) {
  final plan = StowageCollection.fromSlotList(
    arkSlotOrigins.sublist(0, 12),
  );
  plan.printAll();
  plan.addContainer(
    Container1CC(id: 1),
    bay: 1,
    row: 1,
    tier: 2,
  );
  plan.addContainer(
    Container1CC(id: 1),
    bay: 1,
    row: 4,
    tier: 2,
  );
  plan.printAll();
  // plan.addContainer(
  //   Container1CC(id: 2),
  //   bay: 1,
  //   row: 1,
  //   tier: 4,
  // );
  // plan.removeContainer(
  //   bay: 1,
  //   row: 1,
  //   tier: 2,
  // );
  // plan.removeContainer(
  //   bay: 1,
  //   row: 1,
  //   tier: 4,
  // );
}
