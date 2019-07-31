import 'package:cinebox/ui/homeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineBox',
      theme: _getAppTheme(),
      home: HomeScreen(),

      // home: new Container(),
    ),
  );
}

ThemeData _getAppTheme() {
  return ThemeData.light().copyWith(
    // primaryColor: Color.fromARGB(255, 214, 11, 65),
    primaryColor: Colors.blue,
    primaryColorDark: Colors.red[300],
    primaryColorLight: Colors.red[200],
    primaryTextTheme: ThemeData.light()
        .primaryTextTheme
        .copyWith(title: TextStyle(color: Colors.white)),
  );
}
