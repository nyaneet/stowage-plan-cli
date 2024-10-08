import 'package:stowage_plan/models/container/container.dart';
import 'package:stowage_plan/models/stowage/slot.dart';
///
/// A stowage slot with standard height
/// that is always separated from slot of next tier
/// by at least specified distance.
class StandardSlot implements Slot {
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
  final double leftX;
  //
  @override
  final double rightX;
  //
  @override
  final double leftY;
  //
  @override
  final double rightY;
  //
  @override
  final double leftZ;
  //
  @override
  final double rightZ;
  //
  @override
  final double maxHeight;
  //
  @override
  final double minVerticalSeparation;
  //
  @override
  final int? containerId;
  ///
  /// Creates a stowage slot with the given fields.
  /// If a slot of next tier is created,
  /// rules for its separation along the vertical axis
  /// will be identical.
  const StandardSlot({
    required this.bay,
    required this.row,
    required this.tier,
    required this.leftX,
    required this.rightX,
    required this.leftY,
    required this.rightY,
    required this.leftZ,
    required this.rightZ,
    required this.maxHeight,
    required this.minVerticalSeparation,
    this.containerId,
  });
  //
  @override
  Slot? createUpperSlot({double? verticalSeparation}) {
    final tierUpper = tier + 2;
    final tierSeparation = verticalSeparation ?? minVerticalSeparation;
    final leftZUpper = rightZ + tierSeparation;
    final rightZUpper = leftZUpper + _standardHeight;
    if (tierSeparation < minVerticalSeparation) return null;
    if (rightZUpper > maxHeight) return null;
    return StandardSlot(
      bay: bay,
      row: row,
      tier: tierUpper,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZUpper,
      rightZ: rightZUpper,
      maxHeight: maxHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: null,
    );
  }
  //
  @override
  Slot? withContainer(Container container) {
    if (containerId != null) return null;
    final rightZAdjusted = leftZ + container.height / 1000;
    if (rightZAdjusted > maxHeight) return null;
    return StandardSlot(
      bay: bay,
      row: row,
      tier: tier,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZ,
      rightZ: rightZAdjusted,
      maxHeight: maxHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: container.id,
    );
  }
  //
  @override
  Slot? empty() {
    if (containerId == null) return null;
    return StandardSlot(
      bay: bay,
      row: row,
      tier: tier,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZ,
      rightZ: rightZ,
      maxHeight: maxHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: null,
    );
  }
  //
  @override
  Slot copy() => StandardSlot(
        bay: bay,
        row: row,
        tier: tier,
        leftX: leftX,
        rightX: rightX,
        leftY: leftY,
        rightY: rightY,
        leftZ: leftZ,
        rightZ: rightZ,
        maxHeight: maxHeight,
        minVerticalSeparation: minVerticalSeparation,
        containerId: containerId,
      );
  //
  @override
  String toString() =>
      'Key: ${'$bay'.padLeft(2, '0')}${'$row'.padLeft(2, '0')}${'$tier'.padLeft(2, '0')}\nInstalled container: $containerId';
}
