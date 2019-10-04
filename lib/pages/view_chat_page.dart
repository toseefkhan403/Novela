import 'package:arctic_pups/main.dart';
import 'package:arctic_pups/pages/call_page.dart';
import 'package:arctic_pups/pages/image_widget_page.dart';
import 'package:arctic_pups/services.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:arctic_pups/utils/custom_app_bar.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewChats extends StatefulWidget {
  final String title, storyImage;
  final int totalEpisodes, episodeNow;

  ViewChats(this.title, this.episodeNow, this.totalEpisodes, this.storyImage);

  @override
  _ViewChatsState createState() => _ViewChatsState();
}

class _ViewChatsState extends State<ViewChats> {
  List chatList;
  SharedPreferences preferences;
  ScrollController scrollController = ScrollController();
  final _key = GlobalKey<AnimatedListState>();
  AudioCache player;

  int currentIndex = 0;
  int callCount;
  int episodeNo;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(widget.title,widget.totalEpisodes,episodeNo, widget.storyImage),
      body: Container(
        color: Colors.black,
        child: StreamBuilder(
            stream: FirebaseDatabase.instance
                .reference()
                .child('episodes')
                .child(widget.title)
                .child('episode$episodeNo')
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                chatList = (snapshot.data.snapshot.value as Map<dynamic, dynamic>)
                    .values
                    .toList();
                chatList.sort((a, b) {
                  return a['timestamp'].compareTo(b['timestamp']);
                });

                preferences.setInt(widget.title, episodeNo);

                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    //item is inserted here
                    if (currentIndex < chatList.length - 1) {

                      player.play('stairs.mp3');

                      ++currentIndex;

                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeOut);

                      Future.delayed(Duration(milliseconds: 350), () {
                        _key.currentState.insertItem(currentIndex,
                            duration: Duration(milliseconds: 200));
                      });
                    } else {
                      preferences.setInt(
                          widget.title,
                          widget.totalEpisodes >= episodeNo + 1
                              ? episodeNo + 1
                              : episodeNo);

                      if (episodeNo < widget.totalEpisodes) {
                        _continueToNext(context);
                      }else {
                        showTopToast('This story has come to an end.');
                      }
                    }
                  },
                  child: AnimatedList(
                      key: _key,
                      padding: EdgeInsets.only(bottom: 300.0),
                      initialItemCount: 1,
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index, animation) =>
                          _makeMessages(context, chatList[index], animation)),
                );
              } else {
                return Center(
                    child: SpinKitRipple(
                      color: Colors.white,
                    ));
              }
            }),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  _makeMessages(BuildContext context, data, Animation animation) {
    //scale or size
    return ScaleTransition(
        scale: animation,
        alignment: Alignment.centerLeft,
        child: _whatWidget(context, data));
  }

  Widget _whatWidget(BuildContext context, data) {
    bool isRight = data['sent_by'].toString().contains('1');

    switch (data['type']) {
      case 'text':
        return Container(
          margin: isRight ? EdgeInsets.only(left: 50.0) : EdgeInsets.only(right: 50.0),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment:
                    isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment:
                    isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(isRight
                        ? data['sent_by']
                            .toString()
                            .replaceAll('1', " ")
                            .toString()
                        : data['sent_by']),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        data['content'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ],
              )),
        );

      case 'msg':
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data['content'],
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );

      case 'call':

        WidgetsBinding.instance.addPostFrameCallback((_){

          print('Post frame callback');
          if (callCount == 0) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Call(data)));
            ++callCount;
          }
        });

        return Container(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'You received a call from ${data['sent_by']}',
                        style: TextStyle(
                            color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),

                      IconButton(
                        padding: EdgeInsets.only(left: 8.0),
                        icon: Icon(Icons.call, color: Colors.blueGrey,),
                        onPressed: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Call(data)));
                        },
                      )
                    ],
                  ),
                ],
              )),
        );

      case 'image':
        return ImageStatefulWidget(isRight, data);

      default:
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment:
                  isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment:
                  isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(isRight
                    ? data['sent_by'].toString().replaceAll('1', " ").toString()
                    : data['sent_by']),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(data['content']),
                  ),
                )
              ],
            ),
          ),
        );
    }
  }

  void init() async {

    callCount = 0; // One episode can contain only one call
    player = AudioCache(prefix: 'music/');
    player.load('stairs.mp3');
    episodeNo = widget.episodeNow;
    preferences = await SharedPreferences.getInstance();
    //increase the view count
    DataSnapshot s = await FirebaseDatabase.instance.reference().child('stories').child(widget.title).child('views').once();
    int views = s.value;
    FirebaseDatabase.instance.reference().child('stories').child(widget.title).child('views').set(++views);
  }

  void _continueToNext(BuildContext context) {
    showBottomSheet(
        context: (context), builder: (context) =>
        Material(
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Continue to next episode',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0,
                      color: Colors.black,
                      fontFamily: 'Pacifico'),
                ),
              ),

              InkWell(
                onTap: () {
                  showTopToast('Please wait...');
                  String link = " ";
                  Share.text('Novella',
                      'Hey! I am reading this amazing text story called \'${widget
                          .title}\' and I think you\'d like it too! \nHere\'s the link to download the app: $link',
                      'text/plain');
                },
                child: Chip(backgroundColor: kShrinePink500,
                    labelPadding: EdgeInsets.all(4.0),
                    avatar: Icon(
                      Icons.share, color: Colors.white,),
                    label: Text('Share', style: TextStyle(
                        fontWeight: FontWeight.w700),)),
              ),


              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        30.0),
                    child: Container(
                      width: 340,
                      height: 270,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.storyImage),
                            fit: BoxFit.cover
                        ),
                      ),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 75.0, bottom: 12.0),
                              width: 200,
                              child: Text(
                                widget.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.0),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              width: 200,
                              child: Text(
                                'Episode ${episodeNo + 1}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0),
                              ),
                            ),

                            //button here
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewChats(widget.title,
                                                widget.episodeNow +
                                                    1, widget
                                                    .totalEpisodes,
                                                widget.storyImage)
                                    ));
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
                                        stops: [
                                          0.2,
                                          1
                                        ], colors: [
                                          Color(0xffFFC3A0),
                                          Color(0xffFFAFBD),
                                        ])),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Raleway'),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )


            ],
          ),
        ));
    showTopToast('Continue to next episode');
  }
}
