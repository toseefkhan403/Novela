import 'package:flutter/material.dart';
import 'dart:math';
import 'package:arctic_pups/utils/colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const CIRCLE_BUTTON_HEIGHT = 87.0;
const SQUARE_BUTTON_HEIGHT = 127.0;
const PHOTO_BUTTON_HEIGHT = 200.0;
const REC_BUTTON_WIDTH = 255.0;
const REC_BUTTON_HEIGHT = 96.0;
const TOP_BAR_HEIGHT = 152.0;
const TOP_BAR_GRADIENT_HEIGHT = 133.0;
const BOTTOM_BAR_HEIGHT = 200.0;
const ICON_BUTTON_WIDTH = 32.0;
const ICON_BUTTON_HEIGHT = 32.0;

const TEXT_SIZE_XXL = 50.0;
const TEXT_SIZE_XL = 40.0;
const TEXT_SIZE_L = 28.0;
const TEXT_SIZE_M = 26.0;
const TEXT_SIZE_S = 24.0;

class ProfileColors {
  static const COLOR_BLACK = Color(0xFF010101);
  static const COLOR_GREY = Color(0xFF424242);
  static const COLOR_WHITE = Color(0xFFF7FFE3);
  static const COLOR_DARK = Color(0xFF34323D);
  static const COLOR_YELLOW = Color(0xFFF1EA94);
  static const COLOR_LIGHT_ORANGE = Color(0xFFFFC3A0);
  static const COLOR_LIGHT_RED = Color(0xFFFFAFBD);
}

class SizeUtil {
  static const _DESIGN_WIDTH = 750;
  static const _DESIGN_HEIGHT = 1334;

  //logic size in device
  static Size _logicSize;

  //device pixel radio.

  static get width {
    return _logicSize.width;
  }

  static get height {
    return _logicSize.height;
  }

  static set size(size) {
    _logicSize = size;
  }

  //@param w is the design w;
  static double getAxisX(double w) {
    return (w * width) / _DESIGN_WIDTH;
  }

// the y direction
  static double getAxisY(double h) {
    return (h * height) / _DESIGN_HEIGHT;
  }

  // diagonal direction value with design size s.
  static double getAxisBoth(double s) {
    return s *
        sqrt((width * width + height * height) /
            (_DESIGN_WIDTH * _DESIGN_WIDTH + _DESIGN_HEIGHT * _DESIGN_HEIGHT));
  }
}

class TopBar extends StatelessWidget {
  TopBar(
      {this.leftIcon,
        this.rightIcon,
        this.title,
        this.onLeftIconPressed,
        this.onRightIconPressed});

  final String leftIcon;
  final String rightIcon;
  final String title;
  final Function() onLeftIconPressed;
  final Function() onRightIconPressed;

  @override
  Widget build(BuildContext context) {
    final icons = <Widget>[];
    if (leftIcon != null) {
      icons.add(InkWell(
        onTap: onLeftIconPressed,
        child: Image.asset(leftIcon,
            width: SizeUtil.getAxisY(CIRCLE_BUTTON_HEIGHT),
            height: SizeUtil.getAxisY(CIRCLE_BUTTON_HEIGHT)),
      ));
    }
    if (rightIcon != null) {
      icons.add(InkWell(
        onTap: onRightIconPressed,
        child: Image.asset(rightIcon,
            width: SizeUtil.getAxisY(CIRCLE_BUTTON_HEIGHT),
            height: SizeUtil.getAxisY(CIRCLE_BUTTON_HEIGHT)),
      ));
    }

    return Container(
      constraints:
      BoxConstraints.expand(height: SizeUtil.getAxisY(TOP_BAR_HEIGHT)),
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(
                height: SizeUtil.getAxisY(TOP_BAR_GRADIENT_HEIGHT)),
            decoration:
            BoxDecoration(gradient: LinearGradient(colors: [YELLOW, BLUE])),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: SizeUtil.getAxisY(30.0)),
              child: Text(
                this.title.toUpperCase(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeUtil.getAxisBoth(TEXT_SIZE_L),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAxisX(24.0)),
            alignment: AlignmentDirectional.bottomStart,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: icons),
          )
        ],
      ),
    );
  }
}


class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

    Widget _bottomBar() {
      return Container(
        constraints:
            BoxConstraints.expand(height: SizeUtil.getAxisY(BOTTOM_BAR_HEIGHT)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: SizeUtil.getAxisX(PHOTO_BUTTON_HEIGHT),
              height: SizeUtil.getAxisY(PHOTO_BUTTON_HEIGHT),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0x44FFFFFF), Color(0x44FFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(
                  SizeUtil.getAxisX(22.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '17,589',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeUtil.getAxisBoth(TEXT_SIZE_S),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'followers',
                    style: TextStyle(
                      color: ProfileColors.COLOR_DARK,
                      fontSize: SizeUtil.getAxisBoth(TEXT_SIZE_S),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: SizeUtil.getAxisX(PHOTO_BUTTON_HEIGHT),
              height: SizeUtil.getAxisY(PHOTO_BUTTON_HEIGHT),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '9,854',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeUtil.getAxisBoth(TEXT_SIZE_S),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'following',
                    style: TextStyle(
                      color: ProfileColors.COLOR_DARK,
                      fontSize: SizeUtil.getAxisBoth(TEXT_SIZE_S),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [YELLOW, GREEN],
            begin: Alignment.topLeft,
            end: Alignment.centerLeft,
          ),
        ),
        child: Column(
          children: <Widget>[
            TopBar(
              leftIcon: "assets/images/dogDoc.jpeg",
              title: "My cool name",
              onLeftIconPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeUtil.getAxisY(162.0),
                            horizontal: SizeUtil.getAxisX(28.0)),
                        child: Opacity(
                          opacity: 0.2,
                          child: new Container(
                            height: SizeUtil.getAxisY(722.0),
                            width: SizeUtil.getAxisX(46.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeUtil.getAxisY(116.0),
                            horizontal: SizeUtil.getAxisX(74.0)),
                        child: Opacity(
                          opacity: 0.6,
                          child: new Container(
                            height: SizeUtil.getAxisY(815.0),
                            width: SizeUtil.getAxisX(46.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: SizeUtil.getAxisY(62.0),
                            bottom: SizeUtil.getAxisY(62.0),
                            left: SizeUtil.getAxisX(120.0),
                            right: 0.0),
                        child: Container(
                          height: SizeUtil.getAxisY(926.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 15,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15)),
                                child: Image.asset(
                                  "assets/images/dogCute.jpeg",
                                  width: SizeUtil.getAxisX(630.0),
                                  height: SizeUtil.getAxisY(418.0),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints.expand(
                                    height: SizeUtil.getAxisY(148.0)),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      ProfileColors.COLOR_LIGHT_ORANGE,
                                      ProfileColors.COLOR_LIGHT_RED
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '7,455',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: SizeUtil.getAxisBoth(
                                                TEXT_SIZE_M),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'followers',
                                          style: TextStyle(
                                            color: ProfileColors.COLOR_DARK,
                                            fontSize: SizeUtil.getAxisBoth(
                                                TEXT_SIZE_M),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '2,455',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: SizeUtil.getAxisBoth(
                                                TEXT_SIZE_M),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'followings',
                                          style: TextStyle(
                                            color: ProfileColors.COLOR_DARK,
                                            fontSize: SizeUtil.getAxisBoth(
                                                TEXT_SIZE_M),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '455',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: SizeUtil.getAxisBoth(
                                                TEXT_SIZE_M),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'photos',
                                          style: TextStyle(
                                            color: ProfileColors.COLOR_DARK,
                                            fontSize: SizeUtil.getAxisBoth(
                                                TEXT_SIZE_M),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints.expand(
                                    height: SizeUtil.getAxisY(360.0)),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      width: SizeUtil.getAxisX(300.0),
                                      height: SizeUtil.getAxisY(360.0),
                                      right: SizeUtil.getAxisX(0.0),
                                      top: SizeUtil.getAxisY(0.0),
                                      child: Image.asset(
                                        "assets/images/dogCute.jpeg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      width: SizeUtil.getAxisX(180.0),
                                      height: SizeUtil.getAxisY(180.0),
                                      left: SizeUtil.getAxisX(0.0),
                                      top: SizeUtil.getAxisY(0.0),
                                      child: Image.asset(
                                        "assets/images/dogCute.jpeg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                        width: SizeUtil.getAxisX(180.0),
                                        height: SizeUtil.getAxisY(180.0),
                                        top: SizeUtil.getAxisX(180.0),
                                        left: SizeUtil.getAxisY(0.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15)),
                                          child: Image.asset(
                                            "assets/images/dogCute.jpeg",
                                            width: SizeUtil.getAxisX(180.0),
                                            height: SizeUtil.getAxisY(180.0),
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    Positioned(
                                      width: SizeUtil.getAxisX(180.0),
                                      height: SizeUtil.getAxisY(180.0),
                                      left: SizeUtil.getAxisX(180.0),
                                      top: SizeUtil.getAxisY(180.0),
                                      child: Image.asset(
                                        "assets/images/dogCute.jpeg",
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        width: SizeUtil.getAxisX(214.0),
                        height: SizeUtil.getAxisY(214.0),
                        left: SizeUtil.getAxisX(282.0),
                        top: SizeUtil.getAxisY(608.0),
                        child: Container(
                          constraints: BoxConstraints.expand(
                            height: SizeUtil.getAxisY(214),
                            width: SizeUtil.getAxisX(214),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.redAccent, Colors.pinkAccent]),
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '+123',
                                  style: TextStyle(
                                    color: ProfileColors.COLOR_WHITE,
                                    fontSize:
                                        SizeUtil.getAxisBoth(TEXT_SIZE_XL),
                                  ),
                                ),
                                Text(
                                  "assets/images/dogCute.jpeg",
                                  style: TextStyle(
                                    color: ProfileColors.COLOR_WHITE,
                                    fontSize: SizeUtil.getAxisBoth(TEXT_SIZE_S),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        width: SizeUtil.getAxisX(72.0),
                        height: SizeUtil.getAxisY(72.0),
                        left: SizeUtil.getAxisX(84.0),
                        top: SizeUtil.getAxisY(517.0),
                        child: InkWell(
                          onTap: () => debugPrint('Add button pressed'),
                          child: Image.asset("assets/images/dogCute.jpeg",
                              width: SizeUtil.getAxisX(72.0),
                              height: SizeUtil.getAxisY(72.0)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            _bottomBar()
          ],
        ),
      ),
    );
  }
}
