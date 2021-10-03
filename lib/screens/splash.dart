import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  static final String route = 'Splash';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  go() {
    Timer(Duration(seconds: 2), () async {
      Navigator.of(context).pushReplacementNamed(Home.route);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('splash', true);
    });
  }

  // FirebaseMessaging fbm = FirebaseMessaging.instance;

  @override
  void initState() {
    go();
    // fbm.getToken().then((value) {
    //   print(value);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Image.asset('assets/images/splash.jpeg'),
        ),
      ),
    );
  }
}
