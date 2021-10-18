import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_flutter/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/models/task_data.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  late var resetArray;

  @override
  void initState() {
    super.initState();
    setState(() {
      resetArray = TaskData().callReq();
    });
    _getNewArray();
  }

  _getNewArray() {
    resetArray = TaskData().callReq();
    return resetArray;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return FutureBuilder(
          future: _getNewArray(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    var task = taskData.tasks[index];
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
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    });
  }
}
