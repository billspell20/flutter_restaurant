import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_flutter/models/task.dart';
import 'package:restaurant_flutter/models/user.dart';
import 'package:restaurant_flutter/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/models/task_data.dart';
import 'package:async/async.dart';

final _Key0 = GlobalKey<ScaffoldState>();

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  late var resetArray;
  final AsyncMemoizer _memoizer = AsyncMemoizer();

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
    /*body:
    return ChangeNotifierProvider<TaskData>(
        create: (context) => TaskData(),*/
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
      /*builder: (context, taskData, child) {
        return ListView.builder(
          key: taskData.UserId,
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
      },
    );*/
    });
  }
}
