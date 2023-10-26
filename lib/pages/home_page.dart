import 'package:flutter/material.dart';
import 'package:todolist/utilities/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List toDoList = [
    ["Test", false, DateTime.now()],
    ["Test 1", false, DateTime.now()],
    ["Simone", true, DateTime.now()],
  ];

  //Checkbox cliccato
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(),
      body: ListView.builder( 
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: toDoList[index][0], 
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            taskDate: toDoList[index][2],
          );
          },
      ),
    );
  }
}