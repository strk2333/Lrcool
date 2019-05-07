import 'package:flutter/material.dart';
import 'dart:math';
import '../api/musicapi.dart';
import '../api/lrcapi.dart';
import '../utils/utils.dart';

class LrcView extends StatefulWidget {
  final String title;
  final List<LrcClip> content;
  final String musicUrl;

  LrcView(this.title, this.content, {this.musicUrl});

  @override
  State<StatefulWidget> createState() =>
      LrcViewState(title, content, musicUrl: musicUrl);
}

class LrcViewState extends State<LrcView> with SingleTickerProviderStateMixin {
  final String title;
  final List<LrcClip> content;
  final String musicUrl;
  final ScrollController sc = ScrollController();

  var player = MusicPlayer();
  var curPos = Duration(seconds: 0);
  var duration = Duration(seconds: 0);

  int probe = 0;
  double offset = 0;

  LrcViewState(this.title, this.content, {this.musicUrl}) {
    playerListen();
  }

  playerListen() {
    player.player.onAudioPositionChanged.listen((d) {
      setState(() {
        curPos = d;
        updateProbe(d);
      });
    });

    player.player.onDurationChanged.listen((d) {
      setState(() {
        this.duration = d;
      });
    });
  }

  updateProbe(Duration d) {
    int index = content.length - 1;
    for (int i = 0; i < content.length - 1; i++) {
      if (content[i + 1].time > d.inMilliseconds) {
        index = i;
        break;
      }
    }

    // 50 * (probe - 5).toDouble() - position
    if (probe != index) {
      setState(() {
        probe = index;
        if (probe > 5 && probe < content.length - 6) {
          // sc.jumpTo(50 * (probe - 5).toDouble() * anim.value);
          // sc.jumpTo(sc.position. + 50 * ac.value);
          sc.animateTo(50 * (probe - 5).toDouble(), duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        } else if (probe < 5) sc.jumpTo(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            // Text(musicUrl == null ? "No Url" : musicUrl),
            Expanded(
              child: ListView(
                itemExtent: 50,
                controller: sc,
                children: () {
                  var tmp = List<Widget>();
                  for (var i = 0; i < content.length; i++) {
                    if (probe == i) {
                      tmp.add(MaterialButton(
                        child: Text(
                          content[i].text,
                          style: TextStyle(color: Colors.purple, fontSize: 18),
                        ),
                        onPressed: () {},
                      ));
                    } else
                      tmp.add(MaterialButton(
                        child: Text(
                          content[i].text,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        onPressed: () {},
                      ));
                  }
                  return tmp;
                }(),
              ),
            ),

            // Text(
            //   content.toString(),
            //   style: TextStyle(fontSize: 18),
            // ),

            // Row(
            //   children: <Widget>[
            //     // progressBar(),
            //     Expanded(
            //       child: Container(
            //         decoration: BoxDecoration(border: Border.all(width: 1)),
            //         child: Transform.rotate(
            //           angle: pi / 2,
            //           child: progressBar(),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        Positioned(
          bottom: 0.0,
          height: 5,
          width: Utils.getDeviceSize(context).width,
          child: progressBar(),
        ),
        Positioned(
          bottom: 0,
          right: -5,
          child: playButton(),
        )
      ]),
    );
  }

  Widget playButton() {
    return IconButton(
        icon: Icon(
          () {
            switch (player.state) {
              case PlayState.Playing:
                return Icons.pause;
              case PlayState.None:
                return Icons.play_arrow;
              case PlayState.Pause:
                return Icons.play_arrow;
              case PlayState.Stop:
                return Icons.play_arrow;
              default:
                return Icons.play_arrow;
            }
          }(),
          size: 35,
        ),
        onPressed: () {
          setState(() {
            switch (player.state) {
              case PlayState.Playing:
                player.pause();
                break;
              case PlayState.None:
                player.play(musicUrl);
                break;
              case PlayState.Pause:
                player.resume();
                break;
              case PlayState.Stop:
                player.resume();
                break;
              default:
            }
          });
        });
  }

  Widget progressBar() {
    return LinearProgressIndicator(
      value:
          duration.inSeconds == 0 ? 0 : curPos.inSeconds / duration.inSeconds,
      semanticsLabel: "111",
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
