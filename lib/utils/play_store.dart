import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


class PlayStore extends StatefulWidget {
  @override
  _PlayStoreState createState() => _PlayStoreState();
}

class _PlayStoreState extends State<PlayStore> {

  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
//      _handlePurchaseUpdates(purchases);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Container();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

