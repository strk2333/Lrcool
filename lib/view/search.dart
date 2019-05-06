import 'package:flutter/material.dart';
import '../api/lrcapi.dart';
import '../resources/color.dart';
import './lrc.dart';
import '../utils/utils.dart';

class SearchView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchViewState();
}

class SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  final tc = TextEditingController();
  var result = <Lrc>[];
  var sc = ScrollController();
  String source = "netease";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 35,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              DropdownButton(
                value: source,
                style: TextStyle(color: Colors.black),
                items: [
                  DropdownMenuItem(
                    value: "netease",
                    child: Text("Netease"),
                  ),
                  DropdownMenuItem(
                    value: "tencent",
                    child: Text("Tencent"),
                  ),
                  DropdownMenuItem(
                    value: "kugou",
                    child: Text("Kugou"),
                  ),
                  // DropdownMenuItem(
                  //   value: "kuwo",
                  //   child: Text("Kuwo"),
                  // ),
                ],
                onChanged: (value) {
                  setState(() {
                    LrcApi.changeSource(value);
                    source = value;
                  });
                },
              )
            ],
          ),
          buildSearchBar(),
          Padding(
            padding: EdgeInsets.only(top: 30),
          ),
          buildSearchRes(),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                ),
                // contentPadding: EdgeInsets.only(top: 1),
                border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorIndex.data[MColor.primary])),
              ),
              controller: tc,
              onSubmitted: onSubmitSearch,
              style: TextStyle(fontSize: 23),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSearchRes() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Container(
        height: Utils.getDeviceSize(context).height * 0.75,
        child: ListView(
          controller: sc,
          itemExtent: 120,
          padding: EdgeInsets.all(0),
          children: buildSearchTiles(),
        ),
      ),
    );
  }

  List<Widget> buildSearchTiles() {
    var list = <Widget>[];

    for (var i = 0; i < result.length; i++) {
      list.add(
        Padding(
          key: Key(result[i].id),
          padding: EdgeInsets.only(bottom: 10),
          child: LrcListTile(result[i].id, result[i].title, result[i].summary),
        ),
      );
    }

    if (result.length > 0) {
      var idx = result.length - 1;
      list.removeLast();
      list.add(
          LrcListTile(result[idx].id, result[idx].title, result[idx].summary));
    }

    return list;
  }

  onSubmitSearch(String text) {
    sc.jumpTo(sc.initialScrollOffset);
    LrcApi.searchLrc(text).then((list) {
      setState(() {
        result = list;
      });
    });
  }
}

class LrcListTile extends StatefulWidget {
  final String lrcID;
  final String title;
  final String summary;

  LrcListTile(this.lrcID, this.title, this.summary);

  @override
  State<StatefulWidget> createState() =>
      LrcListTileState(lrcID, title, summary);
}

class LrcListTileState extends State<LrcListTile>
    with SingleTickerProviderStateMixin {
  final String lrcID;
  final String title;
  final String summary;

  LrcListTileState(this.lrcID, this.title, this.summary);
  // anim
  AnimationController ac;
  Animation<double> anim;
  initState() {
    super.initState();
    ac = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    anim = TweenSequence([
      TweenSequenceItem(weight: 1, tween: Tween(begin: 8.0, end: 100.0)),
      TweenSequenceItem(weight: 1, tween: Tween(begin: 100.0, end: 8.0))
    ]).animate(ac)
      ..addListener(() {
        setState(() {
          if (ac.isCompleted) {
            ac.reset();
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return buildSearchTile(lrcID, title, summary);
  }

  Widget buildSearchTile(String lrcID, String title, String summary) {
    return GestureDetector(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              ColorIndex.data[MColor.primary].withAlpha(anim.value.toInt()),
              Colors.white.withAlpha(0)
            ]),
            border: Border(
              left:
                  BorderSide(color: ColorIndex.data[MColor.primary], width: 5),
            )),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.music_note,
              size: 30,
              color: ColorIndex.data[MColor.primary],
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontSize: 17),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Expanded(
                      child: Text(
                    summary.replaceAll("\n", " "),
                    softWrap: true,
                    maxLines: 3,
                    style: TextStyle(fontSize: 14),
                  )),
                ],
              ),
            )),
            // Text(""),
          ],
        ),
      ),
      onTapDown: (details) {
        setState(() {
          ac.forward();
        });
      },
      onTap: () {
        String content = "";
        LrcApi.getLrc(lrcID).then((res) {
          content = res.toString();
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return LrcView(title, content);
          }));
        });
      },
    );
  }

  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }
}
