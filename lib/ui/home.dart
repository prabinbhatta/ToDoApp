import 'package:flutter/material.dart';
import 'package:todoapp/util/todoscreen.dart';

class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('To Do List')),
        backgroundColor: Colors.black54,
      ),
      body: ToDoScreen(
        
      ),
    );
  }
}