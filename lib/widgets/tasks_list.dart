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
/*  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<void> _someFuture() {
    return _memoizer.runOnce(() async {
      await TaskData().callReq();
    });
  }*/
  late final Future<List<Task>> future;
  Future<List> setSelectedList() {
    setState(() {
      late var future = TaskData().callReq();
    });
    return future;
  }

  @override
  Widget build(BuildContext context) {
    /*body:
    return ChangeNotifierProvider<TaskData>(
        create: (context) => TaskData(),*/
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return FutureBuilder(
          future: setSelectedList(),
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
