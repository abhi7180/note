import 'package:flutter/material.dart';
import 'package:note/second_view_notes.dart';
import 'package:note/view_notes.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xffdfe4ea),
      backgroundColor: Color(0xffffffff),
      cardColor: Colors.black,
        dividerColor: Colors.black38,

    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
        primaryColor: Color(0xff485460),
        backgroundColor: Color(0xff1e272e),
        cardColor: Colors.white,
      dividerColor: Colors.white54,





    ),
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    home: second_view_notes(),));
}
