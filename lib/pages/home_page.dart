import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/size_util.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:arctic_pups/pages/login_page.dart';
import 'package:arctic_pups/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:arctic_pups/pages/view_profile_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:arctic_pups/pages/profile_page.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';

//this page should get the posts from db and display them
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

List<dynamic> postsList = List();

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black87,
                  tabs: [
                    Tab(text: 'Trending'),
                    Tab(text: 'Local'),
                    Tab(text: 'Subscriptions'),
                  ]),
            ),
          ),
        ),
        body: TabBarView(children: [
          TrendingPage(),
          TrendingPage(),
          TrendingPage(),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _gatherData();
    super.initState();
  }

  void _gatherData() async {
    DataSnapshot s =
        await FirebaseDatabase.instance.reference().child('posts').once();

    try {
      setState(() {
        postsList = (s.value as Map<dynamic, dynamic>).values.toList();
        _isLoading = false;
      });
    } catch (e) {}
  }
}

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage>
    with AutomaticKeepAliveClientMixin<TrendingPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return postsList == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: postsList.length,
            itemBuilder: (context, index) =>
                _buildPosts(context, postsList[index]));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildPosts(BuildContext context, post) {

    return Container(
      color: Colors.black,
      height: 600,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 530,
                width: SizeUtil.width,
                child: Image.network(
                  post['photoUrl1'],
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: <Widget>[
                  //user name and profile
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _userDetails(post),
                  ),
                  //caption
                  Text(
                    post['caption1'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),

                  //who has joined
                  Padding(
                    padding: const EdgeInsets.only(top: 358.0, left: 10.0),
                    child: _userFriendDetails(post),
                  ),
                ],
              )
            ],
          ),

          //below the image, no of views and total likes and share button
          Row(
            children: <Widget>[
              //eye icon
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.remove_red_eye),
              ),
              Text(post['likesCount1'] == null
                  ? '0'
                  : '${post['likesCount1'] + 88}'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.favorite_border),
              ),
              Text(
                  post['likesCount1'] == null ? '0' : '${post['likesCount1']}'),
              Spacer(),
              Icon(Icons.share),

              InkWell(
                onTap: () async {
                  try {
                    Share.text('Share Celfie', 'Check out the new Celfie app!',
                        'text/plain');
                  } catch (e) {
                    print(e);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Share'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _userDetails(post) {
    return Container(
      height: 60,
      child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child('users')
              .child(post['challengedUid'])
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2.0, color: Colors.orange)),
                    child: InkWell(
                      onTap: () async {
                        FirebaseUser user = await FirebaseAuth
                            .instance
                            .currentUser();
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (c) => user.uid ==
                                    post['challengedUid']
                                    ? ProfilePage()
                                    : ViewProfilePage(post[
                                'challengedUid'])));
                      },
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data.snapshot.value['photoUrl']),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data.snapshot.value['username'],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        //show dialog
                        showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                                  title: Text(
                                    'Actions...',
                                    style: TextStyle(fontFamily: 'Pacifico'),
                                    textAlign: TextAlign.center,
                                  ),
                                  contentPadding: EdgeInsets.all(18.0),
                                  children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot
                                            .data.snapshot.value['photoUrl']),
                                      ),
                                      title: Text(
                                        'Visit ${snapshot.data.snapshot.value['username']}\'s profile',
                                        style: TextStyle(fontFamily: 'Raleway'),
                                      ),
                                      onTap: () async {
                                        FirebaseUser user = await FirebaseAuth
                                            .instance
                                            .currentUser();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (c) => user.uid ==
                                                        post['challengedUid']
                                                    ? ProfilePage()
                                                    : ViewProfilePage(post[
                                                        'challengedUid'])));
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.share),
                                      title: Text(
                                        'Share this post',
                                        style: TextStyle(fontFamily: 'Raleway'),
                                      ),
                                      onTap: () async {
                                        try {
                                          Share.text(
                                              'Share Celfie',
                                              'Check out the new Celfie app!',
                                              'text/plain');
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.report,
                                        color: Colors.red,
                                      ),
                                      title: Text(
                                        'Report this post',
                                        style: TextStyle(fontFamily: 'Raleway'),
                                      ),
                                      onTap: () {},
                                    ),
                                  ],
                                ));
                      },
                      child: Icon(Icons.keyboard_arrow_up)),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  _userFriendDetails(post) {
    return Container(
      height: 60,
      child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child('users')
              .child(post['challengerUid'])
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      FirebaseUser user = await FirebaseAuth
                          .instance
                          .currentUser();
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (c) => user.uid ==
                                  post['challengerUid']
                                  ? ProfilePage()
                                  : ViewProfilePage(post[
                              'challengerUid'])));
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data.snapshot.value['photoUrl']),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${snapshot.data.snapshot.value['username']} has joined this Celfie!',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

class BuildPost extends StatefulWidget {
  final String user, caption, photoUrl, postKey;
  final DateTime date;
  final bool active;
  final int userNo, likesCount;

  BuildPost(this.userNo, this.user, this.date, this.photoUrl, this.caption,
      this.active, this.likesCount, this.postKey);

  @override
  _BuildPostState createState() => _BuildPostState();
}

class _BuildPostState extends State<BuildPost> {
  bool likedByCurrentUser = false;
  int likesCount;
  final FlareControls flareControls = FlareControls();

  @override
  void initState() {
    likesCount = widget.likesCount == null
        ? likesCount = 0
        : likesCount = widget.likesCount;
    likesCount <= 0 ? likesCount = 0 : likesCount = likesCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double blur = widget.active ? 30 : 0;
    final double offset = widget.active ? 20 : 0;
    final double top = widget.active ? 40 : 80;

    return Stack(
      children: <Widget>[
        InkWell(
          onDoubleTap: _insertLikes,
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 450),
                curve: Curves.easeOutQuint,
                margin: EdgeInsets.only(top: top, bottom: 100, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.photoUrl),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black87,
                          blurRadius: blur,
                          offset: Offset(offset, offset))
                    ]),
              ),
              Container(
                width: double.infinity,
                height: 620,
                child: Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: FlareActor(
                      'assets/images/instagram_like.flr',
                      controller: flareControls,
                      animation: 'idle',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // bottom widget
        Positioned(
          bottom: 20.1,
          left: SizeUtil.getAxisX(86.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SizeUtil.getAxisBoth(22.0),
              ),
              gradient: LinearGradient(colors: [RED_LIGHT, RED]),
            ),
            height: SizeUtil.getAxisY(162.0),
            width: SizeUtil.getAxisY(492.0),
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('users')
                    .child(widget.user)
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                          top: SizeUtil.getAxisY(20.0),
                          left: SizeUtil.getAxisX(67.0),
                          child: _textBack(
                              snapshot.data.snapshot.value['username'],
                              size: TEXT_SMALL_3_SIZE,
                              isBold: true),
                        ),
                        Positioned(
                          top: SizeUtil.getAxisY(54.0),
                          left: SizeUtil.getAxisX(69.0),
                          child: _textBack(widget.caption,
                              size: TEXT_SMALL_3_SIZE),
                        ),
                        Positioned(
                          top: SizeUtil.getAxisY(20.0),
                          right: SizeUtil.getAxisX(30.0),
                          child: _textBack('${widget.date.day} ' +
                              convertToMonth(widget.date.month)),
                        ),
                        Positioned(
                          bottom: SizeUtil.getAxisY(30.0),
                          left: SizeUtil.getAxisX(90.0),
                          child: Container(
                            alignment: AlignmentDirectional.centerStart,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: _insertLikes,
                                  child: likedByCurrentUser
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: SizeUtil.getAxisBoth(30.0),
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                          color: TEXT_BLACK,
                                          size: SizeUtil.getAxisBoth(30.0),
                                        ),
                                ),
                                SizedBox(
                                  width: SizeUtil.getAxisX(16.0),
                                ),
                                _textBack(likesCount.toString()),
                                SizedBox(
                                  width: SizeUtil.getAxisX(45.0),
                                ),
                                InkWell(
                                  onTap: () {
                                    //show dialog
                                    showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                              title: Text(
                                                'Actions...',
                                                style: TextStyle(
                                                    fontFamily: 'Pacifico'),
                                                textAlign: TextAlign.center,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(18.0),
                                              children: <Widget>[
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                            .data
                                                            .snapshot
                                                            .value['photoUrl']),
                                                  ),
                                                  title: Text(
                                                    'Visit ${snapshot.data.snapshot.value['username']}\'s profile',
                                                    style: TextStyle(
                                                        fontFamily: 'Raleway'),
                                                  ),
                                                  onTap: () async {
                                                    FirebaseUser user =
                                                        await FirebaseAuth
                                                            .instance
                                                            .currentUser();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (c) => user
                                                                        .uid ==
                                                                    widget.user
                                                                ? ProfilePage()
                                                                : ViewProfilePage(
                                                                    widget
                                                                        .user)));
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.share),
                                                  title: Text(
                                                    'Share this post',
                                                    style: TextStyle(
                                                        fontFamily: 'Raleway'),
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      Share.text(
                                                          'Share Celfie',
                                                          'Check out the new Celfie app!',
                                                          'text/plain');
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.report,
                                                    color: Colors.red,
                                                  ),
                                                  title: Text(
                                                    'Report this post',
                                                    style: TextStyle(
                                                        fontFamily: 'Raleway'),
                                                  ),
                                                  onTap: () {},
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_up,
                                    color: TEXT_BLACK,
                                    size: SizeUtil.getAxisBoth(30.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ),

        StreamBuilder(
            stream: FirebaseDatabase.instance
                .reference()
                .child('users')
                .child(widget.user)
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Positioned(
                  bottom: SizeUtil.getAxisY(100.0),
                  left: SizeUtil.getAxisX(50.0),
                  child: InkWell(
                    onTap: () async {
                      FirebaseUser user =
                          await FirebaseAuth.instance.currentUser();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => user.uid == widget.user
                              ? ProfilePage()
                              : ViewProfilePage(widget.user)));
                    },
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              snapshot.data.snapshot.value['photoUrl'],
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }),
      ],
    );
  }

  _insertLikes() {
    //like the photo
    setState(() {
      likedByCurrentUser = !likedByCurrentUser;

      //add to db
      DatabaseReference ref = FirebaseDatabase.instance
          .reference()
          .child('posts')
          .child(widget.postKey);

      if (likedByCurrentUser == true) {
        likesCount++;

        print('the likes count $likesCount');

        widget.userNo == 0
            ? ref.child('likesCount1').set(likesCount)
            : ref.child('likesCount2').set(likesCount);
      } else {
        likesCount--;

        print('the likes count $likesCount');

        widget.userNo == 0
            ? ref.child('likesCount1').set(likesCount)
            : ref.child('likesCount2').set(likesCount);
      }
    });
    flareControls.play("like");
  }

  Widget _textBack(content,
      {color = TEXT_BLACK_LIGHT, size = TEXT_SMALL_2_SIZE, isBold = false}) {
    if (content.toString().length > 30) {
      content = content.toString().substring(0, 28) + '...';
    }

    return Text(
      content,
      style: TextStyle(
          fontFamily: 'Raleway',
          color: color,
          fontSize: SizeUtil.getAxisBoth(size),
          fontWeight: isBold ? FontWeight.w700 : null),
    );
  }

  String convertToMonth(int month) {
    switch (month) {
      case 8:
        return 'Aug';
        break;

      case 9:
        return 'Sept';
        break;

      case 10:
        return 'Oct';
        break;

      case 11:
        return 'Nov';
        break;

      default:
        return 'Jul';
        break;
    }
  }
}

class FeedPageTwelve extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedPageTwelve> {
  Widget _textBack(content,
          {color = TEXT_BLACK_LIGHT,
          size = TEXT_SMALL_2_SIZE,
          isBold = false}) =>
      Text(
        content,
        style: TextStyle(
            color: color,
            fontFamily: 'Raleway',
            fontSize: SizeUtil.getAxisBoth(size),
            fontWeight: isBold ? FontWeight.w700 : null),
      );

  Widget _listItemName() => Container(
        alignment: AlignmentDirectional.bottomStart,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _textBack("Hristo Hristov", size: TEXT_SMALL_3_SIZE, isBold: true),
            SizedBox(height: SizeUtil.getAxisY(13.0)),
            _textBack("4 hours ago", size: TEXT_NORMAL_SIZE),
          ],
        ),
      );

  Widget _action(icon, value) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: SizeUtil.getAxisBoth(30.0),
            color: TEXT_BLACK_LIGHT,
          ),
          SizedBox(height: SizeUtil.getAxisY(26.0)),
          _textBack(value)
        ],
      );

  Widget _listItemAction() => Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _action(Icons.favorite_border, "233"),
              SizedBox(height: SizeUtil.getAxisY(56.0)),
              _action(Icons.chat, "35"),
              SizedBox(height: SizeUtil.getAxisY(56.0)),
              _action(Icons.share, "12"),
              SizedBox(height: SizeUtil.getAxisY(56.0)),
              _action(Icons.more_vert, ""),
            ]),
      );

  Widget _listItem(index) => Container(
        height: SizeUtil.getAxisY(940.0),
        decoration: BoxDecoration(
            gradient: index % 2 == 1
                ? LinearGradient(
                    colors: [Color(0x55FFFFFF), Colors.transparent])
                : null),
        padding: EdgeInsets.only(
            top: SizeUtil.getAxisY(40.0), bottom: SizeUtil.getAxisY(40.0)),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            //item #1
            Row(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
                  child: _listItemAction(),
                ),
                Container(
                    child: Stack(
                  children: <Widget>[
                    //this is the main image
                    Container(
                      height: SizeUtil.getAxisY(750.0),
                      width: SizeUtil.getAxisX(653.0),
                      child: Image.asset(
                        index % 2 == 0
                            ? "assets/images/dogCute.jpeg"
                            : "assets/images/dogDoc.jpeg",
                        fit: BoxFit.cover,
                        height: SizeUtil.getAxisY(750.0),
                        width: SizeUtil.getAxisX(653.0),
                      ),
                    ),

                    //this is the pp
                    Positioned(
                      width: SizeUtil.getAxisBoth(CIRCLE_BUTTON_HEIGHT),
                      height: SizeUtil.getAxisBoth(CIRCLE_BUTTON_HEIGHT),
                      left: SizeUtil.getAxisX(24.0),
                      bottom: SizeUtil.getAxisY(0),
                      child: Image.asset(
                        "assets/images/dogCute.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),

                    //this is the name
                    Positioned(
                      left: SizeUtil.getAxisX(160.0),
                      bottom: SizeUtil.getAxisY(10.0),
                      child: _listItemName(),
                    ),
                  ],
                )),
                //this is the action bar
              ],
            ),

            //item #2
            Container(
                child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    //this is the main image
                    Container(
                      height: SizeUtil.getAxisY(750.0),
                      width: SizeUtil.getAxisX(653.0),
                      child: Image.asset(
                        index % 2 == 0
                            ? "assets/images/dogCute.jpeg"
                            : "assets/images/dogDoc.jpeg",
                        fit: BoxFit.cover,
                        height: SizeUtil.getAxisY(750.0),
                        width: SizeUtil.getAxisX(653.0),
                      ),
                    ),

                    //this is the pp
                    Positioned(
                      width: SizeUtil.getAxisBoth(CIRCLE_BUTTON_HEIGHT),
                      height: SizeUtil.getAxisBoth(CIRCLE_BUTTON_HEIGHT),
                      left: SizeUtil.getAxisX(24.0),
                      bottom: SizeUtil.getAxisY(20.0),
                      child: Image.asset(
                        "assets/images/dogCute.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),

                    //this is the name
                    Positioned(
                      left: SizeUtil.getAxisX(160.0),
                      bottom: SizeUtil.getAxisY(10.0),
                      child: _listItemName(),
                    ),
                  ],
                ),

                //this is the action bar
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, left: 20.0, top: 40.0),
                  child: _listItemAction(),
                )
              ],
            )),
          ],
        ),
      );

  Widget _body() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _listItem(index);
        },
        itemCount: 4,
        padding: EdgeInsets.only(top: 0.1),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.light
                  ? aquaGradients
                  : [
                      Colors.black12,
                      Colors.black26,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.centerLeft)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              'Celfie',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0, fontFamily: 'Pacifico'),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                _body(),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
