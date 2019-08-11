import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:arctic_pups/utils/size_util.dart';
import 'package:flutter/widgets.dart';
import 'package:arctic_pups/pages/login_page.dart';
import 'package:arctic_pups/main.dart';
import 'package:arctic_pups/pages/change_theme.dart';
import 'package:arctic_pups/pages/home_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:arctic_pups/utils/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

    return Scaffold(
      body: NavigationOneCoordinator(),
    );
  }
}

class NavigationOneCoordinator extends StatefulWidget {
  @override
  _Coordinator createState() => _Coordinator();
}

class _Coordinator extends State<NavigationOneCoordinator>
    with TickerProviderStateMixin {
  AnimationController _controller;
  HomePageAnimator _animator;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animator = HomePageAnimator(_controller);
  }

  _onHomePressed() => _showHome();

  _onChatPressed() {
    debugPrint("Show Notif screen");
  }

/*  _onFeedPressed() {

    debugPrint("Feed Pressed");
  }*/

  _onProfilePressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChangeTheme()));
    debugPrint("Theme Pressed");
  }

  _onSettingsPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SettingsList()));
  }

  @override
  Widget build(BuildContext context) => Material(
        child: BackgroundCommon(
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 100.0,
                right: 50.0,
                child: MenuButtons(
                  onChatPressed: _onChatPressed,
//              onFeedPressed: _onFeedPressed,
                  onHomePressed: _onHomePressed,
                  onProfilePressed: _onProfilePressed,
                  onSettingsPressed: _onSettingsPressed,
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, widget) => Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.translationValues(
                          _animator.translateLeft.value, 0.0, 0.0)
                        ..scale(_animator.scaleDown.value),
                      child: AniPage(() => _openMenu()),
                    ),
              ),
            ],
          ),
        ),
      );

  Future _openMenu() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      print("Animation Failed");
    }
  }

  Future _showHome() async {
    try {
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      print("Animation Failed");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

//shows logged in user's profile
class AniPage extends StatefulWidget {
  AniPage(this.onMenuPressed);

  final VoidCallback onMenuPressed;

  @override
  _AniPageState createState() => _AniPageState();
}

class _AniPageState extends State<AniPage> {
  bool _isLoading = true;
  String photoUrl, username, display_name, bio, flames, friends, postCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            stops: [0.2, 1],
            colors: aquaGradients),
      ),
      child: _isLoading
          ? Center(child: SpinKitChasingDots(color: Colors.white,),)
          : StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0, fontFamily: 'Pacifico'),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: widget.onMenuPressed,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Material(
                                  color: Colors.teal,
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(Icons.menu,
                                        color: Colors.white, size: 26.0),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //profile starts here
                _buildTile(
                  Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                  width: 126,
                                  height: 126,
                                  child: Image.network(
                                    '$photoUrl',
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Text('$username',
                              style: TextStyle(
                                  fontFamily: 'Oxygen', color: Colors.green)),
                          Text('$display_name',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Raleway',
                                  fontSize: 24.0)),
                          Text('"$bio"',
                              style: TextStyle(
                                  fontFamily: 'Pacifico', color: Colors.black)),
                          Padding(padding: EdgeInsets.only(bottom: 2.0)),
                        ],
                      )),
                ),
                _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Theme.of(context).primaryColor,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.tag_faces,
                                      color: Colors.white, size: 30.0),
                                )),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                            Text('$friends',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0)),
                            Text('Friends',
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black45)),
                          ]),
                    ), onTap: () {
                  //show friend list here}
                }),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Material(
                              color: Colors.amber,
                              shape: CircleBorder(),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.favorite_border,
                                    color: Colors.white, size: 30.0),
                              )),
                          Padding(padding: EdgeInsets.only(bottom: 16.0)),
                          Text('$flames',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0)),
                          Text('Flames',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.black45)),
                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Posts',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontFamily: 'Raleway')),
                              Text('$postCount',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0))
                            ],
                          ),
                          Material(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                  child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.photo_filter,
                                    color: Colors.white, size: 30.0),
                              )))
                        ]),
                  ),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => HomePage())),
                )
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 80.0),
                StaggeredTile.extent(2, 300.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(2, 110.0),
              ],
            ),
    ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(user.uid)
        .once();
    print('the snapshot ${snapshot.value}');

    setState(() {
      photoUrl = snapshot.value['photoUrl'];
      username = snapshot.value['username'];
      bio = snapshot.value['bio'];
      display_name = snapshot.value['display_name'];
      flames = snapshot.value['flames'];
      friends = snapshot.value['friends'];
      postCount = snapshot.value['postCount'];
      _isLoading = false;
    });
  }

/*Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Theme.of(context).primaryColor],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2.0, 1.0),
            blurRadius: 10.0,
          )
        ],
      ),
      child: Center(
        child: RaisedButton(onPressed: widget.onMenuPressed, child: Text("Open Menu"),),
      ),
    );*/
}

//stuff
class HomePageAnimator {
  HomePageAnimator(this.controller)
      : translateLeft = Tween(begin: 0.0, end: -200.0).animate(controller),
        scaleDown = Tween(begin: 1.0, end: 0.8).animate(controller);

  final AnimationController controller;
  final Animation<double> translateLeft;
  final Animation<double> scaleDown;
}

class BackgroundCommon extends StatelessWidget {
  BackgroundCommon({this.child, Key key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: FractionalOffset.topCenter,
        stops: [0.2, 1],
        colors: aquaGradients,
      )),
      child: child);
}

class MenuButtons extends StatelessWidget {
  MenuButtons(
      {this.onHomePressed,
      this.onChatPressed,
      this.onFeedPressed,
      this.onProfilePressed,
      this.onSettingsPressed});

  final VoidCallback onHomePressed;
  final VoidCallback onChatPressed;
  final VoidCallback onFeedPressed;
  final VoidCallback onProfilePressed;
  final VoidCallback onSettingsPressed;

  List<Widget> _allButtons({int notifications}) => [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 30.0, bottom: 20.0),
          child: Button.home(onHomePressed),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, bottom: 20.0),
          child: Button.chat(onChatPressed, notification: notifications),
        ),
        /* Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 20.0),
      child: Button.feed(onFeedPressed),
    ),*/
        Padding(
          padding: const EdgeInsets.only(left: 50.0, bottom: 20.0),
          child: Button.profile(onProfilePressed),
        ),
        Button.settings(onSettingsPressed)
      ];

  @override
  Widget build(BuildContext context) {
    Button.context = context;
    return Container(
      child: Column(
        children: _allButtons(notifications: 5),
      ),
    );
  }
}

class Button {
  static BuildContext context;

  static Widget home(VoidCallback onPressed) =>
      _buildButton(onPressed, "BACK", Icons.arrow_back_ios);

  static Widget chat(VoidCallback onPressed, {int notification}) =>
      _buildButton(onPressed, "NOTIFICATIONS", Icons.notifications_active,
          notification: notification);

//  static Widget feed(VoidCallback onPressed) => _buildButton(onPressed, "FEED", Icons.rss_feed);

  static Widget profile(VoidCallback onPressed) =>
      _buildButton(onPressed, "THEME", Icons.color_lens);

  static Widget settings(VoidCallback onPressed) =>
      _buildButton(onPressed, "SETTINGS", Icons.settings);

  static Widget _buildButton(
      VoidCallback onPressed, String title, IconData icon,
      {int notification}) {
    if (notification != null) {
      return Container(
        child: Stack(
          children: <Widget>[
            _button(onPressed, title, icon),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.redAccent),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "$notification",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return _button(onPressed, title, icon);
    }
  }

  static Widget _button(VoidCallback onPressed, String title, IconData icon) =>
      RaisedButton(
        color: Theme.of(context).accentColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(icon)
            ],
          ),
        ),
      );
}
