import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/size_util.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:arctic_pups/pages/login_page.dart';

//this page should get the posts from db and display them
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

    return Scaffold(
      body: FeedPageTwelve(),
    );
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
            top: SizeUtil.getAxisY(40.0), bottom: SizeUtil.getAxisY(20.0)),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
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
                  bottom: SizeUtil.getAxisY(89.0),
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

                //this is the action bar
                Positioned(
                  right: SizeUtil.getAxisX(40.0),
                  top: SizeUtil.getAxisY(100.0),
                  child: _listItemAction(),
                ),
              ],
            )),
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
                  bottom: SizeUtil.getAxisY(89.0),
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

                //this is the action bar
                Positioned(
                  right: SizeUtil.getAxisX(40.0),
                  top: SizeUtil.getAxisY(100.0),
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
              colors: aquaGradients,
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
