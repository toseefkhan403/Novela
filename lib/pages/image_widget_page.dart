import 'package:arctic_pups/pay_us_money.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class ImageStatefulWidget extends StatefulWidget {
  final bool isRight;
  final data;

  ImageStatefulWidget(this.isRight, this.data);

  @override
  _ImageStatefulWidgetState createState() => _ImageStatefulWidgetState();
}

class _ImageStatefulWidgetState extends State<ImageStatefulWidget> {
  bool _isUnlocked = false;

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
                  : widget.data['sent_by']),
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
                      ? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.network(
                      widget.data['content'],
                      fit: BoxFit.cover,
                    ),
                  )
                      : Center(
                    child: Text(
                      'Tap to unlock',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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