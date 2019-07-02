import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<String> getCurrentUser();

  Future<String> signInUsingGoogle();

  Future<String> signInUsingFacebook();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  void signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _ref =
      FirebaseDatabase.instance.reference().child("user_account_settings");
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    addToDatabase(user);
    return user.uid;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print('${user.uid}');
    return user.isEmailVerified;
  }

  Future<String> signInUsingGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    AuthCredential c = GoogleAuthProvider.getCredential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    FirebaseUser user = await _firebaseAuth.signInWithCredential(c);

    addToDatabase(user);

    return user.uid;
  }

  Future<String> signInUsingFacebook() async {
    final FacebookLoginResult result =
        await _facebookLogin.logInWithReadPermissions(['email']);

    AuthCredential c = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);

    FirebaseUser user = await _firebaseAuth.signInWithCredential(c);

    addToDatabase(user);

    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  void signOut() {
    //todo check for exceptions and errors
    _firebaseAuth.signOut();
    _googleSignIn.signOut();
    _facebookLogin.logOut();
  }

  addToDatabase(FirebaseUser user) {
    _ref.child(user.uid).set({
      'photoUrl': user.photoUrl,
      'phoneNumber': user.phoneNumber,
      'displayName': user.displayName,
      'email': user.email,
    });
  }
}
