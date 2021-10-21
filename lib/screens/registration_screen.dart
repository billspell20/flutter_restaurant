import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_flutter/screens/tasks_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:restaurant_flutter/widgets/message_snack.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:restaurant_flutter/widgets/ad_helper.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
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

  void submitReg(BuildContext context) async {
    try {
      setState(() {
        showSpinner = true;
      });
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      setState(() {
        showSpinner = false;
      });

      Navigator.pushNamed(context, TasksScreen.id);
    } catch (e) {
      MessageSnack().showErrorMessage(
          false,
          _scaffoldKey,
          () => {
                setState(() {
                  showSpinner = false;
                })
              });
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ModalProgressHUD(
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
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email'),
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
                    onPressed: () => submitReg(context),
                  ),
                ],
              ),
            ),
          ),
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
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
