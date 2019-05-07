import 'package:audioplayers/audioplayers.dart';

class MusicPlayer {
  final player = AudioPlayer();
  var state = PlayState.None;

  play(String url) async {
    int result = await player.play(url);
    if (result == 1) {
      state =PlayState.Playing;
    }
  }

  pause() async {
    if (state ==PlayState.Playing) {
      await player.pause();
      state = PlayState.Pause;
    }
  }

  resume() async {
    if (state == PlayState.Pause || state == PlayState.Stop) {
      await player.resume();
      state = PlayState.Playing;
    }
  }

  stop() async {
    if (state ==PlayState.Playing) {
      await player.stop();
      state =PlayState.Stop;
    }
  }

  getPlayTime() {
    player.onAudioPositionChanged;
  }

  dispose() {
    player.release();
  }
}

enum PlayState {
  None,
  Playing,
  Pause,
  Stop,
}