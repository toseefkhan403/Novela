import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:arctic_pups/pages/login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:arctic_pups/main.dart';

var selectedPerson;
List<dynamic> friendList;

void _loadList() async {
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child('users');
  DataSnapshot s = await reference.once();

  friendList = (s.value as Map<dynamic, dynamic>).values.toList();
}

class SharePage extends StatefulWidget {
  final String challengeKey, fromUid;

  SharePage({this.challengeKey, this.fromUid});

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  TextEditingController disController;
  bool _isLoading = false;
  File image;

  @override
  void initState() {
    _loadList();
    disController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    disController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              stops: [0.2, 1],
              colors: Theme.of(context).brightness == Brightness.light
                  ? aquaGradients
                  : [
                      Colors.black,
                      Colors.black87,
                    ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Post to Celfie",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 24.0, fontFamily: 'Pacifico'),
              ),
            ),
            SizedBox(
              width: 10.0,
              height: 25.0,
            ),
            Container(
              child: InkWell(
                onTap: () async {
                  var galleryImage = await ImagePicker.pickImage(
                      source: ImageSource.gallery);

                  if (galleryImage != null) {
                    File croppedFile =
                    await ImageCropper.cropImage(
                      sourcePath: galleryImage.path,
                    );

                    if (croppedFile != null) {
                      setState(() {
                        image = croppedFile;
                      });
                    }
                  }
                },
                child: image == null ? Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff434343),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0.0, 10.0)),
                      ],
                      borderRadius: new BorderRadius.circular(26.0),
                      gradient:
                      LinearGradient(begin: FractionalOffset.centerLeft,
                          stops: [
                            0.2,
                            1
                          ], colors: [
                            Color(0xff000000),
                            Color(0xff434343),
                          ])
                ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_photo_alternate),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Choose an Image'),
                        ),
                      ],
                    ),
                  ),
                )
          : Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              width: 300.0,
              height: 300.0,
            ),

            SizedBox(
              width: 10.0,
              height: 25.0,
            ),

            //description
            Container(
              margin: EdgeInsets.only(left: 16.0, right: 32.0, bottom: 16.0),
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
                controller: disController,
                decoration: new InputDecoration(
                    contentPadding:
                        new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: BorderSide.none),
                    hintText: 'An interesting caption',
                    hintStyle: hintAndValueStyle),
              ),
            ),

            widget.challengeKey == null || widget.fromUid == null
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () {
                        _clickMenu(context);
                      },
                      splashColor: Colors.red,
                      child: selectedPerson == null
                          ? Row(
                              children: <Widget>[
                                Icon(Icons.tag_faces),
                                SizedBox(
                                  width: 10.0,
                                  height: 0.0,
                                ),
                                Text(
                                  "Choose your friends to challenge",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18.5, fontFamily: 'Raleway'),
                                ),
                              ],
                            )
                          : ListTile(
                              trailing: Icon(Icons.keyboard_arrow_down),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(selectedPerson['photoUrl']),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    selectedPerson['username'],
                                    style: TextStyle(fontFamily: 'Raleway'),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  )
                : StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .reference()
                        .child('users')
                        .child(widget.fromUid)
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 15.0),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data.snapshot.value['photoUrl']),
                          ),
                          title: Text(
                            'You are replying to ' +
                                snapshot.data.snapshot.value['username'] +
                                '\'s challenge',
                            style: TextStyle(fontFamily: 'Raleway'),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),

            /*       Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.red,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.stars),
                    SizedBox(
                      width: 10.0,
                      height: 0.0,
                    ),
                    Text(
                      "Choose the communities",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20.0, fontFamily: 'Raleway'),
                    ),
                  ],
                ),
              ),
            ),
*/
            image == null ? Container() : Container(
              margin: EdgeInsets.only(top: 32.0),
              child: Center(
                child: _isLoading ? SpinKitChasingDots(color: Colors.white) : InkWell(
                  onTap: _uploadThePhoto,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
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
                      border: Border.all(color: Colors.black87, width: 1.0)
                        ),
                    child: Text(
                            'Upload',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway'),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _serveName(p) {
    setState(() {
      //update the name
      selectedPerson = p;
    });
  }

  void _clickMenu(context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Material(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Select your friends',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20.0, fontFamily: 'Pacifico'),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: _menuList(),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _menuList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _menuItem(context, friendList[index]);
      },
      itemCount: friendList.length,
    );
  }

  Widget _menuItem(BuildContext context, person) {
    bool isSelected = false;

    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).pop();
          isSelected = !isSelected;
          selectedPerson = person;
          _serveName(person);
        });
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(person['photoUrl']),
          /*child: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Image.network(
                    person['photoUrl'],
                    fit: BoxFit.fill,
                  ),
            backgroundColor: (isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent)*/
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              person['username'],
              style: TextStyle(fontFamily: 'Raleway'),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadThePhoto() async {
    if (widget.challengeKey != null || widget.fromUid != null) {
      //replying to a challenge
      String dis = disController.value.text;

      setState(() {
        _isLoading = true;
      });

      String n = DateTime.now().millisecondsSinceEpoch.toString();
      String t = 'photo$n';
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('photos')
          .child(user.uid)
          .child(t);
      StorageUploadTask uploadTask = ref.putFile(image);
      String imageURL =
          await (await uploadTask.onComplete).ref.getDownloadURL();

      if (imageURL.isNotEmpty) {
        String key =
            FirebaseDatabase.instance.reference().child('posts').push().key;

        print('THE Post KEY $key');

        DataSnapshot d = await FirebaseDatabase.instance
            .reference()
            .child('challenges')
            .child(widget.challengeKey)
            .once();

        DatabaseReference dbRef =
            FirebaseDatabase.instance.reference().child('posts').child(key);

        //set the post details here...
        await dbRef.set({
          'caption1': dis,
          'caption2': d.value['caption'],
          'postKey': key,
          'challengeKey': widget.challengeKey,
          'challengerUid': d.value['challengerUid'], //is user 2
          'challengedUid': user.uid, //is user 1
          'photoUrl1': imageURL,
          'photoUrl2': d.value['photoUrl'],
          'status': 'NOT_DECIDED',
          'timestamp': n,
        });

        //setting to user post node
        await FirebaseDatabase.instance
            .reference()
            .child('user_posts')
            .child(d.value['challengerUid'])
            .child(key)
            .set(key);

        //setting to user post node
        await FirebaseDatabase.instance
            .reference()
            .child('user_posts')
            .child(d.value['challengedUid'])
            .child(key)
            .set(key);

        await FirebaseDatabase.instance
            .reference()
            .child('user_challenges')
            .child(user.uid)
            .child(widget.challengeKey)
            .remove();

        await FirebaseDatabase.instance
            .reference()
            .child('challenges')
            .child(widget.challengeKey)
            .child('status')
            .set('ACCEPTED');

        setState(() {
          _isLoading = false;
          showTopToast('Post uploaded successfully!', context);

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (c) => HomeScreen()));
        });
      }
    } else {
      if (selectedPerson != null) {
        String dis = disController.value.text;

        setState(() {
          _isLoading = true;
        });

        String n = DateTime.now().millisecondsSinceEpoch.toString();
        String t = 'photo$n';
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        StorageReference ref = FirebaseStorage.instance
            .ref()
            .child('photos')
            .child(user.uid)
            .child(t);
        StorageUploadTask uploadTask = ref.putFile(image);
        String imageURL =
            await (await uploadTask.onComplete).ref.getDownloadURL();

        if (imageURL.isNotEmpty) {
          String key = FirebaseDatabase.instance
              .reference()
              .child('challenges')
              .push()
              .key;

          print('THE CHALLENGE KEY $key');

          DatabaseReference dbRef = FirebaseDatabase.instance
              .reference()
              .child('challenges')
              .child(key);

          await dbRef.set({
            'caption': dis,
            'challengeKey': key,
            'challengerUid': user.uid,
            'challengedUid': selectedPerson['uid'],
            'photoUrl': imageURL,
            'status': 'NOT_DECIDED'
          });

          await FirebaseDatabase.instance
              .reference()
              .child('user_challenges')
              .child(selectedPerson['uid'])
              .child(key)
              .set({
            'from': user.uid,
            'key': key,
            'photoUrl': imageURL,
            'type': 'challenge'
          });

          setState(() {
            _isLoading = false;
            showTopToast('Celfie uploaded successfully!', context);

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (c) => HomeScreen()));
          });
        } else {
          showTopToast(
              "Your celfie could not be uploaded. Please try again", context);
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        showTopToast('Please select a friend', context);
      }
    }
  }
}
