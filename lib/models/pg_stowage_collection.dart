import 'dart:io';
import 'package:stowage_plan/models/slot/slot.dart';
import 'package:stowage_plan/models/stowage_collection/stowage_collection.dart';
///
/// [StowageCollection] that uses [PostgreSQL] to store stowage plan.
class PgStowageCollection {
  ///
  /// Collection to store in [PostgreSQL] database.
  final StowageCollection collection;
  ///
  /// Creates [StowageCollection] that uses [PostgreSQL] to store stowage plan.
  PgStowageCollection({required this.collection});
  ///
  /// Format slot to insert into [PostgreSQL] database.
  String slotAsSqlRow(Slot slot) {
    return '(${[
      '${slot.containerId ?? 'NULL'}',
      '${slot.bay}',
      '${slot.row}',
      '${slot.tier}',
      slot.leftX.toStringAsFixed(5),
      slot.rightX.toStringAsFixed(5),
      slot.leftY.toStringAsFixed(5),
      slot.rightY.toStringAsFixed(5),
      slot.leftZ.toStringAsFixed(5),
      slot.rightZ.toStringAsFixed(5),
      slot.minVerticalSeparation.toStringAsFixed(5),
      slot.maxHeight.toStringAsFixed(5)
    ].join(', ')})';
  }
  ///
  /// Save [StowageCollection] as SQL script.
  void save([String fileName = 'pg_stowage_collection']) {
    final slots = collection.toFilteredSlotList()
      ..sort(
        (a, b) {
          final bayComparison = a.bay.compareTo(b.bay);
          if (bayComparison != 0) return bayComparison;
          final rowComparison = a.row.compareTo(b.row);
          if (rowComparison != 0) return rowComparison;
          return a.tier.compareTo(b.tier);
        },
      );
    final sql = """
      INSERT INTO
        container_slot (
          container_id,
          bay_number,
          row_number,
          tier_number,
          bound_x1,
          bound_x2,
          bound_y1,
          bound_y2,
          bound_z1,
          bound_z2,
          min_vertical_separation,
          max_height
        )
      VALUES
        ${slots.map(slotAsSqlRow).join(',\n\t\t\t\t')};
    """;
    final file = File('lib/models/$fileName.sql');
    file.writeAsStringSync(sql);
  }
}
