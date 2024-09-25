import 'package:stowage_plan/main.dart';
import 'package:stowage_plan/models/container/container_1cc.dart';
import 'package:stowage_plan/models/stowage/stowage_collection.dart';
void main(List<String> arguments) {
  final plan = StowageCollection.fromStowageSlotList(
    arkSlotOrigins.sublist(0, 12),
  );
  print(plan);
  plan.putContainerAt(
    Container1CC(),
    bay: 1,
    row: 1,
    tier: 2,
  );
  print(plan);
}
