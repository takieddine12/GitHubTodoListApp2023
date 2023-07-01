

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

}