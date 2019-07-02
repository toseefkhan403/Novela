import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arctic_pups/base_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:arctic_pups/pages/login_page.dart';

class SharePage extends StatefulWidget {
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: FlatButton(
                onPressed: () {

                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                  FacebookLogin().logOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('sign out'))));
  }
}
