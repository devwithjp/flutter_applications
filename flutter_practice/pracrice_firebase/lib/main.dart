import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pracrice_firebase/board.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creative Column',
      theme: ThemeData(
        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.white
      ),
      home: MyHomePage(title: 'Creative column'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Board> boardMessages = List();
  Board board;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    board = Board("", "");
    databaseReference = database.reference().child("creative_column");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 0,
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.subject),
                          title: TextFormField(
                            initialValue: "",
                            onSaved: (val) => board.subject = val,
                            validator: (val) => val == "" ? val : null,
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.message),
                          title: TextFormField(
                            initialValue: "",
                            onSaved: (val) => board.body = val,
                            validator: (val) => val == "" ? val : null,
                          ),
                        ),
                        FlatButton(
                          child: Text("Post"),
                          onPressed: () {
                            debugPrint("clicked");
                            handleSubmit();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
                Flexible(
                  child: FirebaseAnimatedList(
                    query: databaseReference,
                    itemBuilder: (_,DataSnapshot snapshot,Animation<double> animation, int index){
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.crop_landscape),
                          title: Text(boardMessages[index].subject),
                          subtitle:Text(boardMessages[index].body) ,
                        ),
                      );
                    },
                  ),
                ),
              
            ],
          ),
        );
      }
    
      void _onEntryAdded(Event event) {
        setState(() {
          boardMessages.add(Board.fromSnapshot(event.snapshot));
        });
      }
    
      void handleSubmit() {
        final FormState form = formKey.currentState;
        if (form.validate()) {
          form.save();
          form.reset();
          databaseReference.push().set(board.toJson());
        }
      }
    
      void _onEntryChanged(Event event) {
        var oldEntry = boardMessages.singleWhere((entry){
          return entry.key == event.snapshot.key;
        });
        setState(() {
          boardMessages[boardMessages.indexOf(oldEntry)] = Board.fromSnapshot(event.snapshot);
        });
  }
}
