import 'package:flutter/material.dart';
import 'package:ledcolorfirebase/Home.dart';

var themePrimary = ThemeData(fontFamily: 'Quicksand');

void main() => runApp(MaterialApp(
    theme: themePrimary, debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
