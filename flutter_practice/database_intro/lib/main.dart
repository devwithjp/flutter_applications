import 'package:database_intro/user.dart';
import 'package:database_intro/database_helper.dart';
import 'package:flutter/material.dart';


List _users;

void main() async {
  var db = new DatabaseHelper();

   await db.saveUser(new User("Genyy", "musician"));

  int count = await db.getCount();
  print("Count: $count");

  User ana = await db.getUser(1);
  User anaUpdated = User.fromMap({
    "username": "UpdatedAna",
    "password" : "updatedPassword",
    "id"       : 1
  });


  await
  db.updateUser(anaUpdated);


  _users = await db.getAllUsers();
  for (int i = 0; i < _users.length; i++) {
    User user = User.map(_users[i]);

    print("Username: ${user.username }, User Id: ${user.id}");
  }


  runApp(new MaterialApp(
    title: "Database",
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Database"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
       body: new ListView.builder(
           itemCount: _users.length,
           itemBuilder: (_, int position) {
              return new Card(
                 color: Colors.white,
                 elevation: 2.0,
                 child: new ListTile(
                   leading: new CircleAvatar(
                      child:  Text("${User.fromMap(_users[position]).username.substring(0, 1)}"),
                   ),
                    title: new Text("User: ${User.fromMap(_users[position]).username}"),
                   subtitle: new Text("Id: ${User.fromMap(_users[position]).id}"),

                   onTap: () => debugPrint("${User.fromMap(_users[position]).password}"),
                 ),
              );


           }),
    );
  }
}
