///
/// Simple representation of stowage slot,
/// a place where container can be loaded.
abstract interface class StowageSlot {
  ///
  /// Bay number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.1](https://www.iso.org/ru/standard/17568.html)
  int get bay;
  ///
  /// Row number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.2](https://www.iso.org/ru/standard/17568.html)
  int get row;
  ///
  /// Tier number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  int get tier;
  ///
  /// Coordinate of the leftmost point of stowage slot
  /// along the longitudinal axis, measured in m.
  double get x1;
  ///
  /// Coordinate of the rightmost point of stowage slot
  /// along the longitudinal axis, measured in m.
  double get x2;
  ///
  /// Coordinate of the leftmost point of stowage slot
  /// along the transverse axis, measured in m.
  double get y1;
  ///
  /// Coordinate of the rightmost point of stowage slot
  /// along the transverse axis, measured in m.
  double get y2;
  ///
  /// Coordinate of the leftmost point of stowage slot
  /// along the vertical axis, measured in m.
  double get z1;
  ///
  /// Coordinate of the rightmost point of stowage slot
  /// along the vertical axis, measured in m.
  double get z2;
  ///
  /// Maximum allowed value of the rightmost point of stowage slot
  /// along the vertical axis, measured in m.
  double get zMax;
  ///
  /// Offset value to next stowage slot along the vertical axis,
  /// measured in m.
  double get zTopSeparation;
}