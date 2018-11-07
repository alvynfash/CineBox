import 'package:cinebox/ui/homeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'CineBox',
      theme: getAppTheme(),
      home: HomeScreen(),
      color: Colors.black,
    ),
  );
}

ThemeData getAppTheme() {
  return ThemeData.light().copyWith(
    primaryColor: Color.fromARGB(255, 214, 11, 65),
    primaryColorDark: Colors.red[300],
    primaryColorLight: Colors.red[200],
    primaryTextTheme: ThemeData.light()
        .primaryTextTheme
        .copyWith(title: TextStyle(color: Colors.white)),
  );
}
