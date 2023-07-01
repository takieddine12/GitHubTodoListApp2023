

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'todo_helper.g.dart';

@DriftDatabase(
  include: {'tasks.drift'}
)
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;


  Future<List<Task>> getTasks() => select(tasks).get();

  Future<int> saveTask(TasksCompanion companion) => into(tasks).insert(companion);

  Future<int> deleteAllTasks() => delete(tasks).go();

  Future<int> deleteTask(int id) => (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();

  // Future<int> updateEmployee(TasksCompanion companion) async {
  //   return await update(tasks).write(TasksCompanion(
  //       title: Value(companion.name)
  //   ));
  // }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'employee.db'));
    return NativeDatabase(file);
  });
}

