import 'dart:async';
import 'dart:io';
import 'package:arctic_pups/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:paytm_payments/paytm_payments.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class FirebaseService {
  FirebaseService() {
    initPayments();
    initFirebase();
    firebaseCloudMessagingListeners();
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

    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-4857431878844198~9332060381");

  }

  void firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) iOS_Permission();

    String token = await _firebaseMessaging.getToken();
    String uid = await _getAccountKey();

    if (uid != null && token != null) {
      await FirebaseDatabase.instance
          .reference()
          .child('token')
          .child(uid)
          .set(token);
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  //some boiler-plate code
  static Future<String> createMountain() async {
    String accountKey = await _getAccountKey();

    var mountain = <String, dynamic>{
      'name': '',
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

  static Future<StreamSubscription<Event>> getNameStream(
      void onData(String name)) async {
    String accountKey = await _getAccountKey();

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

  static Stream getNameStream2() {
    String uid;
    FirebaseAuth.instance
        .currentUser()
        .then((FirebaseUser user) => uid = user.uid);

    return FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child("iHvlDE4uWYg4GwUM9zXgsVIgg5o2")
        .child("phoneNo")
        .onValue;
  }

  void initPayments() {

    PaytmPayments.responseStream.listen((Map<dynamic, dynamic> responseData){
      print('function trigerred');
      print('Response code ${responseData.toString()}');

      if(responseData['STATUS'].toString() == "TXN_SUCCESS"){
        _addPoints();
      }

      /*
      {CURRENCY: INR, GATEWAYNAME: PPBLC, RESPMSG: Txn Success, PAYMENTMODE: UPI, MID: PIMOIn97892499954424,
       RESPCODE: 01, TXNAMOUNT: 1.00, TXNID: 20190910111212800110168140186967271, ORDERID: 1568120445208, STATUS: TXN_SUCCESS, BANKTXNID: 925342772828, TXNDATE: 2019-09-10 18:30:47.0,
       CHECKSUMHASH: 38+U+g+T9ouFNbiuNuGyU51JkN43l+FqvaDA5guYeKssSsHne6hY81T9bAfmwrB7aIgFzWIFHPptliBSoGzczS8II1hej1CY+AcB0PpAP1o=}
      * */
    });
  }

}

_addPoints() async {

  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(user.uid)
      .child('points')
      .once();
  int currentPoints = snapshot.value;

  currentPoints += 40;
  FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(user.uid)
      .child('points')
      .set(currentPoints);

  showTopToast('Payment completed successfully! \n 40 points added to your account');

}

Future<String> _getAccountKey() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user.uid;
}
