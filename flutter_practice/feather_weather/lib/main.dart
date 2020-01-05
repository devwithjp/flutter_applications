import 'package:flutter/material.dart';
import 'package:feather_weather/weather.dart';

void main() {
   runApp(
      new MaterialApp(
        theme: ThemeData(primaryColor: Colors.black),
         title: 'Feather Weather',
         home: new Home(),
      )
   );
}