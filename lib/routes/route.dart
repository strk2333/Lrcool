
import 'package:flutter/material.dart';
import '../view/search.dart';
import '../view/home.dart';
import '../view/lrc.dart';

class RouteManager {
  var routes = <String, WidgetBuilder> {
    "/lrc": (_) => LrcView("", ""),
  };

  var initialRoute = "/";
  var mainPages = [HomeView(), SearchView(), ];
  var kitPages = <String, WidgetBuilder> {
    "/lrc": (_) => LrcView("", ""),
  };

  static RouteManager _instance;

  factory RouteManager() {
    if (_instance == null) {
      _instance = RouteManager._internal();
    }
    return _instance;
  }

  RouteManager._internal() {

  }
}