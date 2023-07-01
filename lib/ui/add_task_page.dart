
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/drift/todo_helper.dart';
import 'package:todo_app/extras.dart';
import 'package:drift/drift.dart' as d;
import 'package:todo_app/ui/home_page.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TaskController _taskController;
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();
  final TextEditingController _taskHourController = TextEditingController();
  late String pickedDay;
  late String pickedHour;
  late String hourAmPm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
                child: Text("Add New Task",style: getFont(),),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
                child: Text("Task",style: getFont().copyWith(fontSize: 17),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                child: TextField(
                  controller: _taskTitleController,
                  onChanged: (value){

                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    hintText: "Task Title",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                    hintStyle: getFont().copyWith(fontSize: 13)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
                child: Text("Date",style: getFont().copyWith(fontSize: 17),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                child: TextField(
                  controller: _taskDateController,
                  onChanged: (value){
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)
                      ),
                      hintText: "Task Date",
                      suffixIcon: IconButton(onPressed: (){
                        pickDate();
                      }, icon: const Icon(Icons.calendar_month)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      hintStyle: getFont().copyWith(fontSize: 13)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
                child: Text("Hour",style: getFont().copyWith(fontSize: 17),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                child: TextField(
                  controller: _taskHourController,
                  showCursor: true,
                  onChanged: (value){
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)
                      ),
                      hintText: "Task Hour",
                      suffixIcon: IconButton(onPressed: (){
                         pickHour();
                      }, icon: const Icon(Icons.timer_sharp)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      hintStyle: getFont().copyWith(fontSize: 13)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 40),
                child: GestureDetector(
                  onTap: () async {

                    var title = _taskTitleController.text.toString();
                    var date = _taskDateController.text.toString();
                    var hour = _taskHourController.text.toString();

                    if(title.trim().isEmpty){
                      return FlutterToastr.show("Title cannot be empty", context);
                    }
                    if(date.trim().isEmpty){
                      return FlutterToastr.show("Date cannot be empty", context);
                    }
                    if(hour.trim().isEmpty){
                      return FlutterToastr.show('Hour cannot be empty', context);
                    }

                    TasksCompanion task =  TasksCompanion(
                        title: d.Value(title),
                        date:  d.Value(date),
                        hour:  d.Value(hour),
                        hourFormat: d.Value(hourAmPm));
                    int result = await _taskController.insertTask(task);
                    if(result == -1){
                      if(mounted){
                        FlutterToastr.show("Failed to add task", context);
                      }
                    }
                    else {
                      if(mounted){
                        FlutterToastr.show("Task successfully added", context);
                      }
                    }

                    Future.delayed(const Duration(seconds: 2),(){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                    });

                  },
                  child: Container(
                    width: double.maxFinite,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.indigo
                    ),
                    child: Center(
                      child: Text("Submit",style: getFont().copyWith(fontSize: 15,color: Colors.white),),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.maxFinite,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: const Color(0xff343333ff),
                    ),
                    child: Center(
                      child: Text("Cancel",style: getFont().copyWith(fontSize: 15,color: Colors.white),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickDate() async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2030));

    if(pickedDate != null){
      String formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        pickedDay = formattedDate;
        _taskDateController.text = pickedDay;
      });
    }

  }
  void pickHour() async {
    var hour = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());

    if(hour != null){
      if(mounted){
        var df = DateFormat("hh:mm");
        var dfPM = DateFormat('h a');
        var dt = df.parse(hour.format(context));
        setState(() {
          pickedHour = df.format(dt);
          _taskHourController.text = pickedHour;
           hourAmPm = dfPM.format(dt);
        });
      }
    }
  }
}
