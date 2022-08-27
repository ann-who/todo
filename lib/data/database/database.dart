import 'dart:io';

import 'package:drift/drift.dart';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('ToDoProperties')
class TaskTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get importance => text()();
  IntColumn get deadline => integer()();
  BoolColumn get done => boolean()();
  TextColumn get color => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get changedAt => integer()();
  TextColumn get lastUpdatedBy => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [TaskTable])
class ToDoDatabase extends _$ToDoDatabase {
  ToDoDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;
}

LazyDatabase _openConnection() => LazyDatabase(
      () async {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'db.sqlite'));
        return NativeDatabase(file);
      },
    );
