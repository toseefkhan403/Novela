import 'package:arctic_pups/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paytm_payments/paytm_payments.dart';

class Paytm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Buy points via Paytm at affordable prices! \nPlease choose from one of the packages below: ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ),

                  _widgets(9, 100),
                  _widgets(99, 1200),
                  _widgets(499, 6000),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgets(int price, int points) => Container(
    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
    child: Center(
      child: InkWell(
        onTap: () {
          showTopToast("Please wait while we redirect you to Paytm...");
          startPayment(price);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
              border: Border.all(color: Colors.black87, width: 1.0)),
          child: Column(
            children: <Widget>[
              Text(
                '$price Rs',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
              Text(
                '$points points',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  startPayment(int price) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    try {
      await PaytmPayments.makePaytmPayment(
        "PIMOIn97892499954424", // [YOUR_MERCHANT_ID] (required field)
        "http://www.novelle.dx.am/generateChecksum.php",
        customerId: user.uid,
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        txnAmount: "$price",
        channelId: "WAP",
        industryTypeId: "Retail",
        website: "DEFAULT",
        staging: false,
        showToast: true,
      );
    } catch (e) {
      print("Some error occurred $e");
      showTopToast('Some error occurred \n Please try again later');
    }
  }
}
