import 'package:flutter/material.dart';
class ColorIndex {
  static final Map<MColor, Color> data = {
    MColor.primary: Color.fromARGB(255, 81, 29, 90),
    MColor.black: Color.fromARGB(255, 255, 255, 255),
    MColor.white: Color.fromARGB(0, 0, 0, 0),
    MColor.red: Color.fromARGB(255, 255, 0, 0),
    MColor.green: Color.fromARGB(255, 0, 255, 0), 
    MColor.blue: Color.fromARGB(255, 0, 0, 255), 
    // MColor.blue: Color.fromARGB(255, 0, 0, 255), 

  };
}

enum MColor {
  primary,
  yellow,
  green,
  blue,
  red,
  purple,
  black,
  white,
  lightgrey,
  grey,
  orange,
}
