import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/chats.dart';
import 'package:image_picker/image_picker.dart';

class ChooseImage extends StatefulWidget {
  static final String route = 'ChooseImage';

  @override
  _ChooseImageState createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  User? user = FirebaseAuth.instance.currentUser;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  XFile? getImage;
  bool isPicked = false;
  String? url;
  ImagePicker? imagePicker;

  pickImage(ImageSource source) async {
    imagePicker = ImagePicker();
    try {
      getImage = await imagePicker!.pickImage(source: source);
      if (getImage != null) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('userImage')
            .child(user!.uid + '.jpg');
        await ref.putFile(File(getImage!.path));
        url = await ref.getDownloadURL();
        setState(() {
          isPicked = true;
        });
        print(url);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'imageUrl': url,
        });
        print('image not selected');
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Choose Image'),
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: isPicked ? NetworkImage(url!) : null,
              radius: 80,
            ),
            TextButton.icon(
                onPressed: () async {
                  // ImagePicker imagePicker = ImagePicker();
                  // await imagePicker.pickImage(source: ImageSource.camera);
                  pickImage(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text('pick image from camera')),
            TextButton.icon(
                onPressed: () async {
                  // ImagePicker imagePicker = ImagePicker();
                  // await imagePicker.pickImage(source: ImageSource.camera);
                  pickImage(ImageSource.gallery);
                },
                icon: Icon(Icons.image_outlined),
                label: Text('pick image From gallery')),
            ElevatedButton(
                onPressed: () async {
                  if (getImage != null) {
                    Navigator.of(context).pushReplacementNamed(Chats.route);
                  } else {
                    scaffoldState.currentState!.showSnackBar(SnackBar(
                        content: Text(
                      'Please choose an image',
                    )));
                  }
                },
                child: Text('Done')),
          ],
        ),
      ),
    );
  }
}

pickImage() {}
