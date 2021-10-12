import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_flutter/models/task.dart';
import 'dart:collection';
import 'package:objectid/objectid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

getUserId() async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  return currentUser.uid;
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
  print(idString);
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

//check if get req empty, else return list
class TaskData extends ChangeNotifier {
  List<Task> tasks1 = [];
  List<Task> get _tasks => tasks1;

  void callReq() async {
    tasks1 = await getRequestList();
    notifyListeners();
  }

  TaskData() {
    callReq();
    notifyListeners();
  }

  /*get myTasks => _tasks;

  void search() async {
    try {
      _tasks.add(getRequestList());
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

   Task(
      id: ObjectId().toString(),
      name: 'Example Task 13333333',
      priority: 'High',
    ),
    Task(
      id: ObjectId().toString(),
      name: 'Example Task 2',
      priority: 'Low',
    )*/

  /*List<Task> _tasks = json
      .decode(await getRequestTasks())
      .map((model) => Task.fromJson(model))
      .toList();*/

  /*void generateTaskList() async {
    //Check if user has existing items, if not generate examples
    print(_tasks);
    if (_tasks.isEmpty) {
      _tasks = [
        Task(
          id: ObjectId().toString(),
          name: 'Example Task 13333',
          priority: 'High',
        ),
        Task(
          id: ObjectId().toString(),
          name: 'Example Task 2',
          priority: 'Low',
        )
      ];
      notifyListeners();
    } else {
      print('hi');
      _tasks = [
        Task(
          id: ObjectId().toString(),
          name: 'Example Task 13333333',
          priority: 'High',
        ),
        Task(
          id: ObjectId().toString(),
          name: 'Example Task 2',
          priority: 'Low',
        )
      ];*/

//  List<Task> _tasks = [
  //  Task(id: ObjectId().toString(), name: 'Example Task 1', priority: 'High'),
  // Task(id: ObjectId().toString(), name: 'Example Task 2', priority: 'Low')
  //];

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
}
