import 'package:flutter/foundation.dart';
import 'package:restaurant_flutter/models/task.dart';
import 'dart:collection';
import 'package:http/http.dart' as http;

var createurl =
    Uri.parse('https://www.restaurant-list.com/www.restaurant-list.com');
sendRequest() async {
  Map data = {
    'todo_description': 'fluttertest',
    'todo_priority': '',
    'todo_completed': 'false',
    'user_id': "null"
  };

  var url = 'https://www.restaurant-list.com/todos/add/';
  http
      .post(Uri.https('www.restaurant-list.com', '/todos/add/'), body: data)
      .then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

//todo create nodejs post and get requests here
class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Example Task 1', priority: 'High'),
    Task(name: 'Example Task 2', priority: 'Low')
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle, String newTaskPriority) {
    final task = Task(name: newTaskTitle, priority: newTaskPriority);
    _tasks.add(task);
    sendRequest();
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
