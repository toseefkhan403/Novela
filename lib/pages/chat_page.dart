import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:arctic_pups/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

/*
                                  IMPORTANT
  IF you want a FUTURE go for StreamSubscription and setState()
  If you want a simple query not involving future, go for Stream and StreamBuilder
 */

class _ChatPageState extends State<ChatPage> {
  String uid = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        uid = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("user_account_settings")
                    .child(uid)
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('$snapshot');
                    return Column(
                      children: <Widget>[
                        Text('$uid'),
                        Text('${snapshot.data.snapshot.value}')
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('ooops');
                  } else
                    return CircularProgressIndicator();
                })));
  }
}
