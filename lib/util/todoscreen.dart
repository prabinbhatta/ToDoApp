import 'package:flutter/material.dart';
import 'package:todoapp/model/todo_item.dart';
import 'package:todoapp/util/database_client.dart';
import 'package:todoapp/util/date_formatter.dart';

class ToDoScreen extends StatefulWidget {
  ToDoScreen({Key key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];

  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }
  void _handleSubmitted(String text) async {
     _textEditingController.clear();
     
     ToDoItem noDoItem = ToDoItem(text, dateFormatted());
     int savedItemId = await db.saveItem(noDoItem);

     ToDoItem addedItem = await db.getItem(savedItemId);

     setState(() {
        _itemList.insert(0, addedItem);

     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
          children: <Widget>[
             Flexible(
                 child: ListView.builder(
                     padding: EdgeInsets.all(8.0),
                     reverse: false,
                     itemCount: _itemList.length,
                     itemBuilder: (_, int index) {
                         return Card(
                            color: Colors.white10,
                            child: ListTile(
                               title: _itemList[index],
                              onLongPress: () => _udateItem(_itemList[index], index),
                              trailing: Listener(
                                 key: Key(_itemList[index].itemName),
                                 child:  Icon(Icons.remove_circle,
                                 color: Colors.redAccent,),
                                 onPointerDown: (pointerEvent) =>
                                    _deleteNoDo(_itemList[index].id, index),
                              ),
                            ),
                         );

                     }),
             ),

            Divider(
              height: 1.0,
            )
          ],
      ),


      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: ListTile(
             title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
        content: Row(
          children: <Widget>[
             Expanded(
                 child: TextField(
                    controller: _textEditingController,
                    autofocus: true,
                    decoration: InputDecoration(
                       labelText: "Item",
                       hintText: "eg. Buy stuff",
                       icon: Icon(Icons.note_add)
                    ),
                 ))
          ],
        ),
      actions: <Widget>[
          FlatButton(
              onPressed: () {
                _handleSubmitted(_textEditingController.text);
                 _textEditingController.clear();
                 Navigator.pop(context);
              },
              child: Text("Save")),
         FlatButton(onPressed: () => Navigator.pop(context),
             child: Text("Cancel"))

      ],
    );
    showDialog(context: context,
        builder:(_) {
           return alert;

        });
  }

  _readNoDoList() async {
     List items = await db.getItems();
      items.forEach((item) {
        setState(() {
            _itemList.add(ToDoItem.map(item));
        });
      });

  }

  _deleteNoDo(int id, int index) async {

      await db.deleteItem(id);
      setState(() {
         _itemList.removeAt(index);
      });


  }

  _udateItem(ToDoItem item, int index) {
    var alert = AlertDialog(
       title: Text("Update Item"),
      content: Row(
         children: <Widget>[
            Expanded(
                child: TextField(
                   controller: _textEditingController,
                   autofocus: true,
                  decoration: InputDecoration(
                     labelText:  "Item",
                     hintText: "eg. Buy stuff",
                    icon: Icon(Icons.update)),
                ))
         ],
      ),
      actions: <Widget>[
         FlatButton(
             onPressed: () async {
               ToDoItem newItemUpdated = ToDoItem.fromMap(
                   {"itemName": _textEditingController.text,
                     "dateCreated" : dateFormatted(),
                     "id" : item.id
                   });

                _handleSubmittedUpdate(index, item);//redrawing the screen
                await db.updateItem(newItemUpdated); //updating the item
                setState(() {
                   _readNoDoList(); // redrawing the screen with all items saved in the db
                });

                Navigator.pop(context);

             },
             child: Text("Update")),
        FlatButton(onPressed: () => Navigator.pop(context),
            child: Text("Cancel"))
      ],
    );
    showDialog(context:
    context ,builder: (_) {
       return alert;
    });



  }

  void _handleSubmittedUpdate(int index, ToDoItem item) {
     setState(() {
       _textEditingController.clear();
        _itemList.removeWhere((element) {
           _itemList[index].itemName == item.itemName;
        });

     });
  }
}
