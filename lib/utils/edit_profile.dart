import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arctic_pups/pages/login_page.dart';
import 'package:arctic_pups/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';

String photoUrl, username, email, display_name, bio;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController;
  TextEditingController userNameController;
  TextEditingController bioController;
  bool _isLoading = false;
  File _image;

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
              'uid' : user.uid,
              'photoUrl': imageURL
            });

            setState(() {
              _isLoading = false;
              showTopToast('Info saved successfully!', context);

              //todo navigate to the profile
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
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
          setState(() {
            _isLoading = true;
          });

          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          DatabaseReference dbRef = FirebaseDatabase.instance
              .reference()
              .child('users')
              .child(user.uid);

          await dbRef.set({
            'username': userName,
            'display_name': displayName,
            'bio': bio,
            'uid' : user.uid,
            'photoUrl': photoUrl
          });

          setState(() {
            _isLoading = false;
            showTopToast('Info saved successfully!', context);

            //todo navigate to the profile
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          });
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

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    DataSnapshot s = await reference.once();

    if (s.value != null) {
      List<dynamic> l = (s.value as Map<dynamic, dynamic>).values.toList();

      for (int i = 0; i < l.length; i++) {
        if (l[i]['username'].toString() == userName) {
          if (l[i]['uid'].toString() != user.uid) {
            print('gotcha duplicate username');
            isUni = false;
            break;
          }
        }
      }
    }

    return isUni;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  bool _isCompleted = false;

  @override
  void initState() {
    displayNameController = TextEditingController();
    userNameController = TextEditingController();
    bioController = TextEditingController();

    displayNameController.value = TextEditingValue(text: '$display_name');
    userNameController.value = TextEditingValue(text: '$username');
    bioController.value = TextEditingValue(text: '$bio');

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isCompleted = true;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        colors: aquaGradients,
      )),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          elevation: 14.0,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: Color(0x802196F3),
          child: Center(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Material(
                          color: Colors.amber,
                          shape: CircleBorder(),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.arrow_back,
                                  color: Colors.white, size: 25.0),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0, left: 30.0),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 600),
                        opacity: _isCompleted ? 1.0 : 0.0,
                        child: Container(
                          margin: EdgeInsets.only(top: 18.0),
                          child: Text(
                            'Edit your Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: 3,
                              fontSize: 22.0,
                              fontFamily: 'Raleway',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //image picker
                Center(
                  child: InkWell(
                    onTap: getImage,
                    child: Column(
                      children: <Widget>[
                        ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: SizedBox(
                                width: 126,
                                height: 126,
                                child: _image == null
                                    ? Image.network(
                                        '$photoUrl',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                        ),
                        Text('Change your profile picture',
                            style: TextStyle(
                                fontFamily: 'Oxygen', color: Colors.green)),
                      ],
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
          ),
        ),
      ),
    );
  }
}

class SettingsList extends StatefulWidget {
  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontFamily: 'Pacifico'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _isLoading
              ? Container(
                  height: 160.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: aquaGradients,
                  )),
                  child: Center(child: CircularProgressIndicator()),
                )
              : UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: aquaGradients,
                  )),
                  accountName: Text(
                    '$username',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                  accountEmail: Text(
                    '$email',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                  currentAccountPicture: GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('$photoUrl'),
                    ),
                  ),
                ),

          //body
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EditProfile()));
            },
            child: ListTile(
              title: Text('Edit your profile'),
              leading: Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
            ),
          ),

          Divider(),

          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Report a problem'),
              leading: Icon(
                Icons.report,
                color: Colors.red,
              ),
            ),
          ),

          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('About'),
              leading: Icon(
                Icons.help,
                color: Colors.blue,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => RootPage()));
            },
            child: ListTile(
              title: Text('Logout'),
              leading: Icon(
                Icons.exit_to_app,
                color: kShrineBrown900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _updateName();
  }

  void _updateName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(user.uid)
        .once();

    DataSnapshot emailSnap = await FirebaseDatabase.instance
        .reference()
        .child("user_account_settings")
        .child(user.uid)
        .once();

    setState(() {
      photoUrl = snapshot.value['photoUrl'];
      username = snapshot.value['username'];
      email = emailSnap.value['email'];
      bio = snapshot.value['bio'];
      display_name = snapshot.value['display_name'];
      _isLoading = false;
    });
  }
}
