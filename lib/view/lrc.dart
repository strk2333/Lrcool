import 'package:flutter/material.dart';
import '../api/musicapi.dart';

class LrcView extends StatefulWidget {
  final String title;
  final String content;
  final String musicUrl;

  LrcView(this.title, this.content, {this.musicUrl});

  @override
  State<StatefulWidget> createState() =>
      LrcViewState(title, content, musicUrl: musicUrl);
}

class LrcViewState extends State<LrcView> {
  final String title;
  final String content;
  final String musicUrl;

  var player = MusicPlayer();

  LrcViewState(this.title, this.content, {this.musicUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
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
                    IconButton(icon: Icon(() {
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
                    }()), onPressed: () {
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
                    })
                  ],
                ),
                Text(musicUrl == null ? "No Url" : musicUrl),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
