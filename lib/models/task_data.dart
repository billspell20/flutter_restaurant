import 'package:flutter/foundation.dart';
import 'package:restaurant_flutter/models/task.dart';
import 'dart:collection';
import 'package:http/http.dart' as http;

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
