
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/drift/todo_helper.dart';
import 'package:todo_app/extras.dart';
import 'package:todo_app/ui/add_task_page.dart';
import 'package:todo_app/ui/edit_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task>? _tasks  = [];
  late TaskController _taskController;
  final TextEditingController _searchController = TextEditingController();
  String query  = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController = Get.put(TaskController());
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
          },backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.add,color: Colors.white,size: 25,),),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 10,top: 20),
              child: Row(
                children: [
                  Expanded(child: Text("Daily Plans",style: getFont(),)),
                  IconButton(onPressed: () async {
                    
                    await showDialog(
                        context: context,
                        builder: (context) {
                           return AlertDialog(
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                             title:  Text("Delete Tasks!",style: getFont().copyWith(fontSize: 18),),
                             content:  Text("Are you sure you want to delete all tasks ?",style: getFont().copyWith(fontSize: 15),),
                             actions: [
                               ElevatedButton(onPressed: () async {
                                 int result = await _taskController.deleteTasks();
                                 if(result == -1){
                                   if(mounted){
                                     FlutterToastr.show("Could Not Delete Tasks", context);
                                     Navigator.pop(context);
                                   }
                                 }
                                 else {
                                   if(mounted){
                                     FlutterToastr.show("All Items Were Successfully Deleted", context);
                                     _taskController.getTasks();
                                     Navigator.pop(context);
                                   }
                                 }
                               }, child:  Text("Yes",style: getFont().copyWith(fontSize: 15,color: Colors.white),)),
                               ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                               }, child:  Text("No" , style: getFont().copyWith(fontSize: 15,color: Colors.white)))
                             ],
                           );
                        });
                  }, icon: const Icon(Icons.delete,size: 30,))
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: SizedBox(
                  width: double.maxFinite,
                  height : 50,
                  child:  Row(
                    children: [
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value){
                            // use this value to filter list
                            setState(() {
                              query = value;
                            });
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: getFont().copyWith(fontSize: 15,color: Colors.blueGrey),
                              hintText: "search for task.."
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      IconButton(onPressed: (){
                        _taskController.getTasks();
                      }, icon: const Icon(Icons.search,color: Colors.black87, size: 25,))
                    ],
                  ),
                ),

              ),
            ),
            Obx(() {
              if(query.isEmpty){
                _tasks  = _taskController.tasksList.value!;
              } else {
                _tasks = _tasks!.where((element) => element.title!.toLowerCase().contains(query.toLowerCase())).toList();
              }

              if(_tasks == null){
                return  Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.deepOrange,),
                  ),
                );
              }
              else if (_tasks!.isEmpty){
                return Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                  child: Center(
                    child: Text('No Tasks Available',style: getFont().copyWith(fontSize: 22),),
                  ),
                );
              }
              else {
                return Expanded(
                  child: ListView.builder(
                    itemCount:  _tasks!.length ,
                    itemBuilder: (context , index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16,top: 8),
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) async {
                            if(direction == DismissDirection.startToEnd){
                              int result = await _taskController.deleteTask(_taskController.tasksList.value![index].id);
                              if(result == -1){
                                if(mounted){
                                  FlutterToastr.show('Failed To Delete Task', context);
                                }
                              }
                              else {
                                if(mounted){
                                  FlutterToastr.show('Task Successfully Deleted', context);
                                  _taskController.getTasks();
                                }
                              }
                            }
                          },
                          child: GestureDetector(
                            onTap: (){
                              // we send data to the next screen
                              Navigator.push(context, MaterialPageRoute(builder: (_) => EditTaskPage(task: _tasks![index])));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _tasks![index].isChecked == 0 ? false : true,
                                      onChanged: (value){
                                        if(value == true){
                                          Task task = Task(
                                              id:  _tasks![index].id,
                                              title:  _tasks![index].title,
                                              date:  _tasks![index].date,
                                              hour:  _tasks![index].hour,
                                              hourFormat:  _tasks![index].hour,
                                              isChecked : 1
                                          );
                                          _taskController.updateTask(task);
                                          _taskController.getTasks();
                                        } else {
                                          Task task = Task(
                                              id:  _tasks![index].id,
                                              title:  _tasks![index].title,
                                              date:  _tasks![index].date,
                                              hour:  _tasks![index].hour,
                                              hourFormat:  _tasks![index].hour,
                                              isChecked : 0
                                          );
                                          _taskController.updateTask(task);
                                          _taskController.getTasks();
                                        }
                                  }),
                                  const SizedBox(width: 10,),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text( _tasks![index].title!,
                                        style: getFont().copyWith(fontSize: 17,decoration: _tasks![index].isChecked == 1 ? TextDecoration.lineThrough : TextDecoration.none),),
                                      Text("On :  ${ _tasks![index].date!}",
                                        style: getFont().copyWith(fontSize: 15 , color: Colors.indigo,decoration:  _tasks![index].isChecked == 1 ? TextDecoration.lineThrough : TextDecoration.none),),
                                      Text("At :  ${ _tasks![index].hourFormat!}",
                                        style: getFont().copyWith(fontSize: 15,color: Colors.green,decoration:  _tasks![index].isChecked == 1 ? TextDecoration.lineThrough : TextDecoration.none),)
                                    ],
                                  )),
                                  Visibility(
                                     visible:  _tasks![index].isChecked == 0 ? false : true,
                                     child :  IconButton(onPressed: () async {
                                       int result = await _taskController.deleteTask(_taskController.tasksList.value![index].id);
                                       if(result == -1){
                                         if(mounted){
                                           FlutterToastr.show('Failed To Delete Task', context);
                                         }
                                       }
                                       else {
                                         if(mounted){
                                           FlutterToastr.show('Task Successfully Deleted', context);
                                           _taskController.getTasks();
                                         }
                                       }
                                     }, icon: const Icon(Icons.delete,size: 30,color: Colors.blueGrey,))
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              
            })
          ],
        ),
      ),
    );
  }





}
