import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        setState(() {
          if (overlayTutorial.step==1 || !overlayTutorial.tutorial_mode) {
            bool hasCompletedTask = ToDoDatabase.toDoListOgg.any((task) => task.taskCompletedData == true);
            if (hasCompletedTask) {
              for (var i = 0; i < ToDoDatabase.toDoListOgg.length; i++) {
                if (ToDoDatabase.toDoListOgg[i].taskCompletedData== true) {
                  debugPrint("idNotif cancellata ${ToDoDatabase.toDoListOgg[i].idNotifify}");
                  if (!overlayTutorial.tutorial_mode) {
                    NotificationUtilities.cancellaNotifica(idNotif: ToDoDatabase.toDoListOgg[i].idNotifify); //cancella notifica di quella task
                  }
                  ToDoDatabase.toDoListOgg.remove(ToDoDatabase.toDoListOgg[i]);
                  i = i - 1;
                }
              }
              db.updateData();
              HomePage.countTask(); //aggiorni il numero di task di oggi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  showCloseIcon: true,
                  margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
                  behavior: SnackBarBehavior.floating,
                  closeIconColor: ColorVar.taskBasic,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
                  content: Text('Attività svolte cancellate', style: TextStyle(color: ColorVar.textSuPrincipale)),
                  backgroundColor: ColorVar.principale));
              //Vibration.vibrate(duration: 1000);
              Vibration.vibrate(pattern: [200, 300, 400], intensities: [200, 0, 100]);
              if (overlayTutorial.tutorial_mode) {
                overlayTutorial.removeTutorial(overlayTutorial.overlay);
                overlayTutorial.overlay=overlayTutorial.showTutorial(context, "Clicca sul titolo di un'attività per visualizzare le informazioni", MediaQuery.of(context).size.height * 0.70);
                homePageRefresh();
                overlayTutorial.step+=1;
              }
            }
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
    if (!overlayTutorial.tutorial_mode) {
      setState(() {
      ToDoDatabase.toDoListOgg[index].taskCompletedData = value!;
      db.updateData();
      HomePage.countTask();
    });
    }
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
    if (overlayTutorial.step==0 || !overlayTutorial.tutorial_mode) {
      await showDialog(
      context: context,
      builder: (BuildContext context) {
        bool notifActive = true;
        return AlertDialog(
          title: Container(
            color: ColorVar.background,
            child: Text("Aggiungi una nuova attività", style: TextStyle(color: ColorVar.taskBasic, fontSize: 21, fontWeight: FontWeight.w500))
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
                autocorrect: true,
                cursorRadius: const Radius.circular(30),
                maxLength: 15, //limite lunghezza titolo
                cursorColor: ColorVar.principale,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: ColorVar.taskBasic,fontSize: 17 , fontWeight: FontWeight.w500),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.textBasic)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.principale))
                )
              ),
              TextField(
                autocorrect: true,
                controller: descrController,
                cursorRadius: const Radius.circular(30),
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
                  labelStyle: TextStyle(color: ColorVar.taskBasic,fontSize: 17 , fontWeight: FontWeight.w500),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.textBasic)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.principale))
                )
              ),
              Row(
                children: [
                  Text('Data e Orario:', style: TextStyle(fontSize: 14, color: ColorVar.principale, fontWeight: FontWeight.w400)),
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
                    child: Text('Modifica', style: TextStyle(color: ColorVar.taskBasic, fontSize: 14, fontWeight: FontWeight.w500))
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
              child: const Text('Annulla', style: TextStyle(color: Colors.red, fontSize: 14 , fontWeight: FontWeight.w500)),
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
                  if (!overlayTutorial.tutorial_mode) {
                    NotificationUtilities.creaNotifica(nome: taskName, descrizione: HomePage.abbreviaStringa(descr, 100), quando: selectedDate, idNotif: idNotifica);  //crea notifica associata
                  }
                  Navigator.pop(context);
                  selectedDate =DateTime.now();
                }
               if (overlayTutorial.tutorial_mode) {
                  overlayTutorial.removeTutorial(overlayTutorial.overlay);
                  overlayTutorial.overlay=overlayTutorial.showTutorial(context, "Scuoti per cancellare le attività svolte", MediaQuery.of(context).size.height * 0.70);
                  homePageRefresh();
                  overlayTutorial.step+=1;
                }
              },
              style: TextButton.styleFrom(foregroundColor: ColorVar.taskBasic),
              child: Text('Aggiungi', style: TextStyle(color: ColorVar.taskBasic,fontSize: 14 , fontWeight: FontWeight.w500)),
            )
          ]
        );
      }
    );
    }
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

  @override
  Widget build(BuildContext context) {
    if (overlayTutorial.tutorial_mode && !overlayTutorial.tutorial_message_active) {
      overlayTutorial.tutorial_message_active=true;
      Future.delayed(Duration.zero,(){
        overlayTutorial.overlay=overlayTutorial.showTutorial(context, "Crea attività tenendo premuto", MediaQuery.of(context).size.height * 0.10);
      });
    }
    if (overlayTutorial.final_message && !overlayTutorial.tutorial_message_active) {
      overlayTutorial.tutorial_message_active=true;
      Future.delayed(Duration.zero,(){
        overlayTutorial.overlay=overlayTutorial.showTutorial(context, "Bentornato, adesso la modalità tutorial è disattivata", MediaQuery.of(context).size.height * 0.70);
      });
      Future.delayed(const Duration(seconds: 7),(){
        overlayTutorial.removeTutorial(overlayTutorial.overlay);
        overlayTutorial.final_message=false;
        overlayTutorial.tutorial_message_active=false;
      });
    }
    return GestureDetector(
      onLongPress: onLongPressDetected,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorVar.taskBasic,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('TooDy', style: TextStyle(fontSize: 25, color: ColorVar.principale, fontWeight: FontWeight.w500))
            ]
          ),
          actions: [
            IconButton( //bottone setting
                iconSize: 30,
                icon: const Icon(Icons.info_outline), //per icone https://fonts.google.com/icons?icon.platform=flutter
                onPressed: () {
                  if (!overlayTutorial.tutorial_mode && !overlayTutorial.final_message) {
                     Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TutorialPage(loadDataHomePage: _loadDataHomePage)));
                  }
                },
                color: ColorVar.principale,
              ),
              IconButton( //bottone setting
                iconSize: 30,
                icon: FirebaseAuth.instance.currentUser!=null ? const Icon(Icons.account_circle_outlined) : const Icon(Icons.login), //per icone https://fonts.google.com/icons?icon.platform=flutter
                onPressed: () {
                  if (!overlayTutorial.tutorial_mode) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage(homePageRefresh: homePageRefresh))).then((_) async {
                        await db.loadData();
                        await db.updateData();
                        HomePage.countTask();
                        homePageRefresh();
                      });
                  }
                },
                color: ColorVar.principale,
              )
          ]
        ),
        backgroundColor: ColorVar.background, //colore background principale
        body: ToDoDatabase.toDoListOgg.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Nessuna attività creata', style: TextStyle(fontSize: 18, color: ColorVar.principale)),
                    Text('Tieni premuto per aggiungere una nuova attività', style: TextStyle(fontSize: 14, color: ColorVar.principale))
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

