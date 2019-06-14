import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class FirebaseService {

  FirebaseService() {
    initFirebase();
  }

  initFirebase() async {
//    final FirebaseApp app = await
    FirebaseApp.configure(
        name: 'arctic-pups',
        options: Platform.isIOS
            ? const FirebaseOptions(
          googleAppID: '1:444983347642:ios:518deca9f81df8c2',
          gcmSenderID: '444983347642',
          databaseURL: 'https://arctic-pups.firebaseio.com/',
        )
            : const FirebaseOptions(
          googleAppID: '1:444983347642:android:347d39e2912550c1',
          apiKey: 'AIzaSyCJS8-fAiq02J5CIg7MHgUWvDuwc7GV7SE',
          databaseURL: 'https://arctic-pups.firebaseio.com/',
        ));

  }

  static Future<String> createMountain() async {
    String accountKey = await _getAccountKey();

    var mountain = <String, dynamic>{
      'name' : '',
      'created': '12th jan',
    };

    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .push();

    reference.set(mountain);

    return reference.key;
  }

  static Future<void> saveName(String mountainKey, String name) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child('name')
        .set(name);
  }

  static Future<StreamSubscription<Event>> getNameStream(void onData(String name)) async {
    String accountKey = await _getAccountKey();
    print(accountKey);

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(accountKey)
        .child("phoneNo")
        .onValue
        .listen((Event event) {
      String name = event.snapshot.value as String;
      if (name == null) {
        name = "sh";
      }
      onData(name);
    });

    return subscription;
  }

  static Future<Query> queryMountains() async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .orderByChild("name");
  }

}

_getAccountKey() => FirebaseAuth.instance.currentUser().then((user) => user.uid);




