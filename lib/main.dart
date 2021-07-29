import 'package:flutter/material.dart';
import 'package:flutter_app/page/event_page/event_page.dart';
import 'package:flutter_app/page/model/task.dart';
import 'package:flutter_app/page/task_page/resources/task_data.dart';
import 'package:flutter_app/page/task_page/resources/task_requests.dart';
import 'package:flutter_app/page/task_page/task_page.dart';
import 'package:flutter_app/provider.dart';
import 'package:flutter_app/widgets/custom_datetime_picker.dart';
import 'package:flutter_app/widgets/custom_modal_button.dart';

import 'fetch.dart';
import 'widgets/custom_text_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String _selectedDate = 'Pick date';
  String _selectedTime = 'Pick time';

  Future _pickDate() async {
    DateTime? datepick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));
    if (datepick != null)
      setState(() {
        _selectedDate = datepick.toString();
      });
  }

  Future _pickTime() async {
    TimeOfDay? timepick = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());
    if (timepick != null) {
      setState(() {
        _selectedTime = (timepick.hour.toString()+":"+timepick.minute.toString());
      });
    }
  }

  late TabController controller;
  var taskProvider =
      Provider<List<Task>?>(providerKey: "TaskProviderKey", value: null);
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDesc = TextEditingController();

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    taskProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Fetch<List<Task?>, TaskFetchParams>(
        request: getTaskByTime,
        params: TaskFetchParams(body: Task(date: "Friday")),
        builder: (fetchState) {
          if (fetchState.loading == true) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepOrange,
              ),
            );
          }
          if (fetchState.response == null) {
            return Text("NULL", textDirection: TextDirection.ltr);
          }
          Provider.providers["TaskProviderKey"] = fetchState.response!;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      controller: controller,
                      tabs: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: controller.index == 0
                                ? Colors.redAccent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          width: (MediaQuery.of(context).size.width - 40) / 2,
                          child: Center(
                            child: Text(
                              "Tasks",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: controller.index == 0
                                    ? Colors.white
                                    : Colors.redAccent,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: controller.index == 1
                                ? Colors.redAccent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          width: (MediaQuery.of(context).size.width - 40) / 2,
                          child: Center(
                            child: Text(
                              "Events",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: controller.index == 1
                                    ? Colors.white
                                    : Colors.redAccent,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: [
                        TaskPage(),
                        EventPage(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return Dialog(
                          child: Fetch<Task?, TaskFetchParams>(
                            request: addTask,
                            lazy: true,
                            onSuccess: (task) {
                              print("success");
                              (Provider.providers["TaskProviderKey"] as List<Task>).add(task!);
                              var callbacks = Provider.callbacks.where(
                                  (element) =>
                                      element.providerKey == "TaskProviderKey");

                              for (var callback in callbacks) {
                                callback.callbackFunc(
                                    Provider.providers["TaskProviderKey"]);
                              }
                              Navigator.pop(context);
                            },
                            builder: (fetchStateButton) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Center(
                                            child: Text(
                                          "Add new event",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomTextField(
                                          labelText: 'Enter event name',
                                          controller: txtName,
                                        ),
                                        SizedBox(height: 12),
                                        CustomTextField(
                                          labelText: 'Enter description',
                                          controller: txtDesc,
                                        ),
                                        SizedBox(height: 12),
                                        CustomDateTimePicker(
                                          icon: Icons.date_range,
                                          onPressed: _pickDate,
                                          value: _selectedDate,
                                        ),
                                        CustomDateTimePicker(
                                          icon: Icons.access_time,
                                          onPressed: _pickTime,
                                          value: _selectedTime,
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomModalActionButton(
                                          onClose: () {
                                            Navigator.of(context).pop();
                                          },
                                          onSave: () {
                                            fetchStateButton.fetch(
                                                TaskFetchParams(
                                                    body: Task(
                                                        name: txtName.text,
                                                        desc: txtDesc.text,
                                                        date: "Friday",
                                                        isFinish: false,
                                                        time: DateTime.now().toString(),)));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  if (fetchStateButton.loading == true)
                                    Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.deepOrange,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))));
                    });
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        });
  }
}
