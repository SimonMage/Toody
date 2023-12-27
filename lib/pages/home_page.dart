import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
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
    ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          bool hasCompletedTask = db.toDoListOgg.any((task) => task.taskCompletedData == true);
          if (hasCompletedTask) {
            for (var i = 0; i < db.toDoListOgg.length; i++) {
              if (db.toDoListOgg[i].taskCompletedData== true) {
                db.toDoListOgg.remove(db.toDoListOgg[i]);
                i = i - 1;
              }
            }
            db.updateData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Attività svolte cancellate', style: TextStyle(color: Colors.white)),
                backgroundColor: Color.fromRGBO(25, 118, 210, 1)));
            //Vibration.vibrate(duration: 1000);
            Vibration.vibrate(pattern: [200, 300, 400], intensities: [200, 0, 100]);
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

//funzione per cambiare valore checkbox della task
  void checkboxTask(bool? value, int index) {
    setState(() {
      db.toDoListOgg[index].taskCompletedData = value!;
      db.updateData();
    });
  }
  
//funzione per cambiare valore checkbox della notifica
  void checkboxNotif(bool? value, int index) {
    setState(() {
      db.toDoListOgg[index].checkboxNotif = value!;
      db.updateData();
    });
  }


  //funzione che data una strina la riduce alla lunghezzamassima voluta
  String abbreviaStringa(String input, int lunghezzaMassima) {
    if (input.length <= lunghezzaMassima) {
      return input;
    } else {
      return '${input.substring(0, lunghezzaMassima)}...';
    }
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
          scrollable: true, //alertdialog se non c'entra nello schermo scrollabile
          backgroundColor: Colors.yellow[200],
          shadowColor: Colors.yellow,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))), //bordi tondi
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                maxLength: 15, //limite lunghezza titolo
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)))
              ),
              TextField(
                controller: descrController,
                maxLength: 100, //limite lunghezza descrizione
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    labelText: 'Descrizione',
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)))
              ),
              Row(
                children: [
                  const Text('Data e Orario:'),
                  TextButton(
                    onPressed: () async {
                      final date = await DatePicker.showDateTimePicker(
                        locale: LocaleType.it, //italiano
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            selectedDate = date;
                            isDateSelected = true;
                          });
                        },
                        currentTime: selectedDate
                      );

                      if (date == null) {
                        setState(() {
                          selectedDate = DateTime.now();
                          isDateSelected = false;
                        });
                      }
                    },
                    child: Text(isDateSelected ? 'Modifica' : 'Modifica', style: const TextStyle(color: Colors.blue))
                  )
                ]
              ),
              Row(
                children: [
                  const Text("Notifica"),
                  Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: notifActive,
                        //onChanged: onChanged1,
                        onChanged: (bool? value) {
                          setState(() {
                           // print("Changing");
                            //print(value);
                            notifActive = value ?? false;
                          });
                        },
                        checkColor: Colors.blue[700], //colore spunta
                        activeColor: Colors.yellow[200],  //colore interno checkbox
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)), //bordi tondi
                        side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 2.0, color: Colors.blue[700] ?? Colors.blue))
                      )
                  )
                ]
              )
            ]
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
                    TileData nuova = TileData(taskNameData: taskName, taskCompletedData: false, descrData: descr, taskDateData: selectedDate, notifSoundData: "test", notifActiveData: notifActive);
                    db.toDoListOgg.add(nuova);
                    debugPrint (nuova.toString());
                    debugPrint("\nelementi ${db.toDoListOgg.length}");
                    db.updateData();
                  });
                  Navigator.pop(context);
                  selectedDate =DateTime.now();
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue[700]),
              child: const Text('Aggiungi'),
            )
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPressDetected,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('TooDy ● Il tuo promemoria tascabile', style: TextStyle(fontSize: 20, color: Colors.blue[700]))
            ],
          ),
          actions: [
             IconButton( //bottone setting
                iconSize: 30,
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SettingsPage()));
                },
                color: Colors.blue[700],
              )
          ]
        ),
        backgroundColor: Colors.yellow[200], //colore background principale
        body: db.toDoListOgg.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Nessuna attività creata', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text('Tieni premuto per aggiungere una nuova attività', style: TextStyle(fontSize: 14, color: Colors.grey))
                  ]
                )
              )
            : ListView.builder(
                itemCount: db.toDoListOgg.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    taskName: db.toDoListOgg[index].taskNameData,
                    taskCompleted: db.toDoListOgg[index].taskCompletedData,
                    taskDate: db.toDoListOgg[index].taskDateData,
                    onChanged: (value) => checkboxTask(value, index),
                    descr: db.toDoListOgg[index].descrData,
                    notifActive: db.toDoListOgg[index].notifActiveData,
                    notifSound: db.toDoListOgg[index].notifSoundData,
                    onChanged1: (value) => checkboxNotif(value, index),
                  );
                }
              )
      )
    );
  }
}
