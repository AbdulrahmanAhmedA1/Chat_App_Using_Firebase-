import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/screens/chats.dart';
import 'package:flutter_chat_app/screens/splash.dart';
import 'package:flutter_chat_app/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static SharedPreferences? preferences;

  static init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Widget screen() {
    if (!preferences!.containsKey('splash') ||
        (preferences!.containsKey('splash') &&
            preferences!.getBool('splash') == false)) {
      return Splash();
    } else if (!preferences!.containsKey('welcome') ||
        preferences!.containsKey('welcome') &&
            preferences!.getBool('welcome') == false) {
      return Home();
    } else {
      return Chats();
    }
  }
}
