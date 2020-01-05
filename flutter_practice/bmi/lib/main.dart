import 'package:flutter/material.dart';
import 'package:bmi/home.dart';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.purpleAccent,
    ),
     title: 'BMI',
    home: new Bmi(),
  ));
}