import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:toody/pages/login_page.dart';
import 'package:toody/pages/tutorial_page.dart';
import 'package:toody/utilities/colors_var.dart';
import 'package:toody/utilities/notification_utilities.dart';
import 'package:toody/utilities/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';
import 'package:toody/utilities/overlay.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static int todayTask = 0; //numero di task di oggi fatte
  static int todayTaskToDo = 0; //numero di task da fare di oggi
  static int weekTask = 0; //numero di task della settimana fatte
  static int weekTaskToDo = 0; //numero di task da fare della settimana
  static int monthTask = 0; //numero di task del mese fatte
  static int monthTaskToDo = 0; //numero di task da fare del mese
  static late ShakeDetector detector;
  static bool signal=true;
  //static late OverlayEntry tutorialoverlay;

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

  //funzione che restuituisce la prima riga di una stringa se multilinea
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

  //restuisce true se sono stesso giorno
  static bool sameDay (DateTime? t1, DateTime t2){
    return t1!.year == t2.year && t1.month == t2.month && t1.day == t2.day;
  }

  //restituisce true se fanno parte della stessa settimana
  static bool sameWeek(DateTime? date1, DateTime date2) {
    // Calcola il numero della settimana dell'anno per entrambe le date
    int weekNumber1 = date1!.weekday == DateTime.sunday
      ? date1.difference(DateTime(date1.year, 1, 1)).inDays ~/ 7 + 1
      : date1.difference(DateTime(date1.year, 1, 1)).inDays ~/ 7;
    int weekNumber2 = date2.weekday == DateTime.sunday
      ? date2.difference(DateTime(date2.year, 1, 1)).inDays ~/ 7 + 1
      : date2.difference(DateTime(date2.year, 1, 1)).inDays ~/ 7;
  
    return weekNumber1 == weekNumber2;
  }

  //restituisce true se fanno parte dello stesso mese
  static bool sameMonth (DateTime? t1, DateTime t2){
    return t1!.year == t2.year && t1.month == t2.month;
  }

  static void countTask (){
   DateTime now = DateTime.now();
   int countDay = 0;
   int countDayToDo=0;
   int countWeek = 0;
   int countWeekToDo=0;
   int countMonth = 0;
   int countMonthToDo=0;
    for (var i = 0; i < ToDoDatabase.toDoListOgg.length; i++) {
      TileData data = ToDoDatabase.toDoListOgg[i]; //prendo la task

      if (data.taskCompletedData){ //se flaggata completata aggiorno i counter delle task fatte

        if (HomePage.sameDay(data.taskDateData, now)){
          countDay++;
          countWeek++;
          countMonth++;
        } else

        if (HomePage.sameWeek(data.taskDateData, now)) {
          countWeek++;
          countMonth++;
        } else

        if (HomePage.sameMonth(data.taskDateData, now)) {
          countMonth++;
        }
        

      } else { // se non flaggata completata aggiorno counter delle task da fare

        if (HomePage.sameDay(data.taskDateData, now)){
          countDayToDo++;
          countWeekToDo++;
          countMonthToDo++;
        } else

        if (HomePage.sameWeek(data.taskDateData, now)) {
          countWeekToDo++;
          countMonthToDo++;
        } else

        if (HomePage.sameMonth(data.taskDateData, now)) {
          countMonthToDo++;
        }

      }
      
    }
    HomePage.todayTask = countDay;  
    HomePage.todayTaskToDo = countDayToDo;
    HomePage.weekTask = countWeek;  
    HomePage.weekTaskToDo = countWeekToDo;
    HomePage.monthTask = countMonth;  
    HomePage.monthTaskToDo = countMonthToDo;
    debugPrint("oggi:$countDay oggiToDo:$countDayToDo");
    debugPrint("sett:$countWeek settToDo:$countWeekToDo");
    debugPrint("mese:$countMonth meseToDo:$countMonthToDo");
  }
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  late ShakeDetector detector;

  @override
  void initState() {
    //Prima apertura app o mancanza del database
    if (_myBox.get("TODO") != null || overlayTutorial.tutorial_mode) {
      //Trovato database
      db.loadData();
    }

    HomePage.countTask(); //inizializzi numero di task

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod
    );

    debugPrint("sto settando listern");
    HomePage.detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        if (HomePage.signal) {
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
            HomePage.countTask(); //aggiorni il numero di task di oggi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Attività svolte cancellate', style: TextStyle(color: ColorVar.textSuPrincipale)),
                backgroundColor: ColorVar.principale));
            //Vibration.vibrate(duration: 1000);
            Vibration.vibrate(pattern: [200, 300, 400], intensities: [200, 0, 100]);
          }
        });
        /*if (overlayTutorial.tutorial_mode) {
          overlayTutorial.removeTutorial(HomePage.tutorialoverlay);
          HomePage.tutorialoverlay=overlayTutorial.showTutorial(context, "Clicca sul titolo di una attività", MediaQuery.of(context).size.height * 0.20, 0);
          _HomePageRefresh();
        }*/
        }
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
      HomePage.countTask();
    });
  }

  //funzione che modifica la checkbox che aggiorna lei stessa i contatori delle task senza usare la funzione
  void checkboxTaskALternativa(bool? value, int index) {
    DateTime today = DateTime.now();
    DateTime data = ToDoDatabase.toDoListOgg[index].taskDateData;

    setState(() {
      ToDoDatabase.toDoListOgg[index].taskCompletedData = value!;
      if (data.year == today.year && data.month == today.month && data.day == today.day) {
        if (value ){
          debugPrint("diminuisco task da fare di oggi");
          HomePage.todayTaskToDo--;
        }else {
          debugPrint("aumento task da fare di oggi");
          HomePage.todayTaskToDo++;
        }
      }
        debugPrint('$value');

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

//Funzione necessaria per aggiornare la pagina quando l'utente torna indietro
  void _loadDataHomePage() {
      setState(() {
      db.loadData();
    });
  }
  
//Funzione necessaria per aggiornare la pagina
  void homePageRefresh() {
      setState(() {
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
            color: ColorVar.background,
            child: Text("Aggiungi una nuova attività", style: TextStyle(color: ColorVar.principale, fontSize: 21))
          ),
          scrollable: true, //alertdialog se non c'entra nello schermo scrollabile
          backgroundColor: ColorVar.background,
          shadowColor: ColorVar.taskBasic, //colore ombra
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))), //bordi tondi
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                maxLength: 15, //limite lunghezza titolo
                cursorColor: ColorVar.principale,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: ColorVar.principale),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.textBasic)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.principale))
                )
              ),
              TextField(
                controller: descrController,
                maxLength: 100, //limite lunghezza descrizione
                cursorColor: ColorVar.principale,
                maxLines: 3,  //massima altezza che prende il textfield
                minLines: 1,  //minima altezza che prende il tetxfield
                onChanged: (text) { //chiama la funzione per non far digitare piu di un tot di righe
                  HomePage.limitLines(text, 12, descrController);
                },
                keyboardType: TextInputType.multiline, //appare la tastiera non con invio ma con rimando a capo
                decoration: InputDecoration(
                  labelText: 'Descrizione',
                  labelStyle: TextStyle(color: ColorVar.principale),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.textBasic)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.principale))
                )
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
                    child: Text(isDateSelected ? 'Modifica' : 'Modifica', style: TextStyle(color: ColorVar.principale))
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
                  HomePage.countTask(); //aggiorni il numero di task di oggi
                  NotificationUtilities.creaNotifica(nome: taskName, descrizione: HomePage.abbreviaStringa(descr, 100), quando: selectedDate, idNotif: idNotifica);  //crea notifica associata
                  Navigator.pop(context);
                  selectedDate =DateTime.now();
                }
               /* if (overlayTutorial.tutorial_mode) {
                  overlayTutorial.removeTutorial(HomePage.tutorialoverlay);
                  HomePage.tutorialoverlay=overlayTutorial.showTutorial(context, "Scuoti per cancellare le attività svolte", MediaQuery.of(context).size.height * 0.20, 0);
                  _HomePageRefresh();
                }*/
              },
              style: TextButton.styleFrom(foregroundColor: ColorVar.principale),
              child: const Text('Aggiungi'),
            )
          ]
        );
      }
    );
  }

/*
void Function()? tutorial() {
  if (overlayTutorial.tutorial_mode && overlayTutorial.tutorial_message_active) {
    if (overlayTutorial.removeTutorial!= null) {
      overlayTutorial.removeTutorial(HomePage.tutorialoverlay);
    }
    HomePage.tutorialoverlay=overlayTutorial.showTutorial(context, "Clicca su modifica per selezionare la data e l'ora", , MediaQuery.of(context).size.height * 0.20, 0);
    _HomePageRefresh();
  }
  return onLongPressDetected;
}
*/

void Function()? tutorial() {
  return onLongPressDetected;
}

  @override
  Widget build(BuildContext context) {
    /*if (overlayTutorial.tutorial_mode && !overlayTutorial.tutorial_message_active) {
      overlayTutorial.tutorial_message_active=true;
      Future.delayed(Duration.zero,(){
        HomePage.tutorialoverlay=overlayTutorial.showTutorial(context, "Crea attività tenendo premuto", MediaQuery.of(context).size.height * 0.20, 0);
      });
    }*/
    return GestureDetector(
      onLongPress: tutorial(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('TooDy', style: TextStyle(fontSize: 20, color: ColorVar.principale, fontWeight: FontWeight.w500))
            ]
          ),
          
  
          actions: [
            IconButton( //bottone setting
                iconSize: 30,
                icon: const Icon(Icons.info_outline), //per icone https://fonts.google.com/icons?icon.platform=flutter
                onPressed: () {
                     Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TutorialPage(loadDataHomePage: _loadDataHomePage)));
                },
                color: ColorVar.principale,
              ),
              IconButton( //bottone setting
                iconSize: 30,
                icon: const Icon(Icons.login), //per icone https://fonts.google.com/icons?icon.platform=flutter
                onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage(homePageRefresh: homePageRefresh))).then((_) async {
                        await db.loadData();
                        await db.updateData();
                        HomePage.countTask();
                        homePageRefresh();
                      });
                },
                color: ColorVar.principale,
              ),

          ]
        ),
        backgroundColor: ColorVar.background, //colore background principale
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
            : ListView.separated(
                itemCount: ToDoDatabase.toDoListOgg.length,
                padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 20), //spazio tra bordo schermo e inizio task
                separatorBuilder: (context, index) => const SizedBox(height: 15), //separatore tra una tile e l'altra
                itemBuilder: (context, index) {
                  return ToDoTile(index: index, onChanged: (value) => checkboxTask(value, index), loadDataHomePage: _loadDataHomePage);
                }
              )
      )
    );
  }
}

