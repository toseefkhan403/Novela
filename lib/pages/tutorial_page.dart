import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController =
        new PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new PageView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        controller: pageController,
        children: [
          PageOne(),
          PageTwo(),
          PageThree(),
        ],
      ),
    );
  }
}

//this has to look awesome
class PageOne extends StatelessWidget {

  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 64.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: gradients,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[

          //icon
          Center(
            child: Image.asset(
              'assets/images/dogCute.jpeg',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),

          //heading
          Container(
            margin: EdgeInsets.only(top: 18.0),
            child: Text(
              'Fill in your info for Celfie',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 32.0,
                fontFamily: 'Oxygen',
              ),
            ),
          ),

          //email text field
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 32.0, top: 32.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: Offset(0.0, 16.0)),
                ],
                borderRadius: new BorderRadius.circular(12.0),
                gradient: LinearGradient(
                    begin: FractionalOffset(0.0, 0.4),
                    end: FractionalOffset(0.9, 0.7),
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [
                      0.2,
                      0.9
                    ],
                    colors: [
                      Color(0xffFFC3A0),
                      Color(0xffFFAFBD),
                    ])),
            child: TextField(
              style: hintAndValueStyle,
              controller: emailController,
              decoration: new InputDecoration(
                  contentPadding:
                      new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  hintText: 'Email',
                  hintStyle: hintAndValueStyle),
            ),
          ),

          //password Field
          Container(
            margin: EdgeInsets.only(left: 32.0, right: 16.0),
            child: TextField(
              controller: passwordController,
              style: hintAndValueStyle,
              obscureText: true,
              decoration: new InputDecoration(
                  fillColor: Color(0x3305756D),
                  filled: true,
                  contentPadding:
                      new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  hintText: 'Password',
                  hintStyle: hintAndValueStyle),
            ),
          ),

          //login button
          Container(
            margin: EdgeInsets.only(left: 32.0, top: 32.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {

                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: Offset(0.0, 32.0)),
                        ],
                        borderRadius: new BorderRadius.circular(36.0),
                        gradient:
                            LinearGradient(begin: FractionalOffset.centerLeft,
// Add one stop for each color. Stops should increase from 0 to 1
                                stops: [
                              0.2,
                              1
                            ], colors: [
                          Color(0xff000000),
                          Color(0xff434343),
                        ])),
                    child: Text(
                            'SAVE',
                            style: TextStyle(
                                color: Color(0xffF1EA94),
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
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

const List<Color> gradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];

TextStyle hintAndValueStyle = TextStyle(
    color: Color(0xff353535),
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    fontFamily: 'Raleway');