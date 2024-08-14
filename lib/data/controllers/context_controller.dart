import "package:flutter/material.dart";

class ContextController {
  ContextController._();

  static double getWidthScreen(context) {
    return MediaQuery.of(context).size.width;
  }
  static double getHeightScreen(context) {
    return MediaQuery.of(context).size.width;
  }
}
