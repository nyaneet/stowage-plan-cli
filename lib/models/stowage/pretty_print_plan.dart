import 'package:collection/collection.dart';
import 'package:stowage_plan/models/stowage/slot.dart';
import 'package:stowage_plan/models/stowage/stowage_plan.dart';
///
/// Provides an extension method for pretty-printing a [StowagePlan].
extension PrettyPrint on StowagePlan {
  static const String _nullSlot = '    ';
  static const String _occupiedSlot = '[■] ';
  static const String _emptySlot = '[ ] ';
  static const String _rowNumbersPad = '   ';
  ///
  /// Prints a textual representation of the stowage plan
  /// for all bays.
  void printAll() {
    for (int bay in _bayIterator()) {
      printBay(bay);
    }
  }
  ///
  /// Prints a textual representation of the stowage plan
  /// for a specific [bay] to the console.
  void printBay(int bay) {
    final slotsInBay = toFilteredSlotList(bay: bay);
    if (slotsInBay.isEmpty) {
      print('No slots found for bay $bay');
      return;
    }
    print('Bay $bay:');
    final maxRow = slotsInBay.map((slot) => slot.row).reduce(
          (a, b) => a > b ? a : b,
        );
    final withZeroRow = slotsInBay.any((slot) => slot.row == 0);
    final maxTier = slotsInBay.map((slot) => slot.tier).reduce(
          (a, b) => a > b ? a : b,
        );
    for (int tier in _tierIterator(maxTier)) {
      final String tierNumber = tier.toString().padLeft(2, '0');
      String slotsLine = '';
      for (int row in _rowIterator(maxRow, withZeroRow)) {
        final slot = slotsInBay.firstWhereOrNull(
          (s) => s.row == row && s.tier == tier,
        );
        switch (slot) {
          case null:
            slotsLine += _nullSlot;
            break;
          case Slot(containerId: final int _):
            slotsLine += _occupiedSlot;
            break;
          case Slot(containerId: null):
            slotsLine += _emptySlot;
            break;
        }
      }
      if (slotsLine.trim().isNotEmpty) print('$tierNumber $slotsLine');
    }
    String rowNumbers = _rowNumbersPad;
    for (int row in _rowIterator(maxRow, withZeroRow)) {
      rowNumbers += ' ${row.toString().padLeft(2, '0')} ';
    }
    print(rowNumbers);
  }
  ///
  /// Returns [Iterable] collection of unique bay numbers
  /// present in the stowage plan, sorted in descending order.
  Iterable<int> _bayIterator() {
    final uniqueBays = toFilteredSlotList().map((slot) => slot.bay).toSet();
    final sortedBays = uniqueBays.toList()..sort((a, b) => b.compareTo(a));
    return sortedBays;
  }
  ///
  /// Returns [Iterable] collection of row numbers
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.2](https://www.iso.org/ru/standard/17568.html)
  Iterable<int> _rowIterator(int maxRow, bool withZeroRow) sync* {
    for (int row = maxRow; row >= 2; row -= 2) {
      yield row;
    }
    yield withZeroRow ? 0 : 1;
    for (int row = withZeroRow ? 1 : 3; row <= maxRow; row += 2) {
      yield row;
    }
  }
  ///
  /// Returns [Iterable] collection of tier numbers
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  Iterable<int> _tierIterator(int maxTier) sync* {
    for (int tier = maxTier; tier >= 2; tier -= 2) {
      yield tier;
    }
  }
}
