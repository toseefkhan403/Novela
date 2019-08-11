import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:arctic_pups/main.dart';
import 'package:firebase_storage/firebase_storage.dart';

//todo Change the colors of gradients
class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

PageController pageController;

class _TutorialPageState extends State<TutorialPage> {
  @override
  void initState() {
    super.initState();
    pageController =
        new PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new PageView(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
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
class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> with SingleTickerProviderStateMixin {
  TextEditingController displayNameController;
  TextEditingController userNameController;
  TextEditingController bioController;

  Animation<double> animation;
  AnimationController controller;

  bool _isIconAnimCompleted = false;
  bool _isLoading = false;
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    displayNameController = TextEditingController();
    userNameController = TextEditingController();
    bioController = TextEditingController();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();

    Future.delayed(Duration(seconds: 1, milliseconds: 300), () {
      setState(() {
        print('triggering fading animation');
        _isIconAnimCompleted = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    print('callling dispose');
    displayNameController.dispose();
    userNameController.dispose();
    bioController.dispose();
    controller.dispose();
    super.dispose();
  }

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
              width: animation.value,
              height: animation.value,
              fit: BoxFit.contain,
            ),
          ),

          //heading
          AnimatedOpacity(
            duration: Duration(milliseconds: 600),
            opacity: _isIconAnimCompleted ? 1.0 : 0.0,
            child: Container(
              margin: EdgeInsets.only(top: 18.0),
              child: Text(
                'Fill in your info for Celfie',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 32.0,
                  fontFamily: 'Raleway',
                ),
              ),
            ),
          ),

          //image picker
          Center(
            child: InkWell(
              onTap: getImage,
              child: Container(
                margin: EdgeInsets.only(top: 32.0),
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
                child: _image == null
                    ? Container(
                        height: 120.0,
                        width: 120.0,
                        child: Center(
                          child: Icon(Icons.add_photo_alternate),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                            height: 120.0,
                            width: 120.0,
                            child: Image.file(_image, fit: BoxFit.fill))),
              ),
            ),
          ),

          //user name text field
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
                borderRadius: new BorderRadius.circular(14.0),
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
              controller: userNameController,
              decoration: new InputDecoration(
                  contentPadding:
                      new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  hintText: 'Enter your unique username',
                  hintStyle: hintAndValueStyle),
            ),
          ),

          //display name text field
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 32.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: Offset(0.0, 16.0)),
                ],
                borderRadius: new BorderRadius.circular(14.0),
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
              controller: displayNameController,
              decoration: new InputDecoration(
                  contentPadding:
                      new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  hintText: 'Enter your display name',
                  hintStyle: hintAndValueStyle),
            ),
          ),

          //bio Field
          Container(
            margin: EdgeInsets.only(left: 32.0, right: 16.0),
            child: TextField(
              controller: bioController,
              style: hintAndValueStyle,
              decoration: new InputDecoration(
                  fillColor: Color(0x3305756D),
                  filled: true,
                  contentPadding:
                      new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(14.0),
                      borderSide: BorderSide.none),
                  hintText: 'Enter your bio',
                  hintStyle: hintAndValueStyle),
            ),
          ),

          //save button
          Container(
            margin: EdgeInsets.only(top: 32.0),
            child: Center(
              child: InkWell(
                onTap: _saveSecondPageInfo,
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
                            stops: [
                              0.2,
                              1
                            ],
                            colors: [
                              Color(0xFF0EDED2),
                              Color(0xFF03A0FE),
                            ])),
                    child: _isLoading
                        ? SpinKitFadingCircle(color: Colors.white)
                        : Text(
                            'SAVE',
                            style: TextStyle(
                                color: Color(0xffF1EA94),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway'),
                          )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _saveSecondPageInfo() async {
    String displayName = displayNameController.value.text;
    String userName = userNameController.value.text;
    String bio = bioController.value.text;

    userName = userName.replaceAll(" ", '');

    if (displayName.length > 2 && userName.length > 2 && bio.length > 2) {
      bool isTrue = await isUnique(userName);
      if (isTrue) {
        if (_image != null) {
          setState(() {
            _isLoading = true;
          });

          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          StorageReference ref = FirebaseStorage.instance
              .ref()
              .child('photos')
              .child(user.uid)
              .child("profile_photo");
          StorageUploadTask uploadTask = ref.putFile(_image);
          String imageURL =
              await (await uploadTask.onComplete).ref.getDownloadURL();

          if (imageURL.isNotEmpty) {
            DatabaseReference dbRef = FirebaseDatabase.instance
                .reference()
                .child('users')
                .child(user.uid);

            await dbRef.set({
              'username': userName,
              'display_name': displayName,
              'bio': bio,
              'photoUrl': imageURL,
              'uid' : user.uid
            });

            setState(() {
              _isLoading = false;
              showTopToast('Info saved successfully!', context);

              pageController.animateToPage(2,
                  duration: Duration(seconds: 1, milliseconds: 900),
                  curve: Curves.decelerate);
            });
          } else {
            showTopToast(
                "The profile photo could not be uploaded. Please try again",
                context);
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          showTopToast(
              "You need to upload a profile picture so your friends can find you",
              context);
        }
      } else {
        showTopToast(
            'Your username isn\'t unique. Please choose a different username',
            context);
      }
    } else {
      showTopToast("Please fill in all the required fields", context);
    }
  }

  Future<bool> isUnique(String userName) async {
    bool isUni = true;

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('users');

    DataSnapshot s = await reference.once();

    if (s.value != null) {
      List<dynamic> l = (s.value as Map<dynamic, dynamic>).values.toList();

      for (int i = 0; i < l.length; i++) {
        if (l[i]['username'].toString() == userName) {
          print('gotcha duplicate username');
          isUni = false;
          break;
        }
      }
    }

    return isUni;
  }
}

class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  bool _isCompleted = false;
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isCompleted = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 164.0),
      decoration: BoxDecoration(gradient: SIGNUP_CARD_BACKGROUND),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          //heading
          AnimatedOpacity(
            duration: Duration(milliseconds: 600),
            opacity: _isCompleted ? 1.0 : 0.0,
            child: Container(
              margin: EdgeInsets.only(top: 18.0),
              child: Text(
                'Private information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 22.0,
                  fontFamily: 'Raleway',
                ),
              ),
            ),
          ),

          AnimatedOpacity(
            duration: Duration(milliseconds: 600),
            opacity: _isCompleted ? 1.0 : 0.0,
            child: Container(
              margin: EdgeInsets.only(top: 18.0),
              child: Text(
                'We don\'t share this publicly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 18.0,
                  fontFamily: 'Raleway',
                ),
              ),
            ),
          ),
          DatePicker(),
          GenderPicker(),

          //save button
          Container(
            margin: EdgeInsets.only(top: 32.0),
            child: Center(
              child: InkWell(
                onTap: _savePageThreeInfo,
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
                          stops: [
                            0.2,
                            1
                          ],
                          colors: [
                            Color(0xFF0EDED2),
                            Color(0xFF03A0FE),
                          ])),
                  child: _isLoading
                      ? SpinKitFadingCircle(
                          color: Colors.white,
                        )
                      : Text(
                          'YOU\'RE ALL SET!',
                          style: TextStyle(
                              color: Color(0xffF1EA94),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway'),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _savePageThreeInfo() async {
    setState(() {
      _isLoading = true;
    });

    if (gender != null && birthday != null) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      await FirebaseDatabase.instance
          .reference()
          .child("users_private_info")
          .child(user.uid)
          .set({
        'birthday': '${birthday.day}/${birthday.month}/${birthday.year}',
        'gender': gender
      });

      setState(() {
        _isLoading = false;
        showTopToast('Info saved successfully!', context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => RootPage()));
      });
    } else {
      setState(() {
        _isLoading = false;
        showTopToast('Please fill in appropriate information', context);
      });
    }
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 164.0),
      decoration: BoxDecoration(gradient: SIGNUP_CARD_BACKGROUND),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          //heading
          AnimatedOpacity(
            duration: Duration(milliseconds: 600),
            opacity: 1.0,
            child: Container(
              margin: EdgeInsets.only(top: 18.0),
              child: Text(
                'Welcome to Celfie \n Intro here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 32.0,
                  fontFamily: 'Raleway',
                ),
              ),
            ),
          ),

          //save button
          Container(
              margin: EdgeInsets.only(top: 32.0),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 32.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        //save info
                        pageController.animateToPage(1,
                            duration: Duration(seconds: 1,milliseconds: 900),
                            curve: Curves.elasticIn);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 36.0, vertical: 16.0),
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
                                stops: [
                                  0.2,
                                  1
                                ],
                                colors: [
                                  Color(0xFF0EDED2),
                                  Color(0xFF03A0FE),
                                ])),
                        child: Text(
                          'NEXT',
                          style: TextStyle(
                              color: Color(0xffF1EA94),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway'),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
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

const LinearGradient SIGNUP_CARD_BACKGROUND = LinearGradient(
  tileMode: TileMode.clamp,
  begin: FractionalOffset.centerLeft,
  end: FractionalOffset.centerRight,
  stops: [0.1, 1.0],
  colors: [Colors.greenAccent, Colors.amberAccent],
);

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

DateTime birthday;

class _DatePickerState extends State<DatePicker> {
  DateTime date = DateTime.now();

  Future _selectDate(BuildContext context) async {
    DateTime picker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: new DateTime(1919),
        lastDate: new DateTime.now());

    if (picker != null) {
      setState(() {
        date = picker;
        birthday = picker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        margin: EdgeInsets.only(left: 32.0, right: 16.0, top: 30.0),
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        decoration: BoxDecoration(
            color: Color(0x3305756D),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'DATE OF BIRTH',
              style: TextStyle(letterSpacing: 2.0, fontFamily: 'Raleway'),
            ),
            Text(
              new DateFormat('d MMM y').format(date),
              style: TextStyle(
                  letterSpacing: 2.0,
                  color: Color(0xff353535),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway'),
            )
          ],
        ),
      ),
    );
  }
}

class GenderPicker extends StatefulWidget {
  @override
  _GenderPickerState createState() => _GenderPickerState();
}

var gender;

class _GenderPickerState extends State<GenderPicker> {
  var _selectedGender;

  _selectGender(selectedGender) {
    setState(() {
      _selectedGender = selectedGender;
      gender = selectedGender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 32.0),
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'GENDER',
            style: TextStyle(letterSpacing: 2.0, fontFamily: 'Raleway'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => _selectGender('M'),
                  child: Opacity(
                    opacity: _selectedGender == 'M' ? 1.0 : 0.5,
                    child: Text(
                      'M',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          color: Color(0xff353535),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => _selectGender('F'),
                  child: Opacity(
                    opacity: _selectedGender == 'F' ? 1.0 : 0.5,
                    child: Text(
                      'F',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          color: Color(0xff353535),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => _selectGender('L'),
                  child: Opacity(
                    opacity: _selectedGender == 'L' ? 1.0 : 0.5,
                    child: Text(
                      'L',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          color: Color(0xff353535),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => _selectGender('G'),
                  child: Opacity(
                    opacity: _selectedGender == 'G' ? 1.0 : 0.5,
                    child: Text(
                      'G',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          color: Color(0xff353535),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => _selectGender('B'),
                  child: Opacity(
                    opacity: _selectedGender == 'B' ? 1.0 : 0.5,
                    child: Text(
                      'B',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          color: Color(0xff353535),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => _selectGender('T'),
                  child: Opacity(
                    opacity: _selectedGender == 'T' ? 1.0 : 0.5,
                    child: Text(
                      'T',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          color: Color(0xff353535),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => _selectGender('Q'),
                  child: Opacity(
                    opacity: _selectedGender == 'Q' ? 1.0 : 0.5,
                    child: Text(
                      'Q',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          color: Color(0xff353535),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
