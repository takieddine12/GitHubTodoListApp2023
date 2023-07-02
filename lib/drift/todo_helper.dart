

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

  // filter list
  Future<List<Task>> getFilteredTasks(String query) => (select(tasks)..where((tbl) => tbl.title.equals(query))).get();

  Future<List<Task>> getTasks() => select(tasks).get();

  Future<int> saveTask(TasksCompanion companion) =>
      into(tasks).insert(companion);

  Future<int> deleteAllTasks() => delete(tasks).go();

  Future<int> deleteTask(int id) =>
      (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateTask(Task task) =>
      (update(tasks)..where((tbl) => tbl.id.equals(task.id))).write(TasksCompanion(isChecked : Value(task.isChecked)));

  Future<int> updateFullTask(Task task) =>
      (update(tasks)..where((tbl) => tbl.id.equals(task.id))).write(TasksCompanion(
          id: Value(task.id),
          title: Value(task.title),
          date: Value(task.date),
          hour: Value(task.hour),
          hourFormat: Value(task.hourFormat),
          isChecked : Value(task.isChecked)));

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'employee.db'));
    return NativeDatabase(file);
  });
}

