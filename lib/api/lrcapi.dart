import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:sprintf/sprintf.dart';

class LrcApi {
  // https://api.itooi.cn/music/netease/lrc?key=
  // https://api.itooi.cn/music/netease/search?
  // key=579621905&s=我喜欢上你内心时的活动&type=song&limit=100&offset=0
  static String _source = "netease";
  // static final Map<String, int> _keys = {"tencent": 579621905, "netease": 579621905};
  static String _baseUrl = "https://api.itooi.cn/music/" +
      _source +
      "/search?key=579621905&type=lrc&s=%s&limit=%d&offset=%d";
  static String _baseGetUrl =
      "https://api.itooi.cn/music/" + _source + "/lrc?key=579621905&id=%s";

  static Future<List<Lrc>> searchLrc(String keyWord) async {
    var url = sprintf(_baseUrl, [keyWord, 21, 0]);
    var list = <Lrc>[];
    return await Dio().get(url).then((resp) {
      if (resp.statusCode == HttpStatus.ok) {
        final data = resp.data["data"];
        switch (_source) {
          case "netease":
            if (data["songCount"] != 0) {
              final songs = data["songs"];
              for (var song in songs) {
                list.add(Lrc(
                    song["id"].toString(),
                    song["name"].toString(),
                    song["lyrics"]
                        .toString()
                        .replaceAll(", ", "\n")
                        .replaceAll(",", "")
                        .replaceFirst('[', "")
                        .replaceAll(RegExp(r"(<em>|</em>|<b>|</b>)"), "")
                        .replaceAll(RegExp(r"^\[.*?\]", multiLine: true), "")));
                ;
              }
            }
            break;
          case "tencent":
            for (var song in resp.data["data"]) {
              list.add(Lrc(
                  song["media_mid"],
                  song["albumname"].toString(),
                  song["content"]
                      .toString()
                      .replaceAll(", ", "\n")
                      .replaceAll(",", "")
                      .replaceAll(RegExp(r"(<em>|</em>|<b>|</b>)"), "")
                      .replaceAll(RegExp(r"^\[.*?\]", multiLine: true), "")));
            }
            break;
          case "kugou":
            for (var song in resp.data["data"]) {
              list.add(Lrc(
                  song["320hash"],
                  song["filename"].toString(),
                  song["lyric"]
                      .toString()
                      .replaceAll(", ", "\n")
                      .replaceAll(",", "")
                      .replaceAll(RegExp(r"(<em>|</em>|<b>|</b>)"), "")
                      .replaceAll(RegExp(r"^\[.*?\]", multiLine: true), "")));
            }
            break;
          case "kuwo": // dismiss
            // for (var song in resp.data["data"]) {
            //   list.add(Lrc(
            //       song["320hash"],
            //       song["NAME"].toString(),
            //       song["lyric"]
            //           .toString()
            //           .replaceAll(", ", "\n")
            //           .replaceAll(",", "")
            //           .replaceAll(RegExp(r"(<em>|</em>|<b>|</b>)"), "")
            //           .replaceAll(RegExp(r"^\[.*?\]", multiLine: true), "")));
            // }
            break;
          default:
        }

        // for (var i in resp.data["data"]["songs"][0].keys) {
        //   print(i);
        // }
      }

      return list;
    }).catchError((e) {
      print(e);
      return list;
    });
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
