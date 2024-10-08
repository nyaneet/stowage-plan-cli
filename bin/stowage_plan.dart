import 'package:stowage_plan/main.dart';
import 'package:stowage_plan/models/container/container_1cc.dart';
import 'package:stowage_plan/models/operation/put_container_operation.dart';
import 'package:stowage_plan/models/operation/remove_container_operation.dart';
import 'package:stowage_plan/models/stowage/stowage_map.dart';
import 'package:stowage_plan/models/stowage/pretty_print_plan.dart';
void main(List<String> arguments) {
  final plan = StowageMap.fromSlotList(
    arkSlotOrigins,
  );
  PutContainerOperation(
    container: Container1CC(id: 1),
    bay: 1,
    row: 1,
    tier: 2,
  ).execute(plan);
  PutContainerOperation(
    container: Container1CC(id: 2),
    bay: 1,
    row: 2,
    tier: 2,
  ).execute(plan);
  PutContainerOperation(
    container: Container1CC(id: 3),
    bay: 25,
    row: 4,
    tier: 82,
  ).execute(plan);
  PutContainerOperation(
    container: Container1CC(id: 4),
    bay: 25,
    row: 4,
    tier: 84,
  ).execute(plan);
  PutContainerOperation(
    container: Container1CC(id: 5),
    bay: 25,
    row: 4,
    tier: 86,
  ).execute(plan);
  RemoveContainerOperation(
    bay: 1,
    row: 1,
    tier: 2,
  ).execute(plan);
  RemoveContainerOperation(
    bay: 25,
    row: 4,
    tier: 82,
  ).execute(plan);
  RemoveContainerOperation(
    bay: 25,
    row: 4,
    tier: 84,
  ).execute(plan);
  RemoveContainerOperation(
    bay: 25,
    row: 4,
    tier: 86,
  ).execute(plan);
  plan.printAll(usePairs: true);
}
