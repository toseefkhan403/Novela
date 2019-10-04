import 'package:arctic_pups/services.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:arctic_pups/utils/paytm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arctic_pups/main.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PayUsMoney {
  static showPaymentOptions(BuildContext context, bool comingFromMainPage) {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            shadowColor: Color(0x802196F3),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [kShrinePink400, kShrinePink500],
              )),
              child: Center(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.clear,
                                color: Colors.white, size: 25.0),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 18.0, left: 20.0),
                          margin: EdgeInsets.only(top: 18.0),
                          child: Text(
                            comingFromMainPage
                                ? 'Buy more points'
                                : 'Ah! You are short of balance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      padding: EdgeInsets.only(bottom: 18.0, left: 30.0),
                      margin: EdgeInsets.only(top: 18.0),
                      child: Text(
                        'Don\'t let the fun die. Get premium or watch an ad!',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(bottom: 18.0, left: 30.0),
                      child: Text(
                        'Benefits of premium: ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(bottom: 18.0, left: 30.0),
                      child: Text(
                        'Snoop through other\'s conversations, intimate photos & videos! 😉',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(bottom: 18.0, left: 30.0),
                      child: Text(
                        'Get access to all the stories on all of your devices!',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(bottom: 18.0, left: 30.0),
                      child: Text(
                        'Pay once and enjoy on as many devices as you like! 🙌🙌',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(bottom: 18.0, left: 30.0),
                      child: Text(
                        'Escape reality with our best thrillers and scary stories. 🤯',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),

                    //button
                    Container(
                      margin: EdgeInsets.only(top: 32.0),
                      child: Center(
                        child: InkWell(
                          onTap: () => doThePaymentPlease(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 16.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15,
                                      spreadRadius: 0,
                                      offset: Offset(0.0, 32.0)),
                                ],
                                borderRadius: new BorderRadius.circular(36.0),
                                border: Border.all(
                                    color: Colors.black87, width: 1.0)),
                            child: Text(
                              'Buy Premium via Play Store',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway'),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //button
                    Container(
                      margin: EdgeInsets.only(top: 32.0),
                      child: Center(
                        child: InkWell(
                          onTap: () => initPayment(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 16.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15,
                                      spreadRadius: 0,
                                      offset: Offset(0.0, 32.0)),
                                ],
                                borderRadius: new BorderRadius.circular(36.0),
                                border: Border.all(
                                    color: Colors.black87, width: 1.0)),
                            child: Text(
                              'Buy points via Paytm',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway'),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //button
                    Container(
                      margin: EdgeInsets.only(top: 32.0),
                      child: Center(
                        child: InkWell(
                          onTap: () => _showAd(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 16.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15,
                                      spreadRadius: 0,
                                      offset: Offset(0.0, 32.0)),
                                ],
                                borderRadius: new BorderRadius.circular(36.0),
                                border: Border.all(
                                    color: Colors.black87, width: 1.0)),
                            child: Text(
                              'Watch an ad to get instant 40 points',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void _showAd(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
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
                      children: <Widget>[
                        Center(
                          child: SpinKitRipple(
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Please wait...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user.uid)
        .child('points')
        .once();
    int currentPoints = snapshot.value;

    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['horror', 'text story app'],
      contentUrl: 'http://www.novelle.dx.am/',
      birthday: DateTime.now(),
      childDirected: false,
      designedForFamilies: true,
      gender: MobileAdGender.unknown,
//        testDevices: <String>['D4B707E34B0E9A024C6021CEF86FD426']
    );

    await RewardedVideoAd.instance.load(
        adUnitId: 'ca-app-pub-4857431878844198/3584909688',
        targetingInfo: targetingInfo);

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
      }

      if (event == RewardedVideoAdEvent.failedToLoad ||
          event == RewardedVideoAdEvent.leftApplication) {
        showTopToast('The ad failed to load');
        Navigator.maybePop(context);
      }

      if (event == RewardedVideoAdEvent.closed) Navigator.maybePop(context);

      if (event == RewardedVideoAdEvent.rewarded) {
        currentPoints += 40;
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(user.uid)
            .child('points')
            .set(currentPoints);
        Navigator.maybePop(context);
        Navigator.maybePop(context);
        showTopToast('+40 points added to your account');
        showTopToast('+40 points added to your account');
      }
    };
  }

  static showUnlockDialog(
      BuildContext context, String what, int howMuch, String extra,
      {void onUnlock()}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    int buyTapCount = 0;
    showDialog(
        context: context,
        builder: (context) {
          return Center(
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
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Unlock $what$extra for $howMuch points only!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 32.0),
                          child: Center(
                            child: InkWell(
                              splashColor: Colors.black38,
                              onTap: () async {
                                if (buyTapCount == 0) {
                                  buyTapCount++;
                                  DataSnapshot snaps = await FirebaseDatabase
                                      .instance
                                      .reference()
                                      .child('users')
                                      .child(user.uid)
                                      .child('points')
                                      .once();
                                  int availablePoints = snaps.value;

                                  if (availablePoints >= howMuch) {
                                    //cut the points and proceed
                                    await FirebaseDatabase.instance
                                        .reference()
                                        .child('users')
                                        .child(user.uid)
                                        .child('points')
                                        .set(availablePoints - howMuch);

                                    showTopToast(
                                        '$what unlocked successfully!');
                                    Navigator.pop(context);
                                    onUnlock();
                                  } else {
                                    //you dont have enough points \ buy more points option
                                    showTopToast(
                                        'You don\'t have enough points!');
                                    Navigator.pop(context);
                                    PayUsMoney.showPaymentOptions(
                                        context, false);
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 36.0, vertical: 16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 15,
                                          spreadRadius: 0,
                                          offset: Offset(0.0, 32.0)),
                                    ],
                                    borderRadius:
                                        new BorderRadius.circular(36.0),
                                    border: Border.all(
                                        color: Colors.black87, width: 1.0)),
                                child: Text(
                                  'Buy',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Raleway'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 32.0, bottom: 32.0),
                          child: Center(
                            child: InkWell(
                              splashColor: Colors.black38,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 36.0, vertical: 16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 15,
                                          spreadRadius: 0,
                                          offset: Offset(0.0, 32.0)),
                                    ],
                                    borderRadius:
                                        new BorderRadius.circular(36.0),
                                    border: Border.all(
                                        color: Colors.black87, width: 1.0)),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Raleway'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static void initPayment(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Paytm();
        });
  }

  static void doThePaymentPlease(BuildContext context) async {
    InAppPurchaseConnection.instance.purchaseUpdatedStream.listen((purchases) {
      if (purchases.isNotEmpty) {
        for (PurchaseDetails purchase in purchases) {
          if (purchase.status == PurchaseStatus.purchased) {
            if (purchase.productID == "product_sub_01") {
              deliverThePurchase(purchase);
              showTopToast("You have subscribed succesfully!");
              Navigator.maybePop(context);
            }
          }
        }
      }
    });

    bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (available) {
      const Set<String> _kIds = {'product_sub_01'};
      final ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_kIds);

      List<ProductDetails> products = response.productDetails;

      for (ProductDetails p in products) {
        final PurchaseParam purchaseParam = PurchaseParam(productDetails: p);
        InAppPurchaseConnection.instance
            .buyNonConsumable(purchaseParam: purchaseParam);
      }
    } else {
      showTopToast("The store cannot be reached right now. Try again later");
    }
  }

  static void deliverThePurchase(PurchaseDetails purchase) async {
    print('delivering the purchase');
    paidUser = true;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user.uid)
        .child('paid')
        .set(true);

    FirebaseDatabase.instance
        .reference()
        .child('purchase_record')
        .child(user.uid)
        .set({
      'purchaseId': purchase.purchaseID,
      'purchaseDate': purchase.transactionDate,
    });
  }
}
