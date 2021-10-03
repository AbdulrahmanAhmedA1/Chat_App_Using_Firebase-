import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/components/text_form_field.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'SignIn.dart';
import 'choose_image.dart';

class Register extends StatefulWidget {
  static final String route = 'Register';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? email;
  String? password;
  String? name;
  String? phone;

  bool isSecure = false;

  register(BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      try {
        setState(() {
          isLoading = true;
        });
        print('tryyyyyyyyyyyyyyyy');
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!)
            .then((value) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(value.user!.uid)
              .set({
            'username': name,
            'password': password,
            'phone': phone,
          }).then((value) {
            print('data set');
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushReplacementNamed(ChooseImage.route);
          }).catchError((e) {
            setState(() {
              isLoading = false;
            });
            throw e;
          });
        });
        print('register done');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('error'),
                    content: Text('The password provided is too weak.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Okay'))
                    ],
                  ));
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('error'),
                    content: Text('The account already exists for that email.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Okay'))
                    ],
                  ));
          print('The account already exists for that email.');
        }
      } catch (e) {
        print('error when sign up');
        throw e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Register now to communicate with friends',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  DefaultTextField(
                      textInputType: TextInputType.name,
                      validate: (String? val) {
                        if (val!.isEmpty) return 'enter your name';
                        return null;
                      },
                      onSave: (String? val) {
                        name = val!;
                      },
                      lText: 'User Name',
                      hText: ' User Name',
                      pIcon: Icon(Icons.person)),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultTextField(
                      textInputType: TextInputType.emailAddress,
                      onSave: (String? val) {
                        email = val!;
                        print(email);
                      },
                      validate: (String? val) {
                        if (val!.isEmpty) return 'enter your email';
                        if (!val.contains('@') || !val.endsWith('.com'))
                          return 'email should contains @ and ends with .com';
                        return null;
                      },
                      lText: 'Email Address',
                      hText: ' Email Address',
                      pIcon: Icon(Icons.email_outlined)),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultTextField(
                    textInputType: TextInputType.visiblePassword,
                    validate: (String? val) {
                      if (val!.isEmpty) return 'enter your password';
                      if (val.length <= 5) return 'The password is too short';
                      return null;
                    },
                    onSave: (String? val) {
                      password = val!;
                    },
                    secureText: isSecure,
                    lText: 'Password',
                    hText: ' Password',
                    pIcon: Icon(Icons.lock_outline),
                    sIcon: IconButton(
                      icon: Icon(
                          isSecure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isSecure = !isSecure;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultTextField(
                      textInputType: TextInputType.phone,
                      validate: (String? val) {
                        if (val!.isEmpty) return 'enter your phone';
                        return null;
                      },
                      onSave: (String? val) {
                        phone = val!;
                      },
                      lText: 'Phone',
                      hText: ' Phone',
                      pIcon: Icon(Icons.phone)),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, 50))),
                          onPressed: () => register(context, formKey),
                          child: Text('REGISTER'),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('have an account?'),
                      SizedBox(
                        width: 5,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(SignIn.route);
                          },
                          child: Text('LOGIN')),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
