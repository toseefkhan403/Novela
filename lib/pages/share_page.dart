import 'dart:io';
import 'package:arctic_pups/ChatMessages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

List<dynamic> storyList, chatList;


class SharePage extends StatefulWidget {
  final String challengeKey, fromUid;

  SharePage({this.challengeKey, this.fromUid});

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  TextEditingController disController;
  File image;

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
      floatingActionButton: FloatingActionButton(tooltip: 'add a new story', child: Icon(Icons.add_comment), onPressed: (){
        addTheMessagesToTheDb();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewStory()));
      },),
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder(
          stream:
              FirebaseDatabase.instance.reference().child('stories').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data.snapshot.value);

              storyList =
                  (snapshot.data.snapshot.value as Map<dynamic, dynamic>)
                      .values
                      .toList();
              print('this is storylist $storyList');

              return ListView.builder(
                  shrinkWrap: false,
                  itemCount: storyList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(storyList[index]['title']),
                      leading: Image.network(storyList[index]['image']),
                      contentPadding: EdgeInsets.all(8.0),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditChats(storyList[index]['title'])));
                      },
                    );
                  });
            } else {
              return Container();
            }
          }),
    );
  }
}

class EditChats extends StatefulWidget {
  final String title;

  EditChats(this.title);

  @override
  _EditChatsState createState() => _EditChatsState();
}

class _EditChatsState extends State<EditChats>
    with AutomaticKeepAliveClientMixin {
  TextEditingController msgController = TextEditingController();
  TextEditingController sentController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  int episode = 1;

  @override
  void initState() {
    sentController.text = 'toseef';
    typeController.text = 'text';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: openWriteArea,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('increase the episode by 1'),
              onTap: (){
                setState(() {
                  episode++;
                });
              },
            ),
            ListTile(
              title: Text('decrease the episode by 1'),
              onTap: (){
                setState(() {
                  episode--;
                });
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('${widget.title.toString()} #$episode')),
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child('episodes')
              .child(widget.title)
              .child('episode$episode')
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('this is the data yo ${snapshot.data.snapshot.value}');
              chatList = (snapshot.data.snapshot.value as Map<dynamic, dynamic>)
                  .values
                  .toList();

              chatList.sort((a, b) {
                return a['timestamp'].compareTo(b['timestamp']);
              });

              print('the chatlist $chatList');
              return ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) =>
                      _makeMessages(context, chatList[index]));
            } else {
              return Container();
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _makeMessages(BuildContext context, data) {
    print('the data $data');
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(data['sent_by']),

            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(data['content']),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addToDb() async {
    String content = msgController.value.text;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String sent_by = sentController.value.text;
    String type = typeController.value.text;

    if (content != null) {
      await FirebaseDatabase.instance
          .reference()
          .child('episodes')
          .child(widget.title)
          .child('episode$episode')
          .child(timestamp.toString())
          .set({
        'content': content,
        'sent_by': sent_by,
        'type': type,
        'timestamp': timestamp
      });

      msgController.clear();
      Navigator.pop(context);
    }
  }


  void _addImageToDb() async {

    File galleryImage = await FilePicker.getFile(type: FileType.ANY);

    if (galleryImage != null) {

      int timestamp = DateTime
          .now()
          .millisecondsSinceEpoch;
      String sent_by = sentController.value.text;
      String type = typeController.value.text;

      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('novella_photos')
          .child('$timestamp');

      StorageUploadTask uploadTask = ref.putFile(galleryImage);
      String imageURL =
      await (await uploadTask.onComplete).ref.getDownloadURL();

      //content is image url
      if (imageURL != null) {
        String content = imageURL;

        await FirebaseDatabase.instance
            .reference()
            .child('episodes')
            .child(widget.title)
            .child('episode$episode')
            .child(timestamp.toString())
            .set({
          'content': content,
          'sent_by': sent_by,
          'type': type,
          'timestamp': timestamp
        });

        msgController.clear();
        Navigator.pop(context);
      }
    }

  }

  void openWriteArea() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Material(
            color: Colors.blueGrey,
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
                    'Write the message',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20.0, fontFamily: 'Pacifico'),
                  ),
                ),
                TextField(
                  controller: msgController,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton(
                    onPressed: _addToDb,
                    child: Icon(Icons.skip_next),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton(
                    onPressed: _addImageToDb,
                    child: Icon(Icons.image),
                  ),
                ),


                TextField(
                  controller: sentController,
                ),
                TextField(
                  controller: typeController,
                ),
              ],
            ),
          ),
    );
  }
}

class NewStory extends StatefulWidget {
  @override
  _NewStoryState createState() => _NewStoryState();
}

class _NewStoryState extends State<NewStory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
