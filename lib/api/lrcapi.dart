import 'package:dio/dio.dart';
import 'dart:io';
import 'package:sprintf/sprintf.dart';
import 'package:path_provider/path_provider.dart';

class LrcApi {
  // https://api.itooi.cn/music/netease/search?
  // key=579621905&s=我喜欢上你内心时的活动&type=song&limit=100&offset=0
  static String _source = "netease";
  static String _baseUrl = "https://api.itooi.cn/music/" +
      _source +
      "/search?key=579621905&type=lrc&s=%s&limit=%d&offset=%d";
  static String _baseGetUrl =
      "https://api.itooi.cn/music/" + _source + "/lrc?key=579621905&id=%s";
  static String _baseGetMusic = "https://api.itooi.cn/music/" +
      _source +
      "/url?key=579621905&id=%s&br=%s";

  static final bps = <BPS, String>{
    BPS.AUTO: "000000",
    BPS.LOW: "128000",
    BPS.MID: "192000",
    BPS.HIGH: "320000",
    BPS.ULTRA: "999000",
  };

  static Future<List<Lrc>> searchLrc(String keyWord) async {
    var url = sprintf(_baseUrl, [keyWord, 20, 0]);
    var list = <Lrc>[];
    return await Dio().get(url).then((resp) {
      if (resp.statusCode == HttpStatus.ok) {
        switch (_source) {
          case "netease":
            _packLrcData(
                resp.data["data"]["songs"], list, ["id", "name", "lyrics"]);
            break;
          case "tencent":
            _packLrcData(
                resp.data["data"], list, ["media_mid", "albumname", "content"]);
            break;
          case "kugou":
            _packLrcData(
                resp.data["data"], list, ["hash", "filename", "lyric"]);
            break;
          case "kuwo": // dismiss
            break;
          default:
        }
      }

      return list;
    }).catchError((e) {
      print(e);
      return list;
    });
  }

  static _packLrcData(dynamic data, List<Lrc> list, List<String> dataNames) {
    for (var song in data) {
      list.add(Lrc(
          song[dataNames[0]].toString(),
          song[dataNames[1]].toString(),
          song[dataNames[2]]
              .toString()
              .replaceAll(", ", "\n")
              .replaceAll(",", "")
              // .replaceFirst('[', "")
              .replaceAll(RegExp(r"(<em>|</em>|<b>|</b>)"), "")
              .replaceAll(RegExp(r"^\[.*?\]", multiLine: true), "")));
    }
  }

  static Future<List<LrcClip>> getLrc(String id) async {
    var url = sprintf(_baseGetUrl, [id]);
    var list = <LrcClip>[];
    return await Dio()
        .get(url, options: Options(responseType: ResponseType.plain))
        .then((res) {
      if (res.statusCode == HttpStatus.ok) {
        print(url);
        var reg = RegExp(r"\[[\d|:|\.]*?\]");

        for (var clip in reg.allMatches(res.data.toString())) {
          var rawTime = clip.group(0).substring(1, clip.group(0).length - 1);

          int milliTime = 0;
          var spliceList = rawTime.split(".");
          if (spliceList.length != 2) return list;
          milliTime += int.parse(spliceList[1]);
          var spliceList2 = spliceList[0].split(":");
          int radix = 0;
          for (int i = spliceList2.length - 1; i >= 0; i--) {
            int radixMulti = radix == 0 ? 1 : radix * 60;
            milliTime += int.parse(spliceList2[i]) * 1000 * radixMulti;
            radix++;
          }

          list.add(LrcClip(time: milliTime));
        }

        List splitList = res.data.toString().split(reg);
        if (splitList.length > 1) {
          splitList.removeAt(0);
          for (var i = 0; i < splitList.length; i++) {
            list[i].text = splitList[i];
          }
        } else {}
        // res.data
        //     .toString()
        //     .replaceAll(RegExp(r"^\[.*?\]", multiLine: true), "");
      }
      return list;
    }).catchError((e) {
      print(e);
      return list;
    });
  }

  static Future<String> getMusicUrl(String id,
      {BPS quality = BPS.AUTO, int times = 0}) async {
        String url;
    if (quality == BPS.AUTO) {
      BPS autoQuality;
      switch (times) {
        case 0:
          autoQuality = BPS.LOW;
          break;
        case 1:
          autoQuality = BPS.MID;
          break;
        case 2:
          autoQuality = BPS.HIGH;
          break;
        case 3:
          autoQuality = BPS.ULTRA;
          break;
        default:
          autoQuality = BPS.LOW;
      }
      print(autoQuality);
      url = sprintf(_baseGetMusic, [id, bps[autoQuality]]);
    } else {
      url = sprintf(_baseGetMusic, [id, bps[quality]]);
    }

    return await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes))
        .then((res) {
      if (res.statusCode == HttpStatus.ok) {
        print(res.redirects[0].location);
        if (res.redirects.length != 0) {
          return res.redirects[0].location.toString();
        }
        return "No Redirect Found";
      }
      return "Bad Response";
    }).catchError((e) {
      print(e);

      if (quality != BPS.AUTO || times == 3)
        return "Fetch Error";
      else
        return getMusicUrl(id, quality: BPS.AUTO, times: times + 1);
    });
  }

  static changeSource(String value) {
    _source = value;
    _baseUrl = "https://api.itooi.cn/music/" +
        _source +
        "/search?key=579621905&type=lrc&s=%s&limit=%d&offset=%d";
    _baseGetUrl =
        "https://api.itooi.cn/music/" + _source + "/lrc?key=579621905&id=%s";
  }
}

class Lrc {
  String id;
  String title;
  String summary;
  String musicUrl;

  Lrc(this.id, this.title, this.summary, {this.musicUrl});
}

class LrcClip {
  int time;
  String text;

  LrcClip({this.time = 0, this.text = ""});

  @override
  String toString() {
    return time.toString() + text;
  }
}

enum BPS {
  AUTO,
  LOW,
  MID,
  HIGH,
  ULTRA,
}
