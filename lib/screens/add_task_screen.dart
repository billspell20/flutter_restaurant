import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_flutter/models/task.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/models/task_data.dart';
import 'package:restaurant_flutter/models/user.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String radioButtonItem = 'Normal';
  int id = 2;
  String newTaskTitle = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Add Restaurant',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Color(0xFF282c34),
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 14.0, left: 14.0, right: 14.0),
                child: Text('Priority:', style: TextStyle(fontSize: 16))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: id,
                  onChanged: (value) {
                    setState(() {
                      radioButtonItem = 'Low';
                      id = 1;
                    });
                  },
                ),
                const Text(
                  'Low',
                  style: TextStyle(fontSize: 17.0),
                ),
                Radio(
                  value: 2,
                  groupValue: id,
                  onChanged: (value) {
                    setState(() {
                      radioButtonItem = 'Normal';
                      id = 2;
                    });
                  },
                ),
                const Text(
                  'Normal',
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                Radio(
                  value: 3,
                  groupValue: id,
                  onChanged: (value) {
                    setState(() {
                      radioButtonItem = 'High';
                      id = 3;
                    });
                  },
                ),
                const Text(
                  'High',
                  style: TextStyle(fontSize: 17.0),
                ),
              ],
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            TextButton(
              style: flatButtonStyle,
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Provider.of<TaskData>(context, listen: false)
                    .addTask(newTaskTitle, radioButtonItem);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  minimumSize: const Size(88, 44),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  backgroundColor: const Color(0xFF282c34),
);
