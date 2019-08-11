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
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            stops: [0.2, 1],
            colors: aquaGradients),
      ),
      child: Container(
        margin: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 2.5),
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              stops: [0.2, 1],
              colors: aquaGradients),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                'Post to Celfie',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 40.0, fontFamily: 'Pacifico'),
              ),
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: <Widget>[
                        ClipOval(
                          child: Material(
                            color: Colors.blue,
                            child: InkWell(
                              splashColor: Colors.red,
                              child: SizedBox(
                                width: 76,
                                height: 76,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 40.0,
                                ),
                              ),
                              onTap: () async {
                                var image = await ImagePicker.pickImage(
                                    source: ImageSource.camera);

                                if (image != null) {
                                  File croppedFile =
                                  await ImageCropper.cropImage(
                                    sourcePath: image.path,
                                  );

                                  //go to the post screen with the image
                                  if (croppedFile != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostStuff(image: croppedFile)));
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Text(
                          'Camera',
                          style:
                              TextStyle(fontSize: 20.0, fontFamily: 'Pacifico'),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ClipOval(
                          child: Material(
                            color: Colors.blue,
                            child: InkWell(
                              splashColor: Colors.red,
                              child: SizedBox(
                                width: 76,
                                height: 76,
                                child: Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                  size: 40.0,
                                ),
                              ),
                              onTap: () async {
                                var image = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);

                                if (image != null) {
                                  File croppedFile =
                                      await ImageCropper.cropImage(
                                    sourcePath: image.path,
                                  );

                                  //go to the post screen with the image
                                  if (croppedFile != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostStuff(image: croppedFile)));
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Text(
                          'Gallery',
                          style:
                              TextStyle(fontSize: 20.0, fontFamily: 'Pacifico'),
                        )
                      ],
                    ),
                  ),
                ])
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _loadList();
    super.initState();
  }
}

class PostStuff extends StatefulWidget {
  PostStuff({this.image});

  final File image;

  @override
  _PostStuffState createState() => _PostStuffState();
}

class _PostStuffState extends State<PostStuff> {
  TextEditingController disController;
  bool _isLoading = false;

  @override
  void initState() {
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
              colors: aquaGradients),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Post an Image",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 26.0, fontFamily: 'Pacifico'),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
              height: 25.0,
            ),
            Container(
              child: Image.file(
                widget.image,
                fit: BoxFit.cover,
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

            Padding(
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
                                fontSize: 20.0, fontFamily: 'Raleway'),
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
            ),

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

            Container(
              margin: EdgeInsets.only(top: 32.0),
              child: Center(
                child: InkWell(
                  onTap: _uploadThePhoto,
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
                            'Upload',
                            style: TextStyle(
                                color: Colors.white,
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
            color: Colors.white,
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

    if (selectedPerson != null) {
      String dis = disController.value.text;

      setState(() {
        _isLoading = true;
      });

      String n = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      String t = 'photo$n';
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      StorageReference ref =
      FirebaseStorage.instance.ref().child('photos').child(user.uid).child(t);
      StorageUploadTask uploadTask = ref.putFile(widget.image);
      String imageURL = await (await uploadTask.onComplete).ref
          .getDownloadURL();

      if (imageURL.isNotEmpty) {
        String key = FirebaseDatabase.instance
            .reference()
            .child('challenges')
            .push().key;

        print('THE CHALLENGE KEY $key');

        DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('challenges').child(key);

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
            .child(user.uid)
        .child(key)
            .set({'to': selectedPerson['uid'], 'key': key});

        await FirebaseDatabase.instance
            .reference()
            .child('user_challenges')
            .child(selectedPerson['uid'])
        .child(key)
            .set({'from': user.uid, 'key': key});

        setState(() {
          _isLoading = false;
          showTopToast('Celfie uploaded successfully!', context);

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (c) => HomeScreen()));
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
