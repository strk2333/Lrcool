import 'package:flutter/material.dart';
import 'routes/route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routeManager = RouteManager();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: routeManager.routes,
      initialRoute: routeManager.initialRoute,
      // home: Text("???"),
    );
  }
}