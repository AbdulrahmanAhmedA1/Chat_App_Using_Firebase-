import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:flutter_chat_app/providers/xprovider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static final String route = 'Profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ThemeMode themeMode = ThemeMode.light;

  // bool switchValue = false;

  Map<String, dynamic>? userData;
  User? user;
  Future<DocumentSnapshot<Map<String, dynamic>>>? future;

  getUserData() {
    user = FirebaseAuth.instance.currentUser;
    future =
        FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }

  //
  // @override
  // void initState() {
  //   getUserData();
  //   super.initState();
  // }
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<XProvider>(context, listen: true);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.brightness_4_outlined,
                color: Colors.black,
              ),
              onPressed: () {}),
          TextButton.icon(
              label: Text(
                'logout',
                style: TextStyle(color: Colors.black),
              ),
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                await authProvider.logout(context);
              }),
          // Switch(
          //     activeColor: Colors.black,
          //     activeTrackColor: Colors.black,
          //     inactiveThumbColor: Colors.white,
          //     inactiveTrackColor: Colors.white,
          //     value: switchValue,
          //     onChanged: (value) {
          //       setState(() {
          //         switchValue = value;
          //       });
          //     }),
        ],
      ),
      body: FutureBuilder(
        future: future,
        builder: (_,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          String? userImageUrl;
          String? userName;
          String? userEmail;
          if (snapshot.hasData) {
            userData = snapshot.data!.data() as Map<String, dynamic>;
            userImageUrl = userData!['imageUrl'];
            userName = userData!['username'];
            userEmail = user!.email;
          }
          return !snapshot.hasData
              ? Container()
              : snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 30),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(userImageUrl!),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      child: Icon(Icons.edit),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              userName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              userEmail!,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        Size(150, 50)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)))),
                                onPressed: () {},
                                child: Text('Upgrade to pro')),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '20',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Ranking',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.black,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '50',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.black,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '1000',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              // margin: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'About',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),

                                // textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'I am Abdulrahman, I am 20 years old, Reading is My Favourite hobby, I like Coding and solve Problems',
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => provider.changeCurrentIndex(index),
        currentIndex: provider.currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: 'Chat', tooltip: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.margin),
              label: 'My Profile',
              tooltip: 'My Profile'),
        ],
      ),
    );
  }
}
