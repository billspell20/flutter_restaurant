import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_flutter/models/task.dart';
import 'dart:collection';
import 'package:objectid/objectid.dart';
import 'package:restaurant_flutter/screens/login_screen.dart';
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

//'https://www.restaurant-list.com/todos/list/' + this.state.user_id + '/'
getRequestTasks() async {
  String idString = await getUserId();
  http
      .get(Uri.https(
          'https://www.restaurant-list.com', '/todos/list/' + idString + '/'))
      .then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

//check if get req empty, else return list
class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  void generateTaskList() async {
    var taskListGetOutput = await getRequestTasks();
    print(taskListGetOutput);
    //Check if user has existing items, if not generate examples
    if (taskListGetOutput == null) {
      _tasks = [
        Task(
          id: ObjectId().toString(),
          name: 'Example Task 1',
          priority: 'High',
        ),
        Task(
          id: ObjectId().toString(),
          name: 'Example Task 2',
          priority: 'Low',
        )
      ];
      _tasks.add(_tasks[0]);
      sendRequestAdd(_tasks[0]);
      _tasks.add(_tasks[1]);
      sendRequestAdd(_tasks[1]);
      notifyListeners();
    } else {
      print('hi');
    }
  }

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
