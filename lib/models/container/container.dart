import 'package:stowage_plan/models/container/container_1aa.dart';
import 'package:stowage_plan/models/container/container_1cc.dart';
///
/// Simple representation of freight container;
abstract interface class Container {
  ///
  /// Size of container along the longitudinal axis, measured in mm.
  int get width;
  ///
  /// Size of container along the transverse axis, measured in mm.
  int get length;
  ///
  /// Size of container along the vertical axis, measured in mm.
  int get height;
  ///
  /// Combined weight of container plus cargo, measured in t;
  double get grossWeight;
  ///
  /// Creates container from its [sizeCode]
  /// in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html).
  /// Gross weight of container is calculated
  /// as the sum of [tareWeight] (tons) and [cargoWeight] (tons).
  /// Throws [ArgumentError] if [sizeCode] is incorrect.
  factory Container.fromSizeCode(
    String sizeCode, {
    double tareWeight = 0.0,
    double cargoWeight = 0.0,
  }) =>
      switch (sizeCode.trim().toUpperCase()) {
        '1AA' => Container1AA(
            tareWeight: tareWeight,
            cargoWeight: cargoWeight,
          ),
        '1CC' => Container1CC(
            tareWeight: tareWeight,
            cargoWeight: cargoWeight,
          ),
        _ => throw ArgumentError(sizeCode, 'sizeCode'),
      };
}
