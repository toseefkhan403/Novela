import 'package:arctic_pups/pages/share_page.dart';
import 'package:arctic_pups/main.dart';
import 'package:arctic_pups/pages/stories_page.dart';
import 'package:arctic_pups/pay_us_money.dart';
import 'package:arctic_pups/utils/backdrop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/size_util.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Backdrop(
        frontHeading: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
        ),
        backTitle: Center(
            child: Text("Options",
                style: TextStyle(
                  color: Colors.white,
                ))),
        frontAction: SizedBox(width: 56.0),
          frontTitle: Center(
              child: Text("Novella",
              style: TextStyle(
                color: Colors.white,
              ))),
          backLayer: Container(
            color: Colors.black,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  onTap: () async {
                    FirebaseUser user = await FirebaseAuth.instance.currentUser();
                    showDialog(
                        context: context,
                        builder: (context) => _myDialog(user.uid));
                  },
                  title: Text('View your points'),
                  leading: Icon(
                    Icons.attach_money,
                    color: Colors.amberAccent,
                  ),
                ),
                ListTile(
                  onTap: () {
                    PayUsMoney.showPaymentOptions(context, true);
                  },
                  title: Text('Buy more points 🤑'),
                  leading: Icon(
                    Icons.monetization_on,
                    color: Colors.amberAccent,
                  ),
                ),
                ListTile(
                  onTap: () => sendEmail('A query'),
                  title: Text('Contact Us'),
                  leading: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    var url = 'http://www.novelle.dx.am/';

                    if (await canLaunch(url))
                      await launch(url);
                    else
                      showTopToast("Can\'t connect right now.");
                  },
                  title: Text('About'),
                  leading: Icon(
                    Icons.help,
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  onTap: () => sendEmail('Regarding publishing story'),
                  title: Text('Submit your own story!'),
                  leading: Icon(
                    Icons.markunread,
                    color: Colors.redAccent,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    showTopToast('Signing you out...');
                    FirebaseUser user = await FirebaseAuth.instance.currentUser();
                    await FirebaseDatabase.instance
                        .reference()
                        .child('token')
                        .child(user.uid)
                        .remove();
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => RootPage()),
                        (Route<dynamic> route) => false);
                  },
                  title: Text('Logout'),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.white70,
                  ),
                ),
                ListTile(
                  onTap: () async {

                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => SharePage()));
                  },
                  title: Text('Add story'),
                  leading: Icon(
                    Icons.add_comment,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          frontLayer: StoriesPage()),
    );
  }

  void sendEmail(String subject) async {
    var url = "mailto:toseefkhan403@gmail.com?subject=$subject";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showTopToast('Could not connect right now.');
    }
  }

  Widget _myDialog(String uid) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Hi there fellow reader 😃',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    _balanceWidget(uid),
                    SizedBox(
                      height: 80.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SelectableText(
                        'Your userId: $uid',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _balanceWidget(String uid) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Your total points: ',
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
          ),
          StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child('users')
                  .child(uid)
                  .child('points')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      snapshot.data.snapshot.value.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ));

  @override
  void initState() {
    _isFirstTimeLogin();
    super.initState();
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
