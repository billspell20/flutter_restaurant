import 'package:apple_sign_in/apple_sign_in_button.dart' as applebutton;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/models/task_data.dart';
import '../auth.dart' as authApple;
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'tasks_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:restaurant_flutter/widgets/ad_helper.dart';
import 'package:apple_sign_in/apple_sign_in.dart' as apple;

authApple.AuthService authapple0 = authApple.AuthService();

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

var _user = '';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

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

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    controller.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Stack(
        children: <Widget>[
          Padding(
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
                      width: 220.0,
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
                      image: AssetImage('lib/images/google_logo.png'),
                      width: 20),
                  label: const Text(
                    'Log In with Google',
                    style: TextStyle(color: Colors.teal),
                  ),
                  style: flatButtonStyle,
                  onPressed: () async {
                    signInWithGoogle().then(
                      (user) {
                        Provider.of<TaskData>(context, listen: false).callReq();
                        Navigator.pushNamed(context, TasksScreen.id);
                      },
                    );
                  },
                ),
                FutureBuilder(
                  future: authapple0.appleSignInAvailable,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return applebutton.AppleSignInButton(
                        onPressed: () async {
                          var user = await authapple0.appleSignIn();
                          if (user != null) {
                            Provider.of<TaskData>(context, listen: false)
                                .callReq();
                            Navigator.pushNamed(context, TasksScreen.id);
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble() + 10,
                child: AdWidget(ad: _bannerAd),
              ),
            ),
        ],
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
  fontSize: 30.0,
  fontWeight: FontWeight.w800,
);
Future signInWithGoogle() async {
  GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  var authResult = (await _auth.signInWithCredential(credential));
  _user = authResult.user as String;
  assert(authResult.user != null);
  var currentUser = _auth.currentUser;
  assert(authResult.user!.uid == currentUser!.uid);
  return currentUser;
}

/*final BannerAd myBanner = BannerAd(
  adUnitId: AdHelper.bannerAdUnitId,
  size: AdSize.fullBanner,
  request: AdRequest(),
  listener: BannerAdListener(),
);*/
