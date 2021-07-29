import 'dart:convert';

import 'package:flutter_app/page/model/task.dart';
import 'package:flutter_app/page/task_page/resources/task_data.dart';
import 'package:http/http.dart' as http;

import '../../../fetch.dart';

Future<List<Task>> getTaskByTime(TaskFetchParams? params) async {
  final response = await http.get(Uri.parse(
      "https://60ffd747bca46600171cf577.mockapi.io/Task" +
          "?search=${params!.body!.date}&sortBy=time&order=asc"));
  if (response.statusCode != 200) {
    throw FetchError(httpStatus: response.statusCode, message: response.body);
  }
  print(response.body);
  var task = TaskFactory.createList(response.body);
  return task;
}

Future<Task> setTaskFinished(TaskFetchParams? params) async {
  final response = await http.put(
    Uri.parse(
        "https://60ffd747bca46600171cf577.mockapi.io/Task/${params!.body!.id}"),
    body: jsonEncode(TaskFactory().toJson(params.body!)),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw FetchError(httpStatus: response.statusCode, message: response.body);
  }

  var task = TaskFactory.create(response.body);
  return task;
}

Future<Task> deleteTask(TaskFetchParams? params) async {
  final response = await http.delete(
    Uri.parse(
        "https://60ffd747bca46600171cf577.mockapi.io/Task/${params!.body!.id}"),
  );

  if (response.statusCode != 200) {
    throw FetchError(httpStatus: response.statusCode, message: response.body);
  }

  var task = TaskFactory.create(response.body);
  return task;
}

Future<Task> addTask(TaskFetchParams? params) async {
  final response = await http.post(
    Uri.parse("https://60ffd747bca46600171cf577.mockapi.io/Task"),
    body: jsonEncode(TaskFactory().toJson(params!.body!)),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(jsonEncode(TaskFactory().toJson(params.body!)));
  print(response.body);
  if (response.statusCode != 201) {
    throw FetchError(httpStatus: response.statusCode, message: response.body);
  }

  var product = TaskFactory.create(response.body);
  return product;
}
