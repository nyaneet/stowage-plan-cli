import 'package:stowage_plan/models/container/container.dart';
import 'package:stowage_plan/models/stowage/stowage_slot.dart';
///
/// Simple representation of stowage plan,
/// in accordance with [ISO 9711-1](https://www.iso.org/ru/standard/17568.html)
abstract interface class StowagePlan {
  ///
  /// Returns stowage slot with loaded into it container
  /// at position specified by [bay], [row] and [tier] numbers.
  ///
  /// Returns `null` if stowage slot at specified position does not exist.
  ({StowageSlot slot, Container? container})? stowageAtOrNull(
    int bay,
    int row,
    int tier,
  );
  ///
  /// Creates [List] with all stowage slots and containers loaded into them
  /// filtered by given [bay], [row] and [tier] numbers.
  List<({StowageSlot slot, Container? container})> toStowageList({
    int? bay,
    int? row,
    int? tier,
  });
  ///
  /// Puts [container] into stowage slot with position specified by
  /// [bay], [row] and [tier] numbers.
  void putContainerAt(
    Container container, {
    required int bay,
    required int row,
    required int tier,
  });
  ///
  /// Removes container from stowage slot with position specified by
  /// [bay], [row] and [tier] numbers.
  void removeContainerAt({
    required int bay,
    required int row,
    required int tier,
  });
}
