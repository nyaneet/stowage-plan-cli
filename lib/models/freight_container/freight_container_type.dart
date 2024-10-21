///
/// Type of container.
/// In accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
enum FreightContainerType {
  ///
  /// 40 ft container with TODO height,
  type1A('1A', '40'),
  ///
  /// 20 ft container with TODO height,
  type1C('1C', '20'),
  ///
  /// 40 ft container with standard height,
  type1AA('1AA', '42'),
  ///
  /// 20 ft container with standard height,
  type1CC('1CC', '22');
  //
  final String isoName;
  //
  final String lengthCode;
  ///
  const FreightContainerType(this.isoName, this.lengthCode);
}
