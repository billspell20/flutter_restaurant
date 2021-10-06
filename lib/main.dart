import 'package:flutter/material.dart';
import 'package:restaurant_flutter/screens/tasks_screen.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/screens/login_screen.dart';
import 'package:restaurant_flutter/screens/registration_screen.dart';
import 'package:restaurant_flutter/screens/welcome_screen.dart';
import 'package:restaurant_flutter/models/task_data.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => TaskData(),
        child: MaterialApp(
          home: WelcomeScreen(),
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            TasksScreen.id: (context) => TasksScreen(),
          },
        ));
  }
}

