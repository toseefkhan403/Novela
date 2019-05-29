import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  FirebaseService() {
    initFirebase();
  }

  initFirebase() async {
    final FirebaseApp app = await FirebaseApp.configure(
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
    print('this is the app $app');
  }

}