import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/shared.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:flutter_chat_app/providers/xprovider.dart';
import 'package:flutter_chat_app/screens/SignIn.dart';
import 'package:flutter_chat_app/screens/chat.dart';
import 'package:flutter_chat_app/screens/chats.dart';
import 'package:flutter_chat_app/screens/choose_image.dart';
import 'package:flutter_chat_app/screens/profile.dart';
import 'package:flutter_chat_app/screens/register.dart';
import 'package:flutter_chat_app/screens/splash.dart';
import 'package:flutter_chat_app/screens/welcome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// bool isAuth = false;
SharedPreferences? sharedPreferences;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Reference ref = FirebaseStorage.instance
  //     .ref('userImage')
  //     .child('ARM2K7qXSzNFNwC2u1OFSHYgxN93');
  // ref.delete().then((value) => print('deleted')).catchError((e) {
  //   throw e;
  // });
  sharedPreferences = await SharedPreferences.getInstance();
  Shared.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // if(sharedPreferences!.containsKey('splash'))
    // if (sharedPreferences!.getBool('splash')==false){
    //
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => XProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()..checkAuth()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthProvider>(builder: (BuildContext context, value, _) {
          print(value.isAuth);
          return Splash();
          // value.isAuth ? Shared.screen() : SignIn();
        }),
        routes: {
          // '/': () => Home(),
          SignIn.route: (context) => SignIn(),
          Home.route: (context) => Home(),
          Splash.route: (context) => Splash(),
          SignIn.route: (context) => SignIn(),
          Profile.route: (context) => Profile(),
          Register.route: (context) => Register(),
          Chat.route: (context) => Chat(),
          Chats.route: (context) => Chats(),
          ChooseImage.route: (context) => ChooseImage(),
        },
      ),
    );
  }
}
