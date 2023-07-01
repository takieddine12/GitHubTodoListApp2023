
import 'package:drift/src/runtime/query_builder/query_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../drift/todo_helper.dart';
import 'TaskService.dart';

class TaskController extends GetxController {

  final TaskService _service = TaskService();

  final Rx<List<Task>?> tasksList = Rx(null);



  void getTasks(){
     _service.getTasks().then((value){
       tasksList.value = value;
     });
  }

  Future<int> insertTask(TasksCompanion companion) async {
    return await _service.insertTask(companion);
  }
  Future<int> deleteTasks() async {
    return await _service.deleteAll();
  }
  Future<int> deleteTask(int index) async {
    return await _service.deleteTask(index);
  }

  Future<int> updateTask(Task task) async {
    return await _service.updateTask(task);
  }

}