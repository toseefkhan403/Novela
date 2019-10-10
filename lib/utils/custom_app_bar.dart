import 'package:arctic_pups/pages/view_chat_page.dart';
import 'package:arctic_pups/utils/appbar_painter.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title, storyImage, genre;
  final int totalEpisodes, episodeNo;

  DefaultAppBar(this.title, this.totalEpisodes, this.episodeNo, this.storyImage,
      this.genre);

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar>
    with SingleTickerProviderStateMixin {
  double rippleStartX, rippleStartY;
  AnimationController _controller;
  Animation _animation;
  bool isInChoosingMode = false;

  @override
  initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(animationStatusListener);
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
        isInChoosingMode = true;
      });
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    print("pointer location $rippleStartX, $rippleStartY");
    _controller.forward();
  }

  cancel() {
    setState(() {
      isInChoosingMode = false;
    });

    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      AppBar(
          centerTitle: true,
          leading: GestureDetector(
            onTapUp: onSearchTapUp,
            child: IconButton(
              icon: Icon(Icons.list, color: Colors.white),
            ),
          ),
          title: Text(
            '${widget.title.toString()} (Ep.${widget.episodeNo})',
            style: TextStyle(fontSize: 16.0),
          )),
      AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: MyPainter(
              containerHeight: widget.preferredSize.height,
              center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
              radius: _animation.value * screenWidth,
              context: context,
            ),
          );
        },
      ),
      SafeArea(
        top: true,
        child: Container(
          child: Center(
            child: isInChoosingMode
                ? (Row(children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          cancel();
                        }),
                    SizedBox(
                      width: 55.0,
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                if (widget.episodeNo > 1) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (c) => ViewChats(
                                              widget.title,
                                              widget.episodeNo - 1,
                                              widget.totalEpisodes,
                                              widget.storyImage,
                                              widget.genre)));
                                }
                              }),
                          Chip(
                              label: Text(
                                  'Episode ${widget.episodeNo} of ${widget.totalEpisodes}',
                                  style: TextStyle(fontSize: 12.0))),
                          IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                if (widget.episodeNo < widget.totalEpisodes) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (c) => ViewChats(
                                              widget.title,
                                              widget.episodeNo + 1,
                                              widget.totalEpisodes,
                                              widget.storyImage,
                                              widget.genre)));
                                }
                              }),
                        ],
                      ),
                    )
                  ]))
                : (Container()),
          ),
        ),
      )
    ]);
  }
}
