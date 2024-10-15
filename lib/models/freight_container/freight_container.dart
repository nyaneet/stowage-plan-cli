import 'package:stowage_plan/models/freight_container/container_1aa.dart';
import 'package:stowage_plan/models/freight_container/container_1cc.dart';
import 'package:stowage_plan/models/freight_container/freight_container_type.dart';
///
/// Simple representation of freight container;
abstract interface class FreightContainer {
  ///
  /// Unique identifier of container.
  int get id;
  ///
  /// Size of container along the longitudinal axis, measured in m.
  double get width;
  ///
  /// Size of container along the transverse axis, measured in m.
  double get length;
  ///
  /// Size of container along the vertical axis, measured in m.
  double get height;
  ///
  /// Weight of empty container, measured in t.
  double get tareWeight;
  ///
  /// Weight of cargo inside container, measured in t.
  double get cargoWeight;
  ///
  /// Combined weight of container plus cargo, measured in t;
  double get grossWeight;
  ///
  /// Type of container.
  /// In accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
  FreightContainerType get type;
  ///
  /// Creates a [FreightContainer] instance based on its [sizeCode],
  /// as defined in [ISO 668](https://www.iso.org/ru/standard/76912.html).
  ///
  /// The [sizeCode] should be a string representing the container size and type
  /// (e.g., '1AA' for a 40ft standard container, '1CC' for a 20ft standard container).
  ///
  /// The [id] parameter specifies the unique identifier of the container.
  ///
  /// The [tareWeight] (tons) and [cargoWeight] (tons) parameters specify weight of empty
  /// container and weight of cargo inside container, respectively.
  /// The gross weight of container is calculated as the sum of these two weights.
  ///
  /// Throws an [ArgumentError] if the [sizeCode] is invalid.
  factory FreightContainer.fromSizeCode(
    String sizeCode, {
    required int id,
    double tareWeight = 0.0,
    double cargoWeight = 0.0,
  }) =>
      switch (sizeCode.trim().toUpperCase()) {
        '1AA' => Container1AA(
            id: id,
            tareWeight: tareWeight,
            cargoWeight: cargoWeight,
          ),
        '1CC' => Container1CC(
            id: id,
            tareWeight: tareWeight,
            cargoWeight: cargoWeight,
          ),
        _ => throw ArgumentError(sizeCode, 'sizeCode'),
      };
}
