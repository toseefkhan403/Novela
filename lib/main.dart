import 'package:arctic_pups/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arctic_pups/pages/login_page.dart';
import 'package:arctic_pups/pages/home_page.dart';
import 'package:arctic_pups/services.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(
    OKToast(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService();

    return MaterialApp(
      title: 'Celfie',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: kShrinePink400,
          backgroundColor: Colors.black,
          fontFamily: 'Raleway'),
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}

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

List<Color> aquaGradients = [
  Color(0xFF5AEAF1),
  Color(0xFF8EF7DA),
];

showTopToast(String text) {
  Widget widget = Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: FractionalOffset.centerLeft,
          stops: [0.2, 1],
          colors: aquaGradients),
      borderRadius: new BorderRadius.circular(26.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        '$text',
        style: TextStyle(fontSize: 18, fontFamily: 'Raleway'),
      ),
    ),
  );

  showToastWidget(
    widget,
    duration: Duration(seconds: 3),
    position: ToastPosition.top,
  );
}
