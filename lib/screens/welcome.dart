import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:flutter_chat_app/screens/SignIn.dart';
import 'package:flutter_chat_app/screens/chats.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static final String route = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // FirebaseMessaging.onMessage.listen((event) {
    //   print('data');
    //   print(event.notification!.title);
    //   print(event.notification!.body);
    //   print(event.data);
    //   print('data');
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome,',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                'Thank you for Choosing Our App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Image.asset(
                  'assets/images/download.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              Consumer<AuthProvider>(
                builder: (_, provider, __) => ElevatedButton(
                    onPressed: () async {
                      provider.isAuth
                          ? Navigator.of(context)
                              .pushReplacementNamed(Chats.route)
                          : Navigator.of(context)
                              .pushReplacementNamed(SignIn.route);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('welcome', true);
                    },
                    child: Text('Get Started')),
              )
            ],
          ),
        ));
  }
}
