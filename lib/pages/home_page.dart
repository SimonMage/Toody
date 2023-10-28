import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// ignore: unused_import
import 'package:intl/intl.dart'; // Assicurati di aver importato la libreria Intl
import 'package:todolist/utilities/todo_tile.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/utilities/toDoDatabase.dart';
import 'package:shake/shake.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox=Hive.box("activities");
  toDoDatabase db=toDoDatabase();

  @override
  void initState() {
    //Prima apertura app o mancanza del database
    if (_myBox.get("activities") == null) {
      db.createData();
    } else {
      //Trovato database
      db.loadData();
    }

  super.initState();
  }
  
  DateTime selectedDate = DateTime.now();
  bool isDateSelected = false;

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = value ?? false;
      db.updateData();
    });
  }

  void onLongPressDetected() async {
    final TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aggiungi una nuova attività'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              Row(
                children: [
                  const Text('Data e Orario:'),
                  TextButton(
                    onPressed: () async {
                      final date = await DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            selectedDate = date;
                            isDateSelected = true;
                          });
                        },
                        currentTime: selectedDate,
                      );

                      if (date == null) {
                        setState(() {
                          selectedDate = DateTime.now();
                          isDateSelected = false;
                        });
                      }
                    },
                    child: Text(
                      isDateSelected
                          ? 'Modifica'
                          : 'Modifica',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                final String taskName = nameController.text;

                if (taskName.isNotEmpty) {
                  setState(() {
                    db.toDoList.add([taskName, false, selectedDate]);
                    db.updateData();
                  });

                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ShakeDetector detector = ShakeDetector.autoStart(
        onPhoneShake: () {
              for (var i = 0; i < db.toDoList.length; i++) {
                if (db.toDoList[i][1]==true) {
                  db.toDoList.remove(db.toDoList[i]);
                  i=i-1;
                }
              }
              db.updateData();
        }
    );
    return GestureDetector(
      onLongPress: onLongPressDetected,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Toody l\'App che ti farà ricordare te stesso'),
        ),
        backgroundColor: Colors.yellow[200],
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              taskDate: db.toDoList[index][2],
              onChanged: (value) => checkBoxChanged(value, index),
            );
          },
        ),
      ),
    );
  }
}