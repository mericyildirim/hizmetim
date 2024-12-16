import 'package:flutter/material.dart';

class NavigationMethod {
  static void navigate(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void pushReplacement(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static void goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
