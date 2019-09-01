import 'package:flutter/material.dart';
import 'package:arctic_pups/pages/login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arctic_pups/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:arctic_pups/pages/share_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with AutomaticKeepAliveClientMixin<NotificationsPage> {
  bool _isLoading = true;
  List<dynamic> _list;

  @override
  void initState() {
    _gatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: TextStyle(fontFamily: 'Pacifico'),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _list.length != 0
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return _contents(context, _list[index]);
                    },
                    itemCount: _list.length,
                  )
                : Center(
                    child: Text(
                      'No notifications found',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                  ));
  }

  Widget _contents(BuildContext context, data) {
    switch (data['type']) {
      case 'challenge':
        return StreamBuilder(
            stream: FirebaseDatabase.instance
                .reference()
                .child('users')
                .child(data['from'])
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 15.0),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data.snapshot.value['photoUrl']),
                  ),
                  onTap: () {
                    _showDialogForChallenge(data['photoUrl'], data);
                  },
                  subtitle: Text(
                    'Tap here to accept',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                  title: Text(
                    snapshot.data.snapshot.value['username'] +
                        ' has challenged you!',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                );
              } else {
                return Container();
              }
            });

        break;

      case 'friend':
        return StreamBuilder(
            stream: FirebaseDatabase.instance
                .reference()
                .child('users')
                .child(data['from'])
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 15.0),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data.snapshot.value['photoUrl']),
                  ),
                  subtitle: Text(
                    'Tap here to accept',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                  title: Text(
                    snapshot.data.snapshot.value['username'] +
                        ' has sent you a friend request',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                );
              }
            });

        break;

      case 'post':
        return StreamBuilder(
            stream: FirebaseDatabase.instance
                .reference()
                .child('users')
                .child(data['from'])
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 15.0),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data.snapshot.value['photoUrl']),
                  ),
                  title: Text(
                    'Your post with ' +
                        snapshot.data.snapshot.value['username'] +
                        ' ended in a ' +
                        snapshot.data.snapshot.value['result'],
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                );
              }
            });

        break;

      default:
        return Container();
        break;
    }
  }

  void _gatherData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //challenges, friends, post results
    DataSnapshot s = await FirebaseDatabase.instance
        .reference()
        .child('user_challenges')
        .child(user.uid)
        .once();
    DataSnapshot snap = await FirebaseDatabase.instance
        .reference()
        .child('user_friend_requests')
        .child(user.uid)
        .once();
    DataSnapshot snaps = await FirebaseDatabase.instance
        .reference()
        .child('user_post_results')
        .child(user.uid)
        .once();

    List<dynamic> challengeKeyList = List();
    List<dynamic> frList = List();
    List<dynamic> prList = List();

    try {
      if (s != null) {
        challengeKeyList = (s.value as Map<dynamic, dynamic>).values.toList();
      }

      if (snap != null) {
        frList = (snap.value as Map<dynamic, dynamic>).values.toList();
      }

      if (snaps != null) {
        prList = (snaps.value as Map<dynamic, dynamic>).values.toList();
      }
      _list = challengeKeyList + frList + prList;
    } catch (e) {
      _list = challengeKeyList + frList + prList;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showDialogForChallenge(s, data) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Ready to accept?',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20.0, fontFamily: 'Pacifico'),
                  ),
                ),

                //here
                StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .reference()
                        .child('users')
                        .child(data['from'])
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 12.0),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data.snapshot.value['photoUrl']),
                          ),
                          title: Text(
                            snapshot.data.snapshot.value['username'] +
                                ' has challenged you!',
                            style: TextStyle(fontFamily: 'Raleway'),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),

                //the image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 300,
                      height: 300,
                      child: Image.network(
                        s,
                        fit: BoxFit.cover,
                      )),
                ),

                //the buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 2.0, top: 32.0),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => SharePage(
                                            challengeKey: data['key'],
                                            fromUid: data['from'])));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 36.0, vertical: 16.0),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 15,
                                          spreadRadius: 0,
                                          offset: Offset(0.0, 32.0)),
                                    ],
                                    borderRadius:
                                        new BorderRadius.circular(36.0),
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.centerLeft,
// Add one stop for each color. Stops should increase from 0 to 1
                                        stops: [0.2, 1],
                                        colors: aquaGradients)),
                                child: _isLoading
                                    ? SpinKitFadingCircle(color: Colors.white)
                                    : Text(
                                        'ACCEPT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Raleway'),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(left: 2.0, top: 32.0),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                //remove
                                FirebaseUser user =
                                    await FirebaseAuth.instance.currentUser();

                                await FirebaseDatabase.instance
                                    .reference()
                                    .child('user_challenges')
                                    .child(user.uid)
                                    .child(data['key'])
                                    .remove();

                                await FirebaseDatabase.instance
                                    .reference()
                                    .child('challenges')
                                    .child(data['key'])
                                    .child('status')
                                    .set('REJECTED');

                                showTopToast('Rejected Successfully!', context);
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationsPage()));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 36.0, vertical: 16.0),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 15,
                                          spreadRadius: 0,
                                          offset: Offset(0.0, 32.0)),
                                    ],
                                    borderRadius:
                                        new BorderRadius.circular(36.0),
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.centerLeft,
// Add one stop for each color. Stops should increase from 0 to 1
                                        stops: [0.2, 1],
                                        colors: aquaGradients)),
                                child: _isLoading
                                    ? SpinKitFadingCircle(color: Colors.white)
                                    : Text(
                                        'REJECT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Raleway'),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
