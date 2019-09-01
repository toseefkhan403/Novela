import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'package:arctic_pups/pages/login_page.dart';

var globalPost;
//perfect for stories
class CardFlip extends StatefulWidget {

  final post;

  CardFlip(this.post);

  @override
  _CardFlipState createState() => new _CardFlipState();
}

Widget buildPost(context, post){

  double scrollPercent = 0.0;

  print('the psot $post');
  globalPost = post;
  if (post != null) {

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Spacer for status bar
        new Container(
          width: double.infinity,
          height: 20.0,
        ),

        // Cards
        new Expanded(
          child: new CardFlipper(
              cards: demoCards,
              onScroll: (double scrollPercen) {
//                setState(() => scrollPercent = scrollPercen);
              }),
        ),

        // Scroll Indicator
        new BottomBar(
          cardCount: 2,
          scrollPercent: scrollPercent,
        ),
      ],
    );

  }else {
    return Container();
  }


}




class _CardFlipState extends State<CardFlip> {
  double scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    if (globalPost != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Spacer for status bar
            new Container(
              width: double.infinity,
              height: 20.0,
            ),

            // Cards
            new Expanded(
              child: new CardFlipper(
                  cards: demoCards,
                  onScroll: (double scrollPercent) {
                    setState(() => this.scrollPercent = scrollPercent);
                  }),
            ),

            // Scroll Indicator
            new BottomBar(
              cardCount: demoCards.length,
              scrollPercent: scrollPercent,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class CardFlipper extends StatefulWidget {
  final List<CardViewModel> cards;
  final Function onScroll;

  CardFlipper({
    this.cards,
    this.onScroll,
  });

  @override
  _CardFlipperState createState() => new _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  @override
  void initState() {
    super.initState();

    finishScrollController = new AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          scrollPercent =
              lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);

          if (widget.onScroll != null) {
            widget.onScroll(scrollPercent);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {});
  }

  void _onPanStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    setState(() {
      scrollPercent = (startDragPercentScroll + (-singleCardDragPercent / widget.cards.length))
          .clamp(0.0, 1.0 - (1 / widget.cards.length));
      print('percentScroll: $scrollPercent');

      if (widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent * widget.cards.length).round() / widget.cards.length;
    finishScrollController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  List<Widget> _buildCards() {
    int index = -1;
    return widget.cards.map((CardViewModel viewModel) {
      ++index;
      return _buildCard(viewModel, index, widget.cards.length, scrollPercent);
    }).toList();
  }

  Matrix4 _buildCardProjection(double scrollPercent) {
    // Pre-multiplied matrix of a projection matrix and a view matrix.
    //
    // Projection matrix is a simplified perspective matrix
    // http://web.iitd.ac.in/~hegde/cad/lecture/L9_persproj.pdf
    // in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, 0.0],
    //  [0.0, 0.0, -perspective, 1.0]]
    //
    // View matrix is a simplified camera view matrix.
    // Basically re-scales to keep object at original size at angle = 0 at
    // any radius in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, -radius],
    //  [0.0, 0.0, 0.0, 1.0]]
    final perspective = 0.002;
    final radius = 1.0;
    final angle = scrollPercent * pi / 8;
    final horizontalTranslation = 0.0;
    Matrix4 projection = new Matrix4.identity()
      ..setEntry(0, 0, 1 / radius)
      ..setEntry(1, 1, 1 / radius)
      ..setEntry(3, 2, -perspective)
      ..setEntry(2, 3, -radius)
      ..setEntry(3, 3, perspective * radius + 1.0);

    // Model matrix by first translating the object from the origin of the world
    // by radius in the z axis and then rotating against the world.
    final rotationPointMultiplier = angle > 0.0 ? angle / angle.abs() : 1.0;
    print('Angle: $angle');
    projection *= new Matrix4.translationValues(
        horizontalTranslation + (rotationPointMultiplier * 300.0), 0.0, 0.0) *
        new Matrix4.rotationY(angle) *
        new Matrix4.translationValues(0.0, 0.0, radius) *
        new Matrix4.translationValues(-rotationPointMultiplier * 300.0, 0.0, 0.0);

    return projection;
  }

  Widget _buildCard(
      CardViewModel viewModel,
      int cardIndex,
      int cardCount,
      double scrollPercent,
      ) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    final parallax = scrollPercent - (cardIndex / widget.cards.length);

    return new FractionalTranslation(
      translation: new Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Transform(
          transform: _buildCardProjection(cardScrollPercent - cardIndex),
          child: new Card(
            viewModel: viewModel,
            parallaxPercent: parallax,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onPanStart,
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final CardViewModel viewModel;
  final double parallaxPercent; // [0.0, 1.0] (0.0 for all the way right, 1.0 for all the way left)

  Card({
    this.viewModel,
    this.parallaxPercent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Background
        new ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: new Container(
            child: new FractionalTranslation(
              translation: new Offset(parallaxPercent * 2.0, 0.0),
              child: new OverflowBox(
                maxWidth: double.infinity,
                child: new Image.network(
                  viewModel.backdropAssetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // Content
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            new Expanded(child: new Container()),
            new Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: new Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(30.0),
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: new Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new Text(
                        '${viewModel.caption}',
                        style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Icon(
                          Icons.wb_cloudy,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  BottomBar({
    this.cardCount,
    this.scrollPercent,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: new Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Center(
                child: new Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ),
            new Expanded(
              child: new Center(
                child: new Container(
                  width: double.infinity,
                  height: 5.0,
                  child: new ScrollIndicator(
                    cardCount: cardCount,
                    scrollPercent: scrollPercent,
                  ),
                ),
              ),
            ),
            new Expanded(
              child: new Center(
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  ScrollIndicator({
    this.cardCount,
    this.scrollPercent,
  });

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new ScrollIndicatorPainter(
        cardCount: cardCount,
        scrollPercent: scrollPercent,
      ),
      child: new Container(),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final int cardCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({
    this.cardCount,
    this.scrollPercent,
  })  : trackPaint = new Paint()
    ..color = const Color(0xFF444444)
    ..style = PaintingStyle.fill,
        thumbPaint = new Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw track
    canvas.drawRRect(
      new RRect.fromRectAndCorners(
        new Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        topLeft: new Radius.circular(3.0),
        topRight: new Radius.circular(3.0),
        bottomLeft: new Radius.circular(3.0),
        bottomRight: new Radius.circular(3.0),
      ),
      trackPaint,
    );

    // Draw thumb
    final thumbWidth = size.width / cardCount;
    final thumbLeft = scrollPercent * size.width;

    Path thumbPath = new Path();
    thumbPath.addRRect(
      new RRect.fromRectAndCorners(
        new Rect.fromLTWH(
          thumbLeft,
          0.0,
          thumbWidth,
          size.height,
        ),
        topLeft: new Radius.circular(3.0),
        topRight: new Radius.circular(3.0),
        bottomLeft: new Radius.circular(3.0),
        bottomRight: new Radius.circular(3.0),
      ),
    );

    // Thumb shape
    canvas.drawPath(
      thumbPath,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}








final List<CardViewModel> demoCards = [
  new CardViewModel(
    backdropAssetPath: globalPost['photoUrl1'],
    caption: globalPost['caption1']
  ),
  new CardViewModel(
    backdropAssetPath: globalPost['photoUrl2'],
    caption: globalPost['caption2']
  ),
];

class CardViewModel {
  final String backdropAssetPath;
  final String caption;


  CardViewModel({
    this.backdropAssetPath,
    this.caption,
  });
}