import 'package:arctic_pups/pages/chat_page.dart';
import 'package:arctic_pups/pages/hashtag_page.dart';
import 'package:arctic_pups/utils/card_flip.dart';
import 'package:arctic_pups/pages/share_page.dart';
import 'package:arctic_pups/pages/tutorial_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:arctic_pups/utils/cut_corners_border.dart';
import 'package:arctic_pups/pages/login_page.dart';
import 'package:arctic_pups/pages/home_page.dart';
import 'package:arctic_pups/pages/profile_page.dart';
import 'package:arctic_pups/services.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/notifications_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'package:arctic_pups/pages/camera_example_home.dart';
import 'package:image_picker/image_picker.dart';

//todo Take care of the bottomNavBar color while theme changing
void main() {
  runApp(
    OKToast(
      child: App(),
    ),
  );
  /* SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
      runApp(App());
  });*/
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initCameras();
    FirebaseService();

    return MaterialApp(
      title: 'Celfie',
      theme: ThemeData(
          brightness: Brightness.dark,
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
          showTopToast("Verify Your Email address", context);
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
  bool _shouldGoToTutorial = false;

  @override
  void initState() {
    super.initState();
    _checkIfTutorialIsNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return _shouldGoToTutorial
        ? TutorialPage()
        : Scaffold(
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
                      icon: Icon(Icons.add_circle), title: Text('Share')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.notifications_active),
                      title: Text('Notifications')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text('Profile')),
                ]),
            body: _getPage(currentIndex),
          );
  }

  void _checkIfTutorialIsNeeded() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child('users').child(user.uid);
    DataSnapshot snapshot = await ref.once();

    if (snapshot.value == null) {
      setState(() {
        showTopToast("You should complete the tutorial first", context);
        _shouldGoToTutorial = true;
      });
    }
  }

  Widget _getPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomePage();

      case 1:
        return SharePage();

      case 2:
        return NotificationsPage();

      case 3:
        return ProfilePage();

      default:
        return HomePage();
    }
  }
}

List<Color> aquaGradients = [
  Color(0xFF5AEAF1),
  Color(0xFF8EF7DA),
];

showTopToast(String text, BuildContext context) {
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
