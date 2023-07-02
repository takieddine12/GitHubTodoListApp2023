

import 'package:todo_app/drift/todo_helper.dart';

class TaskService {

  final MyDatabase _myDatabase = MyDatabase();

  Future<List<Task>?> getTasks() async {
   return await _myDatabase.getTasks();

  }

  Future<int> insertTask(TasksCompanion companion) async {
     return await _myDatabase.saveTask(companion);
  }

  Future<int> deleteAll() async {
    return await _myDatabase.deleteAllTasks();
  }

  Future<int> deleteTask(int index) async {
    return await _myDatabase.deleteTask(index);
  }

  Future<int> updateTask(Task task) async {
    return await _myDatabase.updateTask(task);
  }
  Future<int> updateFullTask(Task task) async {
    return await _myDatabase.updateFullTask(task);
  }

  Future<List<Task>> getFilteredTasks(String query) async {
    return await _myDatabase.getFilteredTasks(query);
  }

}