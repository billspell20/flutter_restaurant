import 'package:flutter/material.dart';
import 'package:restaurant_flutter/screens/tasks_screen.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/models/task_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TaskData(),
      child: MaterialApp(
        home: TasksScreen(),
      ),
    );
  }
}
