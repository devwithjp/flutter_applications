import 'package:flutter/material.dart';
import 'package:not_to_do/model/nodo_item.dart';
import 'package:not_to_do/util/database_client.dart';
import 'package:not_to_do/util/date_formatter.dart';

class NotoDoScreen extends StatefulWidget {
  @override
  _NotoDoScreenState createState() => new _NotoDoScreenState();
}

class _NotoDoScreenState extends State<NotoDoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = new DatabaseHelper();
  final List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    NoDoItem noDoItem = new NoDoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(noDoItem);
    NoDoItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });

    print("Item saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return new Card(
                    color: Colors.white10,
                    child: new ListTile(
                      title: _itemList[index]                       ,
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: new Text("Don't do this!",
                                  style: TextStyle(color: Colors.red, fontSize: 15)),
                              content: Text("${_itemList[index].itemName}",
                                  style: TextStyle(color: Colors.white)),
                              actions: <Widget>[
                                new FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: new Text("Return",
                                        style: TextStyle(color: Colors.red)))
                              ],
                            );
                          }),
                      onLongPress: () => _updateItem(_itemList[index], index),
                      trailing: new Listener(
                        key: new Key(_itemList[index].itemName),
                        child: new Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPointerDown: (pointerEvent) =>
                            _deleteNoDo(_itemList[index].id, index),
                      ),
                    ),
                  );
                }),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      title: Text("Add Item", style: TextStyle(color: Colors.red, fontSize: 15)),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            style: TextStyle(color: Colors.white),
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Item:",
                labelStyle: TextStyle(color: Colors.red),
                hintText: "eg. Don't buy stuff",
                hintStyle: TextStyle(color: Colors.red, fontSize: 10),
                icon: new Icon(
                  Icons.note_add,
                  color: Colors.red,
                )),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.red),
            )),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.red)))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(NoDoItem item, int index) {
    var alert = new AlertDialog(
      title: new Text(
        "Update Item",
        style: TextStyle(color: Colors.red, fontSize: 15),
      ),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            style: TextStyle(color: Colors.white),
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Item",
                labelStyle: TextStyle(color: Colors.red),
                hintText: "eg. Don't buy stuff",
                hintStyle: TextStyle(color: Colors.red),
                icon: new Icon(
                  Icons.update,
                  color: Colors.red,
                )),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              NoDoItem newItemUpdated = NoDoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatted(),
                "id": item.id
              });

              _handleSubmittedUpdate(index, item);
              await db.updateItem(newItemUpdated);
              setState(() {
                _readNoDoList();
              });

              Navigator.pop(context);
            },
            child: new Text("Update", style: TextStyle(color: Colors.red))),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text("Cancel", style: TextStyle(color: Colors.red)))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
    });
  }
}
