import 'package:flutter/material.dart';
import './view/home.dart';
import './view/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int navIndex = 1; // first page
  List<Widget> _pages = [HomeView(), SearchView()]; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Key("main"),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        body: _pages[navIndex],
        bottomNavigationBar: BottomNavigationBar(
          key: Key("bottom_navbar"),
          currentIndex: navIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), title: Text("Search")),
          ],
          fixedColor: Colors.green,
          onTap: (index) {
            setState(() {
              navIndex = index;
            });
          },
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
