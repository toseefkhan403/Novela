import 'package:arctic_pups/pages/chat_page.dart';
import 'package:arctic_pups/pages/hashtag_page.dart';
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
import 'package:oktoast/oktoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';

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

final _model = ThemeModel();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService();

    return ListenableProvider<ThemeModel>(
      builder: (_) => _model..init(),
      child: Consumer<ThemeModel>(
        builder: (context, model, child) {
          return MaterialApp(
            title: 'Celfie',
            theme: model.theme,
            debugShowCheckedModeBanner: false,
            home: RootPage(),
          );
        },
      ),
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

      //add fb logic here
      if (user.isEmailVerified ||
          list[1].providerId == 'facebook.com' ||
          list[0].providerId == 'facebook.com') {
        setState(() {
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
  PageController pageController;
  int currentIndex;
  bool _shouldGoToTutorial = false;

  @override
  void initState() {
    super.initState();
    _checkIfTutorialIsNeeded();
    currentIndex = 0;
    pageController =
        new PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //todo smoother transition
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: TutorialPage(),
      duration: Duration(milliseconds: 800),
      crossFadeState: _shouldGoToTutorial
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      secondChild: Scaffold(
        resizeToAvoidBottomPadding: false,
        /* appBar: AppBar(
        */ /* bottom: TabBar(
            controller: tabController,
            tabs: myTabs,
          ),*/ /*
        elevation: 5.0,
        backgroundColor: Colors.white,
        title: Text("Celfie",
            style: new TextStyle(color: kShrineBrown600),
            textAlign: TextAlign.center),
      ),*/
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: currentIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
                currentIndex = index;
                pageController.animateToPage(index,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              }),
          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeColor: Colors.green,
                inactiveColor: Colors.greenAccent),
            BottomNavyBarItem(
              icon: Icon(Icons.message),
              title: Text('Chat'),
              activeColor: Colors.purple,
              inactiveColor: Colors.purpleAccent,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.add_circle_outline),
              title: Text('Share Stuff'),
              activeColor: Colors.pink,
              inactiveColor: Colors.pinkAccent,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.tag_faces),
                title: Text('Hashtags'),
                activeColor: Colors.blue,
                inactiveColor: Colors.lightBlue),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeColor: Colors.red,
                inactiveColor: Colors.redAccent),
          ],
        ),

        /*FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.search, title: "Search"),
            TabData(iconData: Icons.shopping_cart, title: "Basket"),
            TabData(iconData: Icons.shopping_cart, title: "Basket"),
          ],
          onTabChangedListener: (position) {
            setState(() {
//                currentPage = position;
            });
          }),*/

        body: new PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            SharePage(),
            HomePage(),
            ChatPage(),
            HashtagPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }

  void _checkIfTutorialIsNeeded() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child('users').child(user.uid);
    DataSnapshot snapshot = await ref.once();

    print(snapshot.value);

    if (snapshot.value == null) {
      setState(() {
        showTopToast("You should complete the tutorial first", context);
        _shouldGoToTutorial = true;
      });
    }
  }
}

//Theme Data
ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: kShrineColorScheme,
    accentColor: kShrineBrown900,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink100,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: kShrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    inputDecorationTheme:
        const InputDecorationTheme(border: CutCornersBorder()),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kShrineBrown900);
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(fontWeight: FontWeight.w500),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        body2: base.body2.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        button: base.button.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Raleway',
        displayColor: kShrineBrown900,
        bodyColor: kShrineBrown900,
      );
}

const ColorScheme kShrineColorScheme = ColorScheme(
  primary: kShrinePink100,
  primaryVariant: kShrineBrown900,
  secondary: kShrinePink50,
  secondaryVariant: kShrineBrown900,
  surface: kShrineSurfaceWhite,
  background: kShrineBackgroundWhite,
  error: kShrineErrorRed,
  onPrimary: kShrineBrown900,
  onSecondary: kShrineBrown900,
  onSurface: kShrineBrown900,
  onBackground: kShrineBrown900,
  onError: kShrineSurfaceWhite,
  brightness: Brightness.light,
);

showTopToast(String text, BuildContext context) {
  Widget widget = Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        margin: EdgeInsets.all(10.0),
        color: Colors.amberAccent.withOpacity(0.5),
        child: Text(
          '$text',
          style: TextStyle(fontSize: 29, fontFamily: 'Raleway'),
        ),
      ),
    ),
  );

  showToastWidget(
    widget,
    duration: Duration(seconds: 3),
    position: ToastPosition.top,
  );
}
