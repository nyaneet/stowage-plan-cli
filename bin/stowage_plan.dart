import 'package:stowage_plan/main.dart';
import 'package:stowage_plan/models/container/container_1cc.dart';
import 'package:stowage_plan/models/stowage/stowage_collection.dart';
import 'package:stowage_plan/models/stowage/pretty_print_plan.dart';
void main(List<String> arguments) {
  final plan = StowageCollection.fromSlotList(
    arkSlotOrigins,
  );
  plan.addContainer(
    Container1CC(id: 1),
    bay: 1,
    row: 1,
    tier: 2,
  );
  plan.addContainer(
    Container1CC(id: 2),
    bay: 1,
    row: 2,
    tier: 2,
  );
  plan.addContainer(
    Container1CC(id: 3),
    bay: 25,
    row: 4,
    tier: 82,
  );
  plan.addContainer(
    Container1CC(id: 4),
    bay: 25,
    row: 4,
    tier: 84,
  );
  plan.addContainer(
    Container1CC(id: 5),
    bay: 25,
    row: 4,
    tier: 86,
  );
  plan.printAll();
}
