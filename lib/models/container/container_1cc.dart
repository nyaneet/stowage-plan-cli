import 'package:stowage_plan/models/container/container.dart';
///
/// 20 ft container with standard height,
/// in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
class Container1CC implements Container {
  final double _tareWeight;
  final double _cargoWeight;
  ///
  /// Creates 20 ft container with standard height.
  /// Gross weight of container is calculated
  /// as the sum of [tareWeight] (tons) and [cargoWeight] (tons).
  const Container1CC({
    double tareWeight = 0.0,
    double cargoWeight = 0.0,
  })  : _tareWeight = tareWeight,
        _cargoWeight = cargoWeight;
  //
  @override
  int get width => 2438;
  //
  @override
  int get length => 6058;
  //
  @override
  int get height => 2591;
  //
  @override
  double get grossWeight => _tareWeight + _cargoWeight;
}
