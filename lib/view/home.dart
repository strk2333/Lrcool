import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: Text("Search"),
          onPressed: () => Navigator.pushNamed(context, "/search"),
        ),
      ),
    );
  }
}
