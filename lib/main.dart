import 'package:arctic_pups/pages/share_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arctic_pups/pages/login_page.dart';
import 'package:arctic_pups/pages/home_page.dart';
import 'package:arctic_pups/services.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//todo fix dialog
//todo add premium purchase
//todo design buy premium screen
//todo design main screen
//todo automatic call
//todo add backdrop options
//todo manage coins dialog
//todo add hindi and english tabs
//todo add stories
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
          backgroundColor: Colors.black,
          fontFamily: 'Raleway'),
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  //this should be a logo screen
  Widget parent = Center(child: SpinKitChasingDots(color: Colors.white));

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
      print(user.providerData);
      List<UserInfo> list = user.providerData;

      //todo catch Index exception
      //add fb logic here
      if (user.isEmailVerified || list[0].providerId == 'facebook.com') {
        setState(() {
          print('setting homescreen');
          parent = HomeScreen();
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  @override
  void initState() {
    _isFirstTimeLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            resizeToAvoidBottomPadding: false,
            bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.black,
                showUnselectedLabels: true,
                selectedFontSize: 10.0,
                unselectedFontSize: 10.0,
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      backgroundColor: Colors.black,
                      title: Text('Home')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_circle), title: Text('Add new Story')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text('Profile')),
                ]),
            body: _getPage(currentIndex),
          );
  }

  Widget _getPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomePage();

      case 1:
        return SharePage();

      case 2:
        return HomePage();

      default:
        return HomePage();
    }
  }

  _isFirstTimeLogin() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child('users').child(user.uid).child('points').once();

    if (snapshot.value == null){
      //first time user
      FirebaseDatabase.instance.reference().child('users').child(user.uid).child('points').set(200);
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
//      color: Colors.grey,
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
