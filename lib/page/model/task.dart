import 'dart:convert';

class TaskFactory {
  static Task create(String jsonString) {
    var jsonMap = jsonDecode(jsonString);
    var task = TaskFactory._fromJson(jsonMap);
    return task;
  }
  static List<Task> createList(String jsonString) {
    var jsonMap = jsonDecode(jsonString);
    var task = jsonMap.cast<Map<String, dynamic>>().map<Task>((json) => TaskFactory._fromJson(json))
        .toList();
    return task;
  }

  static Task _fromJson(Map<String, dynamic> json) {
    var task = Task();

    task._date = json["date"];
    task._time = json["time"];
    task._name = json["name"];
    task._desc = json["desc"];
    task._isFinish = json["isFinish"];
    task._id = json["id"];

    return task;
  }

  Map<String, dynamic> toJson(Task task) {
    final Map<String, dynamic> map = new Map<String, dynamic>();

    map["date"] = task._date;
    map["time"] = task.time;
    map["name"] = task._name;
    map["desc"] = task._desc;
    map["isFinish"] = task._isFinish;
    map["id"] = task._id;

    return map;
  }
}

class Task {
  String? _date;
  String? _time;
  String? _name;
  String? _desc;
  bool? _isFinish;
  String? _id;

  String? get date => _date;

  String? get time => _time;

  String? get name => _name;

  String? get desc => _desc;


  bool? get isFinish => _isFinish;

  String? get id => _id;

  set isFinish(i) => _isFinish=i;
  set time(i) => _time=i;

  Task(
      {String? date,
      String? time,
      String? name,
      String? desc,
      bool? isFinish,
      String? id}) {
    _date = date;
    _time = time;
    _name = name;
    _desc = desc;
    _isFinish = isFinish;
    _id = id;
  }
}
