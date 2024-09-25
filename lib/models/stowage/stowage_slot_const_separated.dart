import 'package:stowage_plan/models/container/container.dart';
import 'package:stowage_plan/models/stowage/stowage_slot.dart';
///
/// A stowage slot that is always separated from slot of previous tier
/// by at least specified distance.
class StowageSlotConstSeparated implements StowageSlot {
  ///
  /// 2.59 m in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  static const double _standardHeight = 2.59;
  //
  @override
  final int bay;
  //
  @override
  final int row;
  //
  @override
  final int tier;
  //
  @override
  final double x1;
  //
  @override
  final double x2;
  //
  @override
  final double y1;
  //
  @override
  final double y2;
  //
  @override
  final double z1;
  //
  @override
  final double z2;
  //
  @override
  final double zMax;
  //
  @override
  final double zMinSeparation;
  ///
  /// Creates a stowage slot with the given fields.
  /// If a slot of next tier is created,
  /// rules for its separation along the vertical axis
  /// will be identical.
  const StowageSlotConstSeparated({
    required this.bay,
    required this.row,
    required this.tier,
    required this.x1,
    required this.x2,
    required this.y1,
    required this.y2,
    required this.z1,
    required this.z2,
    required this.zMax,
    required this.zMinSeparation,
  });
  //
  @override
  StowageSlot? upper({double zOffset = 0.0}) {
    final tierUpper = tier + 2;
    final z1Upper = z2 + zMinSeparation + zOffset;
    final z2Upper = z1Upper + _standardHeight;
    if (z2Upper > zMax) return null;
    return copyWith(
      tier: tierUpper,
      z1: z1Upper,
      z2: z2Upper,
      zMinSeparation: zMinSeparation,
    );
  }
  //
  @override
  StowageSlot? fitted({
    required Container container,
  }) =>
      copyWith(z2: z1 + container.height / 1000);
  //
  @override
  StowageSlot copyWith({
    double? zMinSeparation,
    int? bay,
    int? row,
    int? tier,
    double? x1,
    double? x2,
    double? y1,
    double? y2,
    double? z1,
    double? z2,
    double? zMax,
    double? zTopSeparation,
  }) =>
      StowageSlotConstSeparated(
        bay: bay ?? this.bay,
        row: row ?? this.row,
        tier: tier ?? this.tier,
        x1: x1 ?? this.x1,
        x2: x2 ?? this.x2,
        y1: y1 ?? this.y1,
        y2: y2 ?? this.y2,
        z1: z1 ?? this.z1,
        z2: z2 ?? this.z2,
        zMax: zMax ?? this.zMax,
        zMinSeparation: zMinSeparation ?? this.zMinSeparation,
      );
}
