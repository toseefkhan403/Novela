import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'pages/home_screen.dart';

String globalPhone;
DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("Users");

//todo turn the button into the progress button
//todo try showing snackbars on top?
//todo adding shimmer loading list

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    FirebaseAuth.instance.currentUser().then((user){
      print('this is the uid ${user.uid}');
    });

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Background(),
            Login(),
          ],
        ));
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  String phoneNo,smsCode,verifId;

  bool showOtp = false;

  Future<void> verifyPhone() async{

    if (globalPhone.length == 10) {
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        verifId = verId;
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        verifId = verId;
        setState(() {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Sending OTP...'), duration: Duration(seconds: 3), backgroundColor: kShrineBrown900,));
          showOtp = true;
        });
      /*  smsCodeDialog(context).then((value) {
          print("signed in");
        });*/
      };

      final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
        print('verified');
        if (user.uid != null) {
          databaseReference.child(user.uid).set({'uid' : '${user.uid}', 'phoneNo' : '$globalPhone'});
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Verification Successful'), duration: Duration(seconds: 4), backgroundColor: kShrineBrown900,));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomeScreenHolder()));
        }
      };

      final PhoneVerificationFailed verifiedFailed = (AuthException e) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Failed to verify'), duration: Duration(seconds: 4), backgroundColor: kShrineErrorRed,));
        print('Failed to verify ${e.message}');
      };

      phoneNo = "+91" + globalPhone;

      print('this is phone number $phoneNo');

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 119),
          verificationCompleted: verifiedSuccess,
          verificationFailed: verifiedFailed,
          codeSent: smsCodeSent,
          codeAutoRetrievalTimeout: autoRetrieve);
    }else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Phone number is not valid"), duration: Duration(seconds: 3),backgroundColor: kShrineBrown600,));
    }
  }


  @override
  Widget build(BuildContext context) {
    return buildScreen();
  }

  Widget buildScreen(){

    if(!showOtp){
      return Column(
        children: <Widget>[
          Padding(
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.3),
          ),
          Column(
            children: <Widget>[
              ///holds email header and inputField
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 40, bottom: 10),
                    /*child: Text(
                    "Email",
                    style: TextStyle(fontFamily: 'Raleway',fontSize: 16, color: Color(0xFF999A9A)),
                  ),*/
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      InputWidget(30.0, 0.0),
                      Padding(
                          padding: EdgeInsets.only(right: 50),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Text(
                                      'Enter your Phone Number to continue...',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Color(0xFFA0A0A0),
                                          fontSize: 12),
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  gradient: LinearGradient(
                                      colors: signInGradients,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                ),
                                child: InkWell(
                                  onTap: verifyPhone,
                                  child: ImageIcon(
                                    AssetImage("assets/images/ic_forward.png"),
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
              ),
              InkWell(onTap: verifyPhone,child: roundedRectButton("Let's get Started", signInGradients, false)),
//            roundedRectButton("Create an Account", signUpGradients, false),
            ],
          )
        ],
      );
    }else {

      //the dialog otp screen
      TextEditingController controller = TextEditingController();
      bool hasError = false;

      return Padding(
        padding: const EdgeInsets.only(top: 180.0),
        child: Column(
                    children: <Widget>[
                      PinCodeTextField(
                        autofocus: false,
                        controller: controller,
                        hideCharacter: false,
                        highlight: true,
                        highlightColor: kShrinePink400,
                        defaultBorderColor: kShrinePink500,
                        hasTextBorderColor: Colors.green,
                        maxLength: 6,
                        hasError: hasError,
                        onTextChanged: (text) {
                          smsCode = text;
                        },
                        /*onDone: (text){
                          smsCode = text;
                          print('on done called');
                        },*/
                        pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                        wrapAlignment: WrapAlignment.start,
                        pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 25.0),
                        pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration: Duration(milliseconds: 200),
                      ),
                      Visibility(
                        child: Text(
                          "Wrong PIN!",
                          style: TextStyle(color: Colors.red),
                        ),
                        visible: hasError,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FlatButton(
                              textColor: Colors.pinkAccent,
                              child: Text('Change the given number'),
                              onPressed: (){
                                setState(() {
                                  showOtp = false;
                                });
                              },
                            ),
                            FlatButton(
                              textColor: Colors.pinkAccent,
                              child: Text('Resend the otp'),
                              onPressed: (){
                                setState(() {
                                  showOtp = false;
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please enter the phone number again'), duration: Duration(seconds: 4), backgroundColor: kShrineBrown900,));
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      InkWell(onTap:() {
                         FirebaseAuth.instance.currentUser().then((user){
                          if (user != null) {
                            databaseReference.child(user.uid).set({'uid' : '${user.uid}', 'phoneNo' : '$globalPhone'});
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreenHolder()));
                          }else {
                            FirebaseAuth.instance
                                .signInWithPhoneNumber(
                                verificationId: verifId,
                                smsCode: smsCode).then((user){

                              databaseReference.child(user.uid).set({'uid' : '${user.uid}', 'phoneNo' : '$globalPhone'});
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Verification Successful'), duration: Duration(seconds: 4), backgroundColor: kShrineBrown900,));
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreenHolder()));

                            }).catchError((e){
                              print('that is the fucking error $e');
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Verification Failed'), duration: Duration(seconds: 4), backgroundColor: kShrineErrorRed,));
                              setState(() {
                                hasError = true;
                              });
                            });
                          }
                        });
                      },
                          child: roundedRectButton("SUBMIT", signUpGradients, false))
                    ],
        ),
      );
    }

  }
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
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
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/images/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
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

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
             // Image.asset('assets/collaboration.png', width: MediaQuery.of(context).size.width/1.5,),
              WavyHeader(),
            ],
          ),
          Expanded(
            child: Container(
            ),
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              WavyFooter(),
              CirclePink(),
              CircleYellow(),
            ],
          )
        ],
      ),
    );
  }
}

const List<Color> orangeGradients = [
 /* Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),*/
 kShrinePink600,
 kShrinePink600,
 Colors.pinkAccent

];

const List<Color> aquaGradients = [
  /*Color(0xFF5AEAF1),
  Color(0xFF8EF7DA),*/
  kShrineBrown900,
  kShrineBrown600,
];

class WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: orangeGradients,
              begin: Alignment.topLeft,
              end: Alignment.center),
        ),
        height: MediaQuery.of(context).size.height / 2.5,
      ),
    );
  }
}

class WavyFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FooterWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: aquaGradients,
              begin: Alignment.center,
              end: Alignment.bottomRight),
        ),
        height: MediaQuery.of(context).size.height / 3,
      ),
    );
  }
}

class CirclePink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-70.0, 90.0),
      child: Material(
        color: Colors.pinkAccent,
        child: Padding(padding: EdgeInsets.all(120)),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 15.0)),
      ),
    );
  }
}

class CircleYellow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, 210.0),
      child: Material(
        color: kShrinePink500,
        child: Padding(padding: EdgeInsets.all(140)),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 15.0)),
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 5, size.height / 4);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint =
    Offset(size.width - (size.width / 9), size.height / 6);
    var thirdEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 60);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class YellowCircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return null;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

class InputWidget extends StatelessWidget {
  final double topRight;
  final double bottomRight;

  InputWidget(this.topRight, this.bottomRight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(bottomRight),
                  topRight: Radius.circular(topRight))),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                FlatButton(
                    onPressed: (){},
                    child: Text("+91 (INDIA)"),
                ),
                TextField(
                  onChanged: (value){
                    globalPhone = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your phone number",
                      hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
