import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// ignore: unused_import
import 'package:intl/intl.dart'; // Assicurati di aver importato la libreria Intl
import 'package:toody/utilities/todo_tile.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:shake/shake.dart';

import 'package:toody/pages/settings_page.dart';

import 'package:vibration/vibration.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    //Prima apertura app o mancanza del database
    if (_myBox.get("TODO") != null) {
      //Trovato database
      db.loadData();
    }

    super.initState();
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          bool hasCompletedTask = db.toDoList.any((task) => task[1] == true);
          if (hasCompletedTask) {
            for (var i = 0; i < db.toDoList.length; i++) {
              if (db.toDoList[i][1] == true) {
                db.toDoList.remove(db.toDoList[i]);
                i = i - 1;
              }
            }
            db.updateData();
            ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Attività svolte cancellate',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 0, 9, 135),
          ),
        );
        //Vibration.vibrate(duration: 1000);
        Vibration.vibrate(
          pattern: [200, 300, 400],
          intensities: [200, 0, 100],
        );
          }
        });
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 1.7,
    );

    // To close: detector.stopListening();
    // ShakeDetector.waitForStart() waits for user to call detector.startListening();

    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  bool isDateSelected = false;

  void checkBoxChanged(bool? value, int index, int checkbox) {
    setState(() {
      db.toDoList[index][checkbox] = value! ?? false;
      db.updateData();
    });
  }

  void onLongPressDetected() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descrController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        bool notifActive = true;
        return AlertDialog(
          title: Container(
              color: Colors.yellow[200],
              child: Text("Aggiungi una nuova attività",
                  style: TextStyle(color: Colors.blue[700], fontSize: 21))),
          scrollable: true,
          backgroundColor: Colors.yellow[200],
          shadowColor: Colors.yellow,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                //Limite lunghezza nome dell'attività
                maxLength: 15,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
              TextField(
                controller: descrController,
                //Limite lunghezza nome dell'attività
                maxLength: 20,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    labelText: 'Descrizione',
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
              Row(
                children: [
                  const Text('Data e Orario:'),
                  TextButton(
                    onPressed: () async {
                      final date = await DatePicker.showDateTimePicker(
                        locale: LocaleType.it,
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
                      isDateSelected ? 'Modifica' : 'Modifica',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: notifActive,
                        //onChanged: onChanged1,
                        onChanged: (bool? value) {
                          setState(() {
                            print("Changing");
                            print(value);
                            notifActive = value ?? false;
                          });
                        },
                        checkColor: Colors.blue[700],
                        activeColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        side: MaterialStateBorderSide.resolveWith((states) =>
                            BorderSide(
                                width: 2.0,
                                color: Colors.blue[700] ?? Colors.blue)),
                      )),
                  Text("Notifica"),
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
                final String descr = descrController.text;
                if (taskName.isNotEmpty) {
                  setState(() {
                    db.toDoList.add([
                      taskName,
                      false,
                      selectedDate,
                      descr,
                      notifActive,
                      "test"
                    ]);
                    db.updateData();
                  });

                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue[700]),
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    return GestureDetector(
      onLongPress: onLongPressDetected,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('TooDy ● Il tuo promemoria tascabile',
                  style: TextStyle(fontSize: 20, color: Colors.blue[700])),
              const SizedBox(width: 7),
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => settings_page()));
                },
                color: Colors.blue[700],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.yellow[200],
        body: db.toDoList.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nessuna attività creata',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'Tocca e tieni premuto per aggiungere una nuova attività.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: db.toDoList.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    taskName: db.toDoList[index][0],
                    taskCompleted: db.toDoList[index][1],
                    taskDate: db.toDoList[index][2],
                    onChanged: (value) => checkBoxChanged(value, index, 1),
                    descr: db.toDoList[index][3],
                    notifActive: db.toDoList[index][4],
                    notifSound: db.toDoList[index][5],
                    onChanged1: (value) => checkBoxChanged(value, index, 4),
                  );
                },
              ),
      ),
    );
  }
}
