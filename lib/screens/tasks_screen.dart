import 'package:flutter/material.dart';
import 'package:restaurant_flutter/widgets/tasks_list.dart';
import 'package:restaurant_flutter/screens/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/models/task_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:restaurant_flutter/widgets/ad_helper.dart';

final auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class TasksScreen extends StatefulWidget {
  static const String id = 'tasks_screen';

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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

  static const String id = 'tasks_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282c34),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 52.0),
          child: FloatingActionButton(
              backgroundColor: const Color(0xFF282c34),
              child: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                            child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: AddTaskScreen(),
                        )));
              })),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                top: 50.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const CircleAvatar(
                      child: Icon(
                        Icons.fastfood_rounded,
                        size: 30.0,
                        color: Color(0xFF282c34),
                      ),
                      backgroundColor: Colors.white,
                      radius: 30.0,
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (await _googleSignIn.isSignedIn()) {
                          await _googleSignIn
                              .disconnect()
                              .whenComplete(() async {
                            await auth.signOut();
                          });
                        } else {
                          await auth.signOut();
                        }
                        Provider.of<TaskData>(context, listen: false)
                            .clearTasks();
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context,
                            "welcome_screen", (Route<dynamic> route) => false);
                      },
                      child: const CircleAvatar(
                        child: Icon(
                          Icons.logout,
                          size: 30.0,
                          color: Color(0xFF282c34),
                        ),
                        backgroundColor: Colors.white,
                        radius: 30.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Restaurant Passport',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${Provider.of<TaskData>(context).taskCount} restaurants to visit.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: TasksList(),
            ),
          ),
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.topCenter,
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
