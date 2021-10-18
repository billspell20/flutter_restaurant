import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_flutter/models/task.dart';
import 'dart:collection';
import 'package:objectid/objectid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

getUserId() async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  if (currentUser == null) {
    return "";
  } else {
    return currentUser.uid;
  }
}

sendRequestAdd(Task task) async {
  Map data = {
    '_id': task.id,
    'todo_description': task.name,
    'todo_priority': task.priority,
    'todo_completed': 'false',
    'user_id': await getUserId()
  };
  var urlEndPoint = '/todos/add/';
  http
      .post(Uri.https('www.restaurant-list.com', urlEndPoint), body: data)
      .then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

sendRequestUpdate(Task task) async {
  Map data = {
    'todo_description': task.name,
    'todo_priority': task.priority,
    'todo_completed': task.isDone.toString(),
  };

  var urlEndPoint = '/todos/update/' + task.id + '/';
  http
      .post(Uri.https('www.restaurant-list.com', urlEndPoint), body: data)
      .then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

sendRequestDelete(todo) async {
  http
      .delete(
          Uri.https('www.restaurant-list.com', '/todos/delete/' + todo + '/'))
      .then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

getRequestList() async {
  String idString = await getUserId();
  List<Task> emptyListVar = [];
  if (idString.isEmpty) {
    return emptyListVar;
  }
  String urlAdd = '/todos/list/' + idString + '/';
  var response =
      await http.get(Uri.parse('https://www.restaurant-list.com' + urlAdd));
  late List<Task> tsks = [];
  var data = jsonDecode(response.body);
  for (var x in data) {
    var list = Task(
        id: x['_id'],
        name: x['todo_description'],
        priority: x['todo_priority'],
        isDone: x['todo_completed']);
    tsks.add(list);
  }
  return tsks;
}

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];

  Future<List<Task>> callReq() async {
    _tasks = await getRequestList();
    notifyListeners();
    return _tasks;
  }

  TaskData() {
    callReq();
    notifyListeners();
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle, String newTaskPriority) async {
    final task = Task(
      id: ObjectId().toString(),
      name: newTaskTitle,
      priority: newTaskPriority,
    );
    _tasks.add(task);
    await sendRequestAdd(task);
    notifyListeners();
  }

  void updateTask(Task task) async {
    task.toggleDone();
    await sendRequestUpdate(task);
    notifyListeners();
  }

  void deleteTask(Task task) async {
    _tasks.remove(task);
    await sendRequestDelete(task.id);
    notifyListeners();
  }

  void clearTasks() {
    _tasks.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  getUserId() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser == null) {
      return "";
    } else {
      return currentUser.uid;
    }
  }
}
