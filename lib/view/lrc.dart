import 'package:flutter/material.dart';

class LrcView extends StatelessWidget {
  final String title;
  final String content;

  LrcView(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Text(title, style: TextStyle(fontSize: 25),),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(content, style: TextStyle(fontSize: 18),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
