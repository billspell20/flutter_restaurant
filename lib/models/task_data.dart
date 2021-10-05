import 'package:flutter/foundation.dart';
import 'package:restaurant_flutter/models/task.dart';
import 'dart:collection';
import 'package:http/http.dart' as http;

var createurl = Uri.parse('https://www.restaurant-list.com/todos/add/');

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

  Future<void> addTask(String newTaskTitle, String newTaskPriority) async {
    final task = Task(name: newTaskTitle, priority: newTaskPriority);
    _tasks.add(task);
    var response = await http.post(createurl, body: {
      'todo_description': 'flutter test',
      'todo_priority': '',
      'todo_completed': false,
      'user_id': "null"
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
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
