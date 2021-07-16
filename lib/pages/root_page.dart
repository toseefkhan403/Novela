import 'package:arctic_pups/utils/backdrop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'home_page.dart';
import 'login_page.dart';

class RootPage extends StatefulWidget {

  final bool usingFb;

  RootPage({this.usingFb});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  //this should be a logo screen
  Widget parent = Center(child: SpinKitRipple(color: Colors.white));

  @override
  void initState() {
    _goToAppropriateScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return parent;
  }

  void _goToAppropriateScreen() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {

      //jugaad
      if (user.isEmailVerified || widget.usingFb == true || user.photoUrl.contains("facebook.com")) {
        setState(() {
          print('setting homescreen');
          parent = HomePage();
        });
      } else {
        setState(() {
          showTopToast("Verify Your Email address");
          parent = LoginPage();
        });
      }
    } else {
      setState(() {
        parent = LoginPage();
      });
    }
  }
}