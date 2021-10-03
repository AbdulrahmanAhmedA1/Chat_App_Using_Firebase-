import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/xprovider.dart';
import 'package:flutter_chat_app/screens/profile.dart';
import 'package:provider/provider.dart';

import 'chat.dart';

class Chats extends StatefulWidget {
  static final String route = 'chats';

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  Future<QuerySnapshot<Map<String, dynamic>>>? usersFuture;
  Future<DocumentSnapshot<Map<String, dynamic>>>? meFuture;

  Map<String, dynamic>? userData;

  List<QueryDocumentSnapshot<Map<String, dynamic>>>? usersDocs;
  DocumentReference<Map<String, dynamic>>? reference;
  bool isMe = false;
  User? user;
  Map<String, dynamic>? meData;
  bool isLoading = false;

  getFuture() {
    try {
      setState(() {
        isLoading = true;
      });
      user = FirebaseAuth.instance.currentUser;
      usersFuture = FirebaseFirestore.instance.collection('users').get();
      meFuture =
          FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      meFuture!.then((value) {
        meData = value.data() as Map<String, dynamic>;
        setState(() {
          isLoading = false;
        });
        print(meData);
      }).catchError((e) {
        setState(() {
          isLoading = true;
        });
        throw e;
      });
      usersFuture!.then((value) {
        var x = value.docs;
        Map<String, dynamic> b = x[0].data();
        print('user 1 is $b');
        b = x[1].data();
        print('user 2 is $b');
        b = x[2].data();
        print('user 3 is $b');
        b = x[3].data();
        print('user 4 is $b');
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    getFuture();
    reference = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<XProvider>(context, listen: true);
    return provider.currentIndex == 1
        ? Profile()
        : Scaffold(
            appBar: AppBar(
              titleSpacing: 20,
              title: Text('Chats'),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage:
                      isLoading ? null : NetworkImage(meData!['imageUrl']),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey[100], shape: BoxShape.circle),
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey[100], shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            body: FutureBuilder(
              future: usersFuture,
              builder: (_,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshotUsers) {
                if (snapshotUsers.hasData) {
                  usersDocs = snapshotUsers.data!.docs;
                } else {
                  print('usersError is ${snapshotUsers.error} ');
                }
                return !snapshotUsers.hasData
                    ? Container()
                    : snapshotUsers.connectionState == ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 100, horizontal: 20),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    Map<String, dynamic>? userData =
                                        usersDocs![index].data();
                                    // usersDocs![index].data();
                                    // print('usersLength ${userData.length}');
                                    // print(
                                    //     'userIndex is ${userData[index]}');
                                    // print(userData);
                                    reference == usersDocs![index].reference
                                        ? isMe = true
                                        : isMe = false;
                                    return !isMe
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            Chat()));
                                              },
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                userData[
                                                                    'imageUrl']),
                                                      ),
                                                      Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 15,
                                                            width: 15,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                          ))
                                                    ],
                                                  ),
                                                  Text(userData['username'])
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container();
                                  },
                                  itemCount: usersDocs!.length,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 180),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: usersDocs!.length,
                                  itemBuilder: (ctx, index) {
                                    Map<String, dynamic> userData =
                                        usersDocs![index].data();
                                    //     usersDocs![index].data();
                                    reference == usersDocs![index].reference
                                        ? isMe = true
                                        : isMe = false;
                                    return !isMe
                                        ? Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            Chat()));
                                              },
                                              leading: Stack(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(userData[
                                                            'imageUrl']),
                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Container(
                                                        height: 15,
                                                        width: 15,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                      ))
                                                ],
                                              ),
                                              title: Text(userData['username']),
                                              subtitle: Text('message'),
                                            ),
                                          )
                                        : Container();
                                  },
                                ),
                              ),
                            ],
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
