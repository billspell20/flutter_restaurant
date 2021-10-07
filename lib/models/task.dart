class Task {
  final String id;
  final String name;
  bool isDone;
  final String priority;
  Task(
      {required this.id,
      required this.name,
      required this.priority,
      this.isDone = false});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['todo_description'],
        priority = json['todo_priority'],
        isDone = json['todo_completed'];

  void toggleDone() {
    isDone = !isDone;
  }
}
