import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:arctic_pups/base_auth.dart';
import 'package:arctic_pups/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//global variables
PageController pageController;
BaseAuth baseAuth = Auth();

//todo turn the button into the progress button
//todo try showing snackbars on top?
//todo adding shimmer loading list
//todo add the user into db

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
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
      body: new PageView(
        controller: pageController,
        children: [
          GLogin(),
          SignIn(),
        ],
      ),
    );
  }
}

class GLogin extends StatefulWidget {
  @override
  _GLoginState createState() => _GLoginState();
}

class _GLoginState extends State<GLogin> {
  String email, password;

  bool _isGloading = false;
  bool _isFbLoading = false;
  bool _isLoading = false;
  bool isEverythingOk = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _everythingIsOk() {
    email = emailController.value.text;
    password = passwordController.value.text;

    if (password.length > 6) {
      if (email.contains('@')) {
        return true;
      } else {
        showTopToast("Email address is wrong", context);
      }
    } else {
      showTopToast("Password is too short", context);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 64.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: signInGradients,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/dogCute.jpeg',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          headlinesWidget(),

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
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      if (_everythingIsOk()) {
                        String uid = await baseAuth.signIn(email, password);
                        bool isVerified = await baseAuth.isEmailVerified();

                        if (isVerified) {
                          //continue to home page
                          print("Email is verified");
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => RootPage()));
                        } else {
                          showTopToast("Email is not verified", context);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        setState(() {
                          print('setting isLoading false');
                          _isLoading = false;
                        });
                      }
                    } catch (e) {
                      showTopToast(
                          "Incorrect email and password combination", context);
                      setState(() {
                        print('setting isLoading false2');
                        _isLoading = false;
                      });
                    }
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
                        gradient: LinearGradient(
                            begin: FractionalOffset.centerLeft,
// Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.2, 1],
                            colors: aquaGradients)),
                    child: _isLoading
                        ? SpinKitFadingCircle(color: Colors.white)
                        : Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway'),
                          ),
                  ),
                ),
              ],
            ),
          ),

          //Google sign in button
          Container(
            margin: EdgeInsets.only(left: 32.0, top: 32.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    setState(() {
                      _isGloading = true;
                    });

                    String uid = await baseAuth.signInUsingGoogle();

                    if (uid.isEmpty) {
                      showTopToast(
                          'An unexpected error occurred. Please try again later',
                          context);
                      setState(() {
                        _isGloading = false;
                      });
                    } else {
                      //Continue to home page
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => RootPage()));
                    }
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
                    child: _isGloading
                        ? SpinKitFadingCircle(color: Colors.white)
                        : Text(
                            'GOOGLE LOGIN',
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

          //fb
          Container(
            margin: EdgeInsets.only(left: 32.0, top: 32.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    setState(() {
                      _isFbLoading = true;
                    });

                    String uid = await baseAuth.signInUsingFacebook();

                    if (uid.isEmpty) {
                      showTopToast(
                          'An unexpected error occurred. Please try again later',
                          context);
                      setState(() {
                        _isFbLoading = false;
                      });
                    } else {
                      //Continue to home page
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => RootPage()));
                    }
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
                        gradient: LinearGradient(
                            begin: FractionalOffset.centerLeft,
// Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.2, 1],
                            colors: aquaGradients)),
                    child: _isFbLoading
                        ? SpinKitFadingCircle(color: Colors.white)
                        : Text(
                            'FACEBOOK LOGIN',
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
          signupWidget(),
        ],
      ),
    );
  }
}

Widget signupWidget() {
  return Container(
    margin: EdgeInsets.only(left: 48.0, top: 32.0),
    child: Row(
      children: <Widget>[
        Text(
          'Don\'t have an account?',
          style: TextStyle(fontFamily: 'Raleway'),
        ),
        FlatButton(
          onPressed: () {
            pageController.animateToPage(1,
                duration: Duration(seconds: 2), curve: Curves.bounceIn);
            print('Sign Up button pressed');
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
                color: Color(0xff353535),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway'),
          ),
        )
      ],
    ),
  );
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email, password;

  bool _isLoading = false;
  bool isEverythingOk = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  bool _everythingIsOk() {
    email = emailController.value.text;
    password = passwordController2.value.text;

    if (passwordController.value.text == passwordController2.value.text) {
      if (email.contains('@')) {
        if (password.length > 6) {
          showTopToast("Signing you in...", context);
          return true;
        } else {
          showTopToast("Password is too short", context);
        }
      } else {
        showTopToast("Email address is incorrect", context);
      }
    } else {
      showTopToast("Passwords do not match", context);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 64.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: signUpGradients,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 48.0, top: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'WELCOME!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 20.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 48.0),
                  child: Text(
                    'Sign Up \nfor Celfie.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 32.0,
                      fontFamily: 'Oxygen',
                    ),
                  ),
                )
              ],
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

          //password Field
          Container(
            margin: EdgeInsets.only(left: 32.0, right: 16.0),
            child: TextField(
              controller: passwordController2,
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
                  hintText: 'Confirm Password',
                  hintStyle: hintAndValueStyle),
            ),
          ),

          //sign up button
          Container(
            margin: EdgeInsets.only(left: 32.0, top: 32.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    try {
                      setState(() {
                        _isLoading = true;
                      });

                      if (_everythingIsOk()) {
                        String uid = await baseAuth.signUp(email, password);

                        if (uid.isNotEmpty) {
                          baseAuth.sendEmailVerification();
                          showTopToast(
                              'Verification email has been sent', context);
                          setState(() {
                            _isLoading = false;
                          });
                          pageController.animateToPage(0,
                              duration: Duration(seconds: 1),
                              curve: Curves.ease);
                        }
                      } else {
                        setState(() {
                          print('setting isLoading false');
                          _isLoading = false;
                        });
                      }
                    } catch (e) {
                      showTopToast('Oops.. an error occurred', context);
                      setState(() {
                        print('setting isLoading false in catch');
                        _isLoading = false;
                      });
                    }
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
                          Color(0xffFFC3A0),
                          Color(0xffFFAFBD),
                        ])),
                    child: _isLoading
                        ? SpinKitFadingCircle(color: Colors.white)
                        : Text(
                            'SIGN UP',
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

          Container(
            margin: EdgeInsets.only(left: 32.0, top: 32.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    pageController.animateToPage(0,
                        duration: Duration(seconds: 2), curve: Curves.ease);
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
                      'back to login',
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

TextStyle hintAndValueStyle = TextStyle(
    color: Color(0xff353535),
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    fontFamily: 'Raleway');

Widget headlinesWidget() {
  return Container(
    margin: EdgeInsets.only(left: 48.0, top: 32.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'WELCOME BACK!',
          textAlign: TextAlign.left,
          style: TextStyle(
              letterSpacing: 3,
              fontSize: 20.0,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 48.0),
          child: Text(
            'Log in \nto continue.',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 3,
              fontSize: 32.0,
              fontFamily: 'Oxygen',
            ),
          ),
        )
      ],
    ),
  );
}

Widget roundedRectButton(String title, List<Color> gradient, bool isLoading) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: isLoading
                ? SpinKitFadingCircle(color: Colors.white)
                : Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  /* Color(0xFFFF9945),
  Color(0xFFFc6076),*/
  kShrinePink500,
  kShrinePink600,
  Colors.pinkAccent,
];

const List<Color> orangeGradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];

const List<Color> aquaGradients = [
  Color(0xFF5AEAF1),
  Color(0xFF8EF7DA),
];
