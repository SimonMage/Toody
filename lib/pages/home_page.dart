import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:toody/utilities/notification_utilities.dart';
import 'package:toody/utilities/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static int todayTask = 0; //numero di task di oggi
  static int todayTaskToDo = 0; //numero di task da fare di oggi
  static int todayTaskDone = 0; //numero di task totale
  static late ShakeDetector detector;

  @override
  State<HomePage> createState() => _HomePageState();

  //funzione che data una stringa la riduce alla lunghezzamassima voluta
  static String abbreviaStringa(String input, int lunghezzaMassima) {
    if (input.length <= lunghezzaMassima) {
      return input;
    } else {
      return '${input.substring(0, lunghezzaMassima)}...';
    }
  }

  static String primaRiga(String input) {
    int indiceRitornoACapo = input.indexOf('\n');

    if (indiceRitornoACapo != -1) {
      return "${input.substring(0, indiceRitornoACapo)}..."; //se c'e un ritorno a capo ritorni la prima riga
    } else {
      return input; ////se non c'e un ritorno a capo ritorni la stringa originale
    }
  }

  //elimina tutti i ritorni a capo
  static String rimuoviRitorniACapo(String input) {
    return input.replaceAll('\n', '');
  }

  //gestisce il TextEditingController per non fargli digitare piu di un numero di righe
  static void limitLines(String text, int maxLines, TextEditingController textController)  {
    var lines = text.split('\n');
    if (lines.length > maxLines) {
      lines.removeRange(maxLines, lines.length);
      textController.text = lines.join('\n');
    }
  }
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  late ShakeDetector detector;


  //conta il numero di attivita del giorno corrente
  void taskToday (){
   DateTime today = DateTime.now();
   int countToDo=0;
   int countDone=0;
    for (var i = 0; i < ToDoDatabase.toDoListOgg.length; i++) {
      DateTime data = ToDoDatabase.toDoListOgg[i].taskDateData;
      if (data.year == today.year && data.month == today.month && data.day == today.day) {
        if (ToDoDatabase.toDoListOgg[i].taskCompletedData){
          countDone++;
        }
        else {
          countToDo++;
        }
      }
    }
    HomePage.todayTask = countToDo+countDone;  
    HomePage.todayTaskToDo = countToDo;
    HomePage.todayTaskDone = countDone;
  }


  @override
  void initState() {
    //Prima apertura app o mancanza del database
    if (_myBox.get("TODO") != null) {
      //Trovato database
      db.loadData();
    }

    taskToday(); //inizializzi numero di task di oggi


    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod
      );

      debugPrint("sto settando listern");
      HomePage.detector = ShakeDetector.autoStart(
      onPhoneShake: () {

        setState(() {
          bool hasCompletedTask = ToDoDatabase.toDoListOgg.any((task) => task.taskCompletedData == true);
          if (hasCompletedTask) {
            for (var i = 0; i < ToDoDatabase.toDoListOgg.length; i++) {
              if (ToDoDatabase.toDoListOgg[i].taskCompletedData== true) {
                debugPrint("idNotif cancellata ${ToDoDatabase.toDoListOgg[i].idNotifify}");
                NotificationUtilities.cancellaNotifica(idNotif: ToDoDatabase.toDoListOgg[i].idNotifify); //cancella notifica di quella task
                ToDoDatabase.toDoListOgg.remove(ToDoDatabase.toDoListOgg[i]);
                i = i - 1;
              }
            }
            db.updateData();
            taskToday(); //aggiorni il numero di task di oggi
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
      ToDoDatabase.toDoListOgg[index].taskCompletedData = value!;
      db.updateData();
    });
  }
  
//funzione per cambiare valore checkbox della notifica
  void checkboxNotif(bool? value, int index) {
    setState(() {
      ToDoDatabase.toDoListOgg[index].checkboxNotif = value!;
      db.updateData();
    });
  }

  void _loadDataHomePage() {
      setState(() {
      db.loadData();
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
              color: const Color(0xFFFFF59D),
              child: const Text("Aggiungi una nuova attività", style: TextStyle(color: Color(0xFF1976D2), fontSize: 21))
              ),
          scrollable: true, //alertdialog se non c'entra nello schermo scrollabile
          backgroundColor: const Color(0xFFFFF59D),
          shadowColor: Colors.yellow,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))), //bordi tondi
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                maxLength: 15, //limite lunghezza titolo
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Color(0xFF1976D2)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)))
              ),
              TextField(
                controller: descrController,
                maxLength: 100, //limite lunghezza descrizione
                cursorColor: Colors.blue,
                maxLines: 3,  //massima altezza che prende il textfield
                minLines: 1,  //minima altezza che prende il tetxfield
                onChanged: (text) { //chiama la funzione per non far digitare piu di un tot di righe
                  HomePage.limitLines(text, 12, descrController);
                },
                keyboardType: TextInputType.multiline, //appare la tastiera non con invio ma con rimando a capo
                decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    labelStyle: TextStyle(color: Color(0xFF1976D2)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)))
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
                  TextButton(
                    onPressed: () async {
                    },
                    child: Text('Seleziona icona', style: const TextStyle(color: Colors.blue)),
                  )
                ],
              ),
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
              onPressed: () async {
                final String taskName = nameController.text;
                final String descr = descrController.text;
                int idNotifica = Random().nextInt(1000000) + 1; //genera identificatore casuale per la notifica
                if (taskName.isNotEmpty) {
                  setState(() {
                    TileData nuova = TileData(taskNameData: taskName, taskCompletedData: false, descrData: descr, taskDateData: selectedDate, idNotifify: idNotifica, notifSoundData: "test", notifActiveData: notifActive);
                    ToDoDatabase.toDoListOgg.add(nuova);
                    debugPrint (nuova.toString());
                    debugPrint("\nelementi ${ToDoDatabase.toDoListOgg.length}");
                    db.updateData();
                  });
                taskToday(); //aggiorni il numero di task di oggi
                NotificationUtilities.creaNotifica(nome: taskName, descrizione: HomePage.abbreviaStringa(descr, 100), quando: selectedDate, idNotif: idNotifica);  //crea notifica associata
                Navigator.pop(context);
                selectedDate =DateTime.now();
                }
              },
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF1976D2)),
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
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('TooDy', style: TextStyle(fontSize: 20, color: Color(0xFF1976D2)))
            ],
          ),

  
          /*actions: [
            IconButton( //bottone setting
                iconSize: 30,
                icon: const Icon(Icons.account_circle), //per icone https://fonts.google.com/icons?icon.platform=flutter
                onPressed: () {
                     Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AuthPage()));
                },
                color: Colors.blue[700],
              )
          ]*/
        ),
        backgroundColor: const Color(0xFFFFF59D), //colore background principale
        body: ToDoDatabase.toDoListOgg.isEmpty
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
                itemCount: ToDoDatabase.toDoListOgg.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    index: index,
                    onChanged: (value) => checkboxTask(value, index),
                    loadDataHomePage: _loadDataHomePage,
                  );
                }
              )
      )
    );
  }
}

