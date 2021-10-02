class Task {
  final String name;
  bool isDone;
  final String priority;
  Task({required this.name, required this.priority, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}
