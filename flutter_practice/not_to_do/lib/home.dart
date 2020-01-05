import 'package:flutter/material.dart';
import 'package:not_to_do/notodo_Screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
       appBar: new AppBar(
         title: Text("Not To Do",style: TextStyle(color: Colors.red),),centerTitle: true,
         backgroundColor: Colors.black,
       ),
      body: new NotoDoScreen(),
    );
  }
}
