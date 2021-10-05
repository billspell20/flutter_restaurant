import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = ColorTween(begin: const Color(0xff757575), end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: const Image(
                        image: AssetImage('lib/images/coffee0.png')),
                    height: 60.0,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                SizedBox(
                  width: 280.0,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Restaurant Passport',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextButton(
              style: flatButtonStyle,
              child: const Text(
                'Log In Using Email',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            TextButton(
              style: flatButtonStyle,
              child: const Text(
                'Register using Email',
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
            TextButton.icon(
              icon: const Image(
                  image: AssetImage('lib/images/google_logo.png'), width: 20),
              label: const Text(
                'Log In with Google',
                style: TextStyle(color: Colors.teal),
              ),
              style: flatButtonStyle,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          ],
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
const colorizeColors = [
  Colors.blue,
  Colors.green,
  Colors.teal,
  Colors.tealAccent,
];
TextStyle colorizeTextStyle = const TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.w800,
);
