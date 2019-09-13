import 'package:arctic_pups/main.dart';
import 'package:arctic_pups/pay_us_money.dart';
import 'package:backdrop/backdrop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/size_util.dart';
import 'package:arctic_pups/pages/view_chat_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

//this page should get the stories from db and display them
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

List<dynamic> postsList = List();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

    return BackdropScaffold(
        title: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Text("Novella",
              style: TextStyle(
                color: Colors.white,
              )),
        )),
        headerHeight: 162.0,
        backpanel: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Manage your coins'),
              leading: Icon(
                Icons.attach_money,
                color: Colors.amberAccent,
              ),
            ),
            ListTile(
              title: Text('Report a problem'),
              leading: Icon(
                Icons.report,
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(
                Icons.help,
                color: Colors.blue,
              ),
            ),
            ListTile(
              onTap: () async {
                FirebaseUser user = await FirebaseAuth.instance.currentUser();
                await FirebaseDatabase.instance
                    .reference()
                    .child('token')
                    .child(user.uid)
                    .remove();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => RootPage()));
              },
              title: Text('Logout'),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        body: StoriesPage());
  }
}

class StoriesPage extends StatefulWidget {
  @override
  _StoriesPageState createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage>
    with AutomaticKeepAliveClientMixin<StoriesPage> {
  List storyList;
  bool _isLoading = true;
  SharedPreferences preferences;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _isLoading
            ? SpinKitRipple(
                color: Colors.white,
              )
            : ListView.builder(
                shrinkWrap: false,
                itemCount: storyList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(storyList[index]['title']),
                    leading: Image.network(storyList[index]['image']),
                    contentPadding: EdgeInsets.all(8.0),
                    onTap: () async {
                      FirebaseUser user =
                          await FirebaseAuth.instance.currentUser();
                      DataSnapshot snapshot = await FirebaseDatabase.instance
                          .reference()
                          .child('user_unlocked_stories')
                          .child(user.uid)
                          .child(storyList[index]['title'])
                          .once();

                      print('the snappppppppp ${snapshot.value}');
                      if (snapshot.value == null) {
                        //the story is locked
                        PayUsMoney.showUnlockDialog(context,
                            storyList[index]['title'], 100, '-all episodes',
                            onUnlock: () {});
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewChats(
                                storyList[index]['title'],
                                preferences.getInt(storyList[index]['title']) ==
                                        null
                                    ? 1
                                    : preferences
                                        .getInt(storyList[index]['title']),
                                storyList[index]['totalEpisodes'])));
                      }
                    },
                  );
                }));
  }

  @override
  bool get wantKeepAlive => true;

  void _initData() async {
    preferences = await SharedPreferences.getInstance();
    DataSnapshot snapshot =
        await FirebaseDatabase.instance.reference().child('stories').once();

    setState(() {
      storyList = (snapshot.value as Map<dynamic, dynamic>).values.toList();
      print('this is storylist $storyList');

      _isLoading = false;
    });
  }
}
