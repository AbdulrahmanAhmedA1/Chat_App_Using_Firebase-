import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  static final String route = 'Chat';

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  String? userImage;
  String? message;
  User? user;
  Map<String, dynamic>? userData;
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;

  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots();
    user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((snapshot) {
      userData = snapshot.data() as Map<String, dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    void sendMessage() async {
      FocusScope.of(context).unfocus();
      await FirebaseFirestore.instance.collection('chat').add({
        'userId': user!.uid,
        'message': messageController.text.trim(),
        'createdAt': Timestamp.now(),
        'userName': userData!['username'],
        'imageUrl': userData!['imageUrl']
      });
      messageController.clear();
      messageController.text = '';
    }

    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          actions: [
            TextButton.icon(
                label: Text(
                  'logout',
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await authProvider.logout(context);
                }),
            // Center(
            //   child: DropdownButton<dynamic>(
            //     iconEnabledColor: Colors.white,
            //     underline: Container(),
            //     onChanged: (value) async {
            //       if (value == 'logout') {
            //         await authProvider.logout(context);
            //       } else if (value == 'remove account') {
            //         await authProvider.removeAccount(context);
            //       }
            //     },
            //     icon: Icon(
            //       Icons.more_vert,
            //     ),
            //     items: [
            //       DropdownMenuItem(
            //         child: Row(
            //           children: [
            //             Icon(Icons.exit_to_app, color: Colors.black),
            //             SizedBox(width: 8),
            //             Text('Logout', style: TextStyle(color: Colors.black)),
            //           ],
            //         ),
            //         value: 'logout',
            //       ),
            //       DropdownMenuItem(
            //           value: 'remove account',
            //           child: Row(
            //             children: [
            //               Icon(
            //                 Icons.delete,
            //                 color: Colors.black,
            //               ),
            //               SizedBox(
            //                 width: 8,
            //               ),
            //               Text('Remove Account',
            //                   style: TextStyle(color: Colors.black)),
            //             ],
            //           ))
            //     ],
            //   ),
            // ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            final docs = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            bool isMe = docs[index]['userId'] == user!.uid;
                            // userImage = docs[index]['imageUrl'];
                            message = docs[index]['message'];
                            print(docs[index]['message']);
                            return Center(
                                child: !snapshot.hasData
                                    ? CircularProgressIndicator()
                                    : isMe
                                        ? Align(
                                            alignment: Alignment.centerRight,
                                            child: Column(
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 260,
                                                  ),
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    // padding:
                                                    //     EdgeInsets.symmetric(
                                                    //         vertical: 10,
                                                    //         horizontal: 10),
                                                    // width: 200,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  25),
                                                          topRight:
                                                              Radius.circular(
                                                                  0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  0),
                                                        )),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Text(
                                                        message!,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              children: [
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 260),
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 5),
                                                      // padding: EdgeInsets
                                                      //     .symmetric(
                                                      //         vertical: 10,
                                                      //         horizontal: 10),
                                                      // width: 200,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0),
                                                            topRight:
                                                                Radius.circular(
                                                                    25),
                                                            topLeft:
                                                                Radius.circular(
                                                                    0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    0),
                                                          )),

                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        child: Text(message!,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            )),
                                                      ),
                                                    )),

                                                // Container(
                                                //   alignment: Alignment.topLeft,
                                                //   child: CircleAvatar(
                                                //     radius: 13,
                                                //     backgroundImage:
                                                //         NetworkImage(
                                                //             userImage!),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ));
                          })),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: 'Send a Message...',
                          suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                return messageController.text.trim().isEmpty
                                    ? null
                                    : sendMessage();
                              })),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
