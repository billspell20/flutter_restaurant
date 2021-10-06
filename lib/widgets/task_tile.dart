import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final String taskPriority;
  final Function(bool?) checkboxCallback;
  final VoidCallback deleteButtonCallback;

  TaskTile(
      {required this.isChecked,
      required this.taskTitle,
      required this.taskPriority,
      required this.checkboxCallback,
      required this.deleteButtonCallback,
      taskUser});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        taskTitle,
        style: TextStyle(
            decoration: isChecked ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(
        ('Priority: ' + taskPriority),
        style: TextStyle(
            decoration: isChecked ? TextDecoration.lineThrough : null),
      ),
      leading: Checkbox(
        activeColor: const Color(0xFF282c34),
        value: isChecked,
        onChanged: checkboxCallback,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        color: Colors.redAccent,
        onPressed: deleteButtonCallback,
      ),
    );
  }
}
