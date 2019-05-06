import 'package:dio/dio.dart';
import 'dart:io';
import 'package:sprintf/sprintf.dart';

class LrcApi {
  // https://api.itooi.cn/music/netease/search?
  // key=579621905&s=我喜欢上你内心时的活动&type=song&limit=100&offset=0
  static String _source = "netease";
  static String _baseUrl = "https://api.itooi.cn/music/" +
      _source +
      "/search?key=579621905&type=lrc&s=%s&limit=%d&offset=%d";
  static String _baseGetUrl =
      "https://api.itooi.cn/music/" + _source + "/lrc?key=579621905&id=%s";

  static Future<List<Lrc>> searchLrc(String keyWord) async {
    var url = sprintf(_baseUrl, [keyWord, 11, 0]);
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
                resp.data["data"], list, ["320hash", "filename", "lyric"]);
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
              .replaceFirst('[', "")
              .replaceAll(RegExp(r"(<em>|</em>|<b>|</b>)"), "")
              .replaceAll(RegExp(r"^\[.*?\]", multiLine: true), "")));
    }
  }

  static Future<String> getLrc(String id) async {
    var url = sprintf(_baseGetUrl, [id]);
    return await Dio()
        .get(url, options: Options(responseType: ResponseType.plain))
        .then((res) {
      if (res.statusCode == HttpStatus.ok) {
        return res.data
            .toString()
            .replaceAll(RegExp(r"^\[.*?\]", multiLine: true), "");
      }
      return "Bad Response";
    }).catchError((e) {
      print(e);
      return "Fetch Error";
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

  Lrc(this.id, this.title, this.summary);
}
