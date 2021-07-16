import 'package:arctic_pups/pages/root_page.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arctic_pups/services.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  runApp(
    OKToast(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService();

    return MaterialApp(
      title: 'Novela',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: kShrinePink400,
          backgroundColor: Colors.black,
          fontFamily: 'Raleway'),
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}