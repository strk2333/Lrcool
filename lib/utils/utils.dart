import 'package:flutter/material.dart';
class Utils {
  static Size getDeviceSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}