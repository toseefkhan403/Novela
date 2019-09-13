import 'package:arctic_pups/main.dart';
import 'package:arctic_pups/pages/call_page.dart';
import 'package:arctic_pups/pages/image_widget_page.dart';
import 'package:arctic_pups/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewChats extends StatefulWidget {
  final String title;
  final int totalEpisodes, episodeNow;

  ViewChats(this.title, this.episodeNow, this.totalEpisodes);

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
  int episodeNo;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(widget.title,widget.episodeNow,widget.totalEpisodes,episodeNo),
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

                      _key.currentState.insertItem(currentIndex,
                          duration: Duration(milliseconds: 200));
                      Future.delayed(Duration(milliseconds: 350), () {
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeOut);
                      });
                    } else {
                      preferences.setInt(
                          widget.title,
                          widget.totalEpisodes >= episodeNo + 1
                              ? episodeNo + 1
                              : episodeNo);
                      showTopToast('Continue to next episode');
                    }
                  },
                  child: AnimatedList(
                      key: _key,
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
        return Container(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'You received a call from ${data['sent_by']}',
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.call_end),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Call(data)));
                    },
                  )
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
    player = AudioCache(prefix: 'music/');
    player.load('stairs.mp3');
    episodeNo = widget.episodeNow;
    preferences = await SharedPreferences.getInstance();
  }
}
