import 'package:arctic_pups/pages/view_chat_page.dart';
import 'package:arctic_pups/pay_us_money.dart';
import 'package:arctic_pups/utils/size_util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoriesPage extends StatefulWidget {
  @override
  _StoriesPageState createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {

  List storyList;
  bool _isLoading = true;
  SharedPreferences preferences;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          color: Colors.black,
          child: _isLoading ? Center(
            child: SpinKitRipple(color: Colors.white,),
          ) : SingleChildScrollView(child: Column(
            children: <Widget>[

              CarouselSlider(
                viewportFraction: 0.9,
                autoPlay: true,
                height: 300.0,
                items: _widgetList(storyList),
              ),
              SizedBox(
                height: 40.0,
              ),
              _epicTitle(),
              _horizontalList(),
              SizedBox(
                height: 30.0,
              ),
              _epicTitle(),
              _horizontalList(),
              SizedBox(
                height: 30.0,
              ),
              _epicTitle(),
              _horizontalList(),
              SizedBox(
                height: 30.0,
              ),
              _epicTitle(),
              _horizontalList(),
              SizedBox(
                height: 30.0,
              ),
            ],
          ))
        ));
  }

  void _initData() async {
    preferences = await SharedPreferences.getInstance();
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child('stories').once();
    setState(() {
      storyList = (snapshot.value as Map<dynamic, dynamic>).values.toList();
      _isLoading = false;
    });

  }

  Widget _listItem(story) {
    return InkWell(
      onTap: () async {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        DataSnapshot snapshot = await FirebaseDatabase.instance
            .reference()
            .child('user_unlocked_stories')
            .child(user.uid)
            .child(story['title'])
            .once();

        print('the snappppppppp ${snapshot.value}');
        if (snapshot.value == null) {
          //the story is locked
          PayUsMoney.showUnlockDialog(
              context, story['title'], 100, '-all episodes',
              onUnlock: () {});
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ViewChats(
                  story['title'],
                  preferences.getInt(story['title']) == null
                      ? 1
                      : preferences.getInt(story['title']),
                  story['totalEpisodes'], story['image'])));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 250.0,
                      width: 200.0,
                      child: Image.network(
                        story['image'],
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: 200.0,
                    height: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black,
                            Colors.black.withOpacity(0.01),
                          ])),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.9),
                      child: Chip(
                          shape: CircleBorder(
                              side:
                                  BorderSide(color: Colors.black, width: 1.5)),
                          backgroundColor: Colors.white,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 0.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 3.0),
                          label: Text(
                            'E',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 11.0),
                          )),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    right: 10.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            StreamBuilder(
                              stream: FirebaseDatabase.instance.reference().child('stories').child(story['title']).child('views').onValue,
                              builder: (context, snapshot) {
                                return snapshot.hasData ? Text(
                                  '${snapshot.data.snapshot.value} views',
                                  style: TextStyle(
                                      color: Colors.tealAccent[200],
                                      fontSize: 14.0),
                                ) : Container();
                              }
                            ),

                            Chip(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: Colors.white,
                                labelPadding: EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 0.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 3.0),
                                label: Text(
                                  'Episode ${getEpisodeNoFromPrefs(story['title'])} of ${story['totalEpisodes']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 11.0),
                                )),
                            Container(
                              width: 160.0,
                              child: Text(
                                '${story['title']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.0),
                              ),
                            ),
                            Container(
                              width: 160.0,
                              child: Text(
                                '${descriptionStringShort(story['description'])}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _horizontalList() => Container(
        padding: EdgeInsets.all(12.0),
        height: 280.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: storyList.length,
            itemBuilder: (context, index) => _listItem(storyList[index])),
      );

  _epicTitle() => Padding(
        padding: const EdgeInsets.only(left: 22.0),
        child: Text('Mystery'),
      );

  int getEpisodeNoFromPrefs(String title) => preferences.getInt(title) == null
      ? 1
      : preferences.getInt(title);

  List<Widget> _widgetList(List storyList) {

    List<Widget> items = List();
    for(int i = 0; i< storyList.length ; i++){
      items.add(wid(storyList[i]));
    }
    return items;
  }

  Widget wid(story) => InkWell(
    onTap: () async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      DataSnapshot snapshot = await FirebaseDatabase.instance
          .reference()
          .child('user_unlocked_stories')
          .child(user.uid)
          .child(story['title'])
          .once();

      print('the snappppppppp ${snapshot.value}');
      if (snapshot.value == null) {
        //the story is locked
        PayUsMoney.showUnlockDialog(
            context, story['title'], 100, '-all episodes',
            onUnlock: () {});
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewChats(
                story['title'],
                preferences.getInt(story['title']) == null
                    ? 1
                    : preferences.getInt(story['title']),
                story['totalEpisodes'],story['image'])));
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                    height: 300.0,
                    width: SizeUtil.width,
                    child: Image.network(
                      story['image'],
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  width: SizeUtil.width,
                  height: 60.0,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0.01),
                            ])),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.9),
                    child: Chip(
                        shape: CircleBorder(
                            side:
                            BorderSide(color: Colors.black, width: 1.5)),
                        backgroundColor: Colors.white,
                        labelPadding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 3.0),
                        label: Text(
                          'E',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 11.0),
                        )),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  bottom: 10.0,
                  right: 10.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder(
                              stream: FirebaseDatabase.instance.reference().child('stories').child(story['title']).child('views').onValue,
                              builder: (context, snapshot) {
                                return snapshot.hasData ? Text(
                                  '${snapshot.data.snapshot.value} views',
                                  style: TextStyle(
                                      color: Colors.tealAccent[200],
                                      fontSize: 14.0),
                                ) : Container();
                              }
                          ),
                          Chip(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: Colors.white,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 0.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 3.0),
                              label: Text(
                                'Episode ${getEpisodeNoFromPrefs(story['title'])} of ${story['totalEpisodes']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 11.0),
                              )),
                          Container(
                            width: 200,
                            child: Text(
                              '${story['title']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18.0),
                            ),
                          ), Container(
                            width: SizeUtil.width - 96.0,
                            child: Text(
                              '${descriptionStringLong(story['description'])}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );

  descriptionStringShort(String description) => description.length > 22 ? description.substring(0,22) + '...' : description;
  descriptionStringLong(String description) => description.length > 46 ? description.substring(0,46) + '...' : description;
}
