import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_flutter/models/user.dart';
import 'package:restaurant_flutter/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/models/task_data.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        var taskList0 = taskData.myTasks;

        print(taskList0);
        print('hi');
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskList0[index];
            return TaskTile(
              taskTitle: task.name,
              taskPriority: task.priority,
              isChecked: task.isDone,
              checkboxCallback: (checkboxState) {
                taskData.updateTask(task);
              },
              deleteButtonCallback: () {
                taskData.deleteTask(task);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
