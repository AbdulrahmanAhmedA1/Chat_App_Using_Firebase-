import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/SignIn.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuth = false;

  checkAuth() {
    if (FirebaseAuth.instance.currentUser != null) {
      isAuth = true;
    } else {
      isAuth = false;
    }
    notifyListeners();
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushReplacementNamed(SignIn.route);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('done'),
                content: Text('you are signed out'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text('Okay')),
                ],
              ));
    }).catchError((e) {
      print('error when signing out');
      throw e;
    });
    // isAuth = false;

    notifyListeners();
  }

  removeAccount(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.delete().then((value) async {
      FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      FirebaseFirestore.instance.collection('chat').doc(user.uid).delete();
      Reference ref = FirebaseStorage.instance.ref().child('userImage');
      await ref.child(user.uid + '.jpg').delete();
      Navigator.of(context).pushReplacementNamed(SignIn.route);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('done'),
                content: Text('your account is deleted'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text('Okay')),
                ],
              ));
      print('account deleted');
      // isAuth = false;
    }).catchError((e) {
      print('error when deleting account');
      throw e;
    });
    notifyListeners();
  }
}

//SignImWithGoogle
//  logInGoogle() async {
//    final user = await GoogleSignIn().signIn();
//    FirebaseAuth.instance.currentUser;
//  }
//
//  logInFacebook() async {
// await FacebookAuth.instance.login();
//  }
//
//  Future<UserCredential> signInWithGoogle() async {
//    // Trigger the authentication flow
//    final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;
//
//    // Obtain the auth details from the request
//    final GoogleSignInAuthentication googleAuth =
//        await googleUser.authentication;
//
//    // Create a new credential
//    final OAuthCredential credential = GoogleAuthProvider.credential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    // Once signed in, return the UserCredential
//    notifyListeners();
//
//    return await FirebaseAuth.instance.signInWithCredential(credential);
//  }
//
//  //SignInWithGoogle
//  Future<UserCredential> signInWithFacebook() async {
//    // Trigger the sign-in flow
//    final LoginResult loginResult = await FacebookAuth.instance.login();
//
//    // Create a credential from the access token
//    final OAuthCredential facebookAuthCredential =
//        FacebookAuthProvider.credential(loginResult.accessToken!.token);
//
//    // Once signed in, return the UserCredential
//    notifyListeners();
//    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//  }
//SignInWithGithub
// Future<UserCredential> signInWithGitHub() async {
//   // Create a GitHubSignIn instance
//
//   final GitHubSignIn gitHubSignIn = GitHubSignIn(
//       clientId: clientId,
//       clientSecret: clientSecret,
//       redirectUrl: 'https://my-project.firebaseapp.com/__/auth/handler');
//
//   // Trigger the sign-in flow
//   final result = await gitHubSignIn.signIn(context);
//
//   // Create a credential from the access token
//   final githubAuthCredential = GithubAuthProvider.credential(result.token);
//
//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance
//       .signInWithCredential(githubAuthCredential);
// }
