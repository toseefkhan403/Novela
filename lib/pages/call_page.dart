import 'package:arctic_pups/main.dart';
import 'package:arctic_pups/pay_us_money.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';

class Call extends StatefulWidget {
  final data;

  Call(this.data);

  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  bool show = true;
  AudioPlayer player;

  @override
  void dispose() {
    Vibration.cancel();
    FlutterRingtonePlayer.stop();

    super.dispose();
  }

  @override
  void initState() {
    initAudio();
    FlutterRingtonePlayer.playRingtone();
    Vibration.vibrate(pattern: [
      500,
      1000,
      500,
      1000,
      500,
      1000,
      500,
      1000,
      500,
      1000,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Incoming call',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0),
                ),
              ),

              SizedBox(
                height: 50.0,
              ),

              Text(
                '${widget.data['sent_by']}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0),
              ),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                width: 295,
                height: 295,
                child: Center(
                    child:
                        Icon(Icons.person, size: 200.0, color: Colors.white)),
              ),
              show
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: 'btn2',
                          onPressed: () {
                            Vibration.cancel();
                            FlutterRingtonePlayer.stop();

                            PayUsMoney.showUnlockDialog(
                                context, 'Call', 20, '-audio', onUnlock: () {
                              setState(() {
                                show = false;
                              });

                              player.play(widget.data['content'],
                                  isLocal: false);
                            });
                          },
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.green,
                        ),
                        FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: () {
                            Vibration.cancel();
                            FlutterRingtonePlayer.stop();
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.red,
                        )
                      ],
                    )
                  : Container()
            ],
          )),
    );
  }

  void initAudio() {
    player = AudioPlayer();

    player.onPlayerStateChanged.listen((value) {
      if (value == AudioPlayerState.COMPLETED) {
        Navigator.of(context).pop();
      }
    }, onError: (error) {
      showTopToast('Can\'t take this call');
      Navigator.of(context).pop();
    });
  }
}
