import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/components/social_auth_component.dart';
import 'package:flutter_chat_app/components/text_form_field.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:flutter_chat_app/screens/register.dart';
import 'package:provider/provider.dart';

import 'chats.dart';

class SignIn extends StatefulWidget {
  static final String route = 'SignIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool isLoading = false;
  bool isSecure = false;

  login(BuildContext context, GlobalKey<FormState> formKey) async {
    bool isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed(Chats.route);
        print('done');
        print(userCredential.user!.email);
        print(userCredential.user!.uid);
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'user-not-found') {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('error'),
                    content: Text('No user found for that email.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Okay'))
                    ],
                  ));
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('error'),
                    content: Text('Wrong password provided for that user.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Okay'))
                    ],
                  ));
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('error when sign in');
        throw e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
            child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOGIN',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Login now to communicate with friends',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DefaultTextField(
                      onSave: (String? val) {
                        email = val!;
                      },
                      validate: (String? val) {
                        if (val!.isEmpty) return 'enter your email';
                        if (!val.contains('@') || !val.endsWith('.com'))
                          return 'email should contains @ and ends with .com';
                        return null;
                      },
                      lText: 'Email Address',
                      hText: ' Email Address',
                      pIcon: Icon(Icons.email_outlined),
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextField(
                      onSave: (String? val) {
                        password = val!;
                      },
                      validate: (String? val) {
                        if (val!.isEmpty) return 'enter your password';
                        if (val.length <= 5)
                          return 'The password is too short, it is should not be less than 6 characters';
                        return null;
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
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(double.infinity, 50))),
                            onPressed: () {
                              login(context, formKey);
                            },
                            child: Text('LOGIN'),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('don\'t have an account?'),
                        SizedBox(
                          width: 5,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Register.route);
                            },
                            child: Text('REGISTER')),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'OR',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Sign in with',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialAuthComponent(
                            onTap: () {},
                            socialName: 'Google',
                            socialImage: 'assets/icons/icons-google.png'),
                        SocialAuthComponent(
                            onTap: () {},
                            socialName: 'Facebook',
                            socialImage: 'assets/icons/icons-facebook.png'),
                        SocialAuthComponent(
                            onTap: () {},
                            socialName: 'Github',
                            socialImage: 'assets/icons/github-logo.png'),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
