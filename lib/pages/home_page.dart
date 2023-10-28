import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// ignore: unused_import
import 'package:intl/intl.dart'; // Assicurati di aver importato la libreria Intl
import 'package:todolist/utilities/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> toDoList = [];
  DateTime selectedDate = DateTime.now();
  bool isDateSelected = false;

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = value ?? false;
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
                    toDoList.add([taskName, false, selectedDate]);
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
    return GestureDetector(
      onLongPress: onLongPressDetected,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Toody l\'App che ti farà ricordare te stesso'),
        ),
        backgroundColor: Colors.yellow[200],
        body: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: toDoList[index][0],
              taskCompleted: toDoList[index][1],
              taskDate: toDoList[index][2],
              onChanged: (value) => checkBoxChanged(value, index),
            );
          },
        ),
      ),
    );
  }
}
