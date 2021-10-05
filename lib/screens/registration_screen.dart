import 'package:flutter/material.dart';
import 'package:restaurant_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_flutter/screens/tasks_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      child: Icon(
                        Icons.arrow_back_sharp,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      backgroundColor: Color(0xFF282c34),
                      radius: 30.0,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: const Image(
                        image: AssetImage('lib/images/coffee0.png')),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextButton(
                style: flatButtonStyle,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, TasksScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final ButtonStyle flatButtonStyle = OutlinedButton.styleFrom(
  primary: Colors.white,
  minimumSize: const Size(88, 44),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  side: const BorderSide(width: 2, color: Color(0xFF282c34)),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  backgroundColor: Colors.white, //const Color(0xFF282c34),
);
