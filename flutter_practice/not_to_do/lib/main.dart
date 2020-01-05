import 'package:flutter/material.dart';
import 'package:not_to_do/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(primaryColor: Colors.black, dialogBackgroundColor: Colors.black, secondaryHeaderColor: Colors.red),
      debugShowCheckedModeBanner: false,
      title: 'Not To Do',
      home: new Home(),
    );
  }
}