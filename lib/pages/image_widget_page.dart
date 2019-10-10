import 'dart:ui';
import 'package:arctic_pups/pay_us_money.dart';
import 'package:arctic_pups/services.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageStatefulWidget extends StatefulWidget {
  final bool isRight;
  final data;
  final String genre;

  ImageStatefulWidget(this.isRight, this.data, this.genre);

  @override
  _ImageStatefulWidgetState createState() => _ImageStatefulWidgetState();
}

class _ImageStatefulWidgetState extends State<ImageStatefulWidget> {
  bool _isUnlocked = false;


  @override
  void initState() {

    checkIfPaid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment:
          widget.isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: widget.isRight
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(widget.isRight
                  ? widget.data['sent_by']
                  .toString()
                  .replaceAll('1', " ")
                  .toString()
                  : widget.data['sent_by'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.isRight
                      ? kShrinePink500
                      : (widget.genre == "Horror" ||
                      widget.genre == "Thriller")
                      ? Colors.tealAccent
                      : kShrineBrown600,
                ),),
            ),

            InkWell(
              onTap: () {
                _isUnlocked
                    ? Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => ImagePage(
                        widget.data['content'],
                        widget.isRight
                            ? widget.data['sent_by']
                            .toString()
                            .replaceAll('1', " ")
                            .toString()
                            : widget.data['sent_by'])))
                    : PayUsMoney.showUnlockDialog(context, 'Image', 10, '',
                    onUnlock: () {
                      setState(() {
                        print('is unlocked getting called');
                        _isUnlocked = true;
                      });
                    });
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Hero(
                  tag: widget.data['content'].toString(),
                  child: _isUnlocked
                      ? ClipRRect(
                        borderRadius: new BorderRadius.circular(20.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/loading.gif',
                          image: widget.data['content'],
                          fit: BoxFit.cover,
                        ),
                      )
                      : Stack(
                    children: <Widget>[

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          child: Container(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaY: 22.0, sigmaX: 22.0),
                              child: Container(
                                color: Colors.white.withOpacity(0.0),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(widget.data['content'],), fit: BoxFit.cover),
                          ),
                        ),
                      ),

                      Center(
                        child: Text(
                          'Tap to unlock',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )

                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkIfPaid() async {

    bool paidUse = await paidUser();
    if (paidUse){
      setState(() {
        _isUnlocked = true;
      });
    }
  }
}

class ImagePage extends StatelessWidget {
  final String imgUrl, name;

  ImagePage(this.imgUrl, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Container(
          child: Center(
            child: Hero(
              tag: imgUrl,
              child: PhotoView(
                imageProvider: NetworkImage(
                  imgUrl,
                ),
              ),
            ),
          ),
        ));
  }
}