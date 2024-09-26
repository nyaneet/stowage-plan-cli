import 'package:stowage_plan/main.dart';
import 'package:stowage_plan/models/container/container_1cc.dart';
import 'package:stowage_plan/models/stowage/stowage_collection.dart';
void main(List<String> arguments) {
  final plan = StowageCollection.fromSlotList(
    arkSlotOrigins.sublist(0, 4),
  );
  print(plan);
  print('add 2');
  plan.addContainer(
    Container1CC(id: 1),
    bay: 1,
    row: 1,
    tier: 2,
  );
  print(plan);
  print('add 4');
  plan.addContainer(
    Container1CC(id: 2),
    bay: 1,
    row: 1,
    tier: 4,
  );
  print(plan);
  print('remove 2');
  plan.removeContainer(
    bay: 1,
    row: 1,
    tier: 2,
  );
  print(plan);
  print('remove 4');
  plan.removeContainer(
    bay: 1,
    row: 1,
    tier: 4,
  );
  print(plan);
}
