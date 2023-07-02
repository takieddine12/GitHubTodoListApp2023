import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as d;
import '../controller/task_controller.dart';
import '../drift/todo_helper.dart';
import '../extras.dart';
import 'home_page.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  const EditTaskPage({required this.task , Key? key}) : super(key: key);

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {

  late TimeOfDay _pickedTime;
  late DateTime _pickedDate;
  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late TaskController _taskController;
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();
  final TextEditingController _taskHourController = TextEditingController();
  late String _pickedDay;
  late String _pickedHour;
  late String _hourAmPm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    prePopulateViews();

    _taskController = Get.find();
    initializeNotifications();
  }

  void initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
  }
  Future<void> scheduleAlarm(DateTime selectedDate,String taskTitle) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);


    await AndroidAlarmManager.oneShotAt(
        selectedDate,
        0,
        await alarmCallback(taskTitle, platformChannelSpecifics,selectedDate),
        allowWhileIdle: true,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: false);

  }

  alarmCallback(String taskTitle,NotificationDetails notificationDetails,DateTime selectedDate) async {
    await _flutterLocalNotificationsPlugin.schedule(
        0,
        'Task Alarm',
        taskTitle,
        selectedDate,
        notificationDetails,
        payload: 'alarm',
        androidAllowWhileIdle: true);
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

                    Task task =  Task(
                        id: widget.task.id,
                        title: title,
                        date:  date,
                        hour:  hour,
                        hourFormat: _hourAmPm,
                        isChecked: widget.task.isChecked);

                    int result = await _taskController.updateFullTask(task);
                    if(result == -1){
                       if(mounted){
                         FlutterToastr.show("Could not update task", context);
                       }
                    } else {
                       if(mounted){
                         FlutterToastr.show("Task updated successfully", context);
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
                      child: Text("Update",style: getFont().copyWith(fontSize: 15,color: Colors.white),),
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
                      color:  const Color(0xff343333ff),
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
      _pickedDate = pickedDate;
      String formattedDate = DateFormat("yyyy-MM-dd").format(_pickedDate);
      setState(() {
        _pickedDay = formattedDate;
        _taskDateController.text = _pickedDay;
      });
    }

  }
  void pickHour() async {
    var hour = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());

    if(hour != null){
      if(mounted){
        _pickedTime = hour;
        var df = DateFormat("hh:mm");
        var dfPM = DateFormat('h a');
        var dt = df.parse(hour.format(context));
        setState(() {
          _pickedHour = df.format(dt);
          _taskHourController.text = _pickedHour;
          _hourAmPm = dfPM.format(dt);
        });
      }
    }
  }
  void prePopulateViews() {
    _taskTitleController.text = widget.task.title!;
    _taskDateController.text = widget.task.date!;
    _taskHourController.text = widget.task.hour!;
    _hourAmPm = widget.task.hourFormat!;
  }

}
