// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:hive_flutter/hive_flutter.dart';
import 'package:toody/utilities/overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
part 'todo_database.g.dart'; //todo_database.g.dart fa parte di questo file

//per generare adattatore 'flutter packages pub run build_runner build'
//serve id per ogni classe che vuoi salvare con Hive e id (unico per la classe) per ogni parametro da salvare
//annotazioni servono per generare automaticamente todo_database.g.dart con un adattatore per la classe (che converte l'oggetto da e a binario)
@HiveType(typeId: 1)
class TileData extends HiveObject { //struttura dati che salvi con Hive

  @HiveField(0)
  String taskNameData; //nome task

  @HiveField(1)  
  String descrData; //descrizione task

  @HiveField(2)
  DateTime? taskDateData; //dataora task

  @HiveField(3)
  bool taskCompletedData; //bool task complete

  @HiveField(4)
  bool notifActiveData; //bool notifica

  @HiveField(5)
  String notifSoundData; //suono notifica

  @HiveField(6)
  int idNotifify; //identificatore notifica(unico per ogni notifica)

  TileData({
    required this.taskNameData,
    required this.taskCompletedData,
    required this.taskDateData,
    required this.descrData,
    required this.notifActiveData,
    required this.notifSoundData,
    required this.idNotifify
  });

@override
  String toString() {
    return "taskNameData: $taskNameData\ntaskCompletedData: $taskCompletedData\ntaskDateData: $taskDateData\ndescrData:$descrData\nidNotif: $idNotifify";
  }

Map<String, dynamic> toMap() {
    return {
      'taskName': taskNameData,
      'taskCompleted': taskCompletedData,
      'taskDate': taskDateData,
      'descr': descrData,
      'notifActive': notifActiveData,
      'notifSound': notifSoundData,
      'idNotifify': idNotifify,
    };
  }
}


class ToDoDatabase {
  static List<dynamic> toDoListOgg = []; //lista di oggetti TileData

  final _myBox = Hive.box('mybox');

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //Metodo che carica i dati dal database
  //Database ---> App
  Future<void> loadData() async {
    debugPrint(overlayTutorial.tutorial_mode.toString());
    if (overlayTutorial.tutorial_mode) {
      toDoListOgg = _myBox.get("Tutorial");
    }
    else if (_myBox.get("TODO") != Null){
      toDoListOgg = _myBox.get("TODO");
    }

    //Se nessuna attività è registrata
    //Controllo attività su firebase  
      if (_firebaseAuth.currentUser!=null && toDoListOgg.isEmpty && !overlayTutorial.tutorial_mode) {
        final String currentUserId = _firebaseAuth.currentUser!.uid;
        debugPrint ("Funziona");
        await _fireStore.collection('users').doc(currentUserId).collection('todo').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            TileData nuova = TileData(taskNameData: element['taskName'] ?? '', 
            taskCompletedData: element['taskCompleted'] ?? false, 
            descrData: element['descr'] ?? '', 
            taskDateData: element['taskDate'].toDate() ?? '', 
            notifSoundData: element['notifSound'] ?? '', 
            notifActiveData: element['notifActive'] ?? true,
            idNotifify: element['idNotifify']);
            toDoListOgg.add(nuova);
            debugPrint ("Caricamento da firebase");
            debugPrint (nuova.toString());
          })
        );
      }
  }
  
  void tutorialInitialize() {
    toDoListOgg =[
        TileData(taskNameData: "Da completare", taskCompletedData: false, descrData: "Questa è la descrizione dell'attività", taskDateData: DateTime.now(), idNotifify: 1, notifSoundData: "test", notifActiveData: true),
        TileData(taskNameData: "Attività completata", taskCompletedData: true, descrData: "Questa è la descrizione dell'attività", taskDateData: DateTime.now(), idNotifify: 2, notifSoundData: "test", notifActiveData: true),
        ];
    _myBox.put("Tutorial", toDoListOgg);
  }

  //Metodo che aggiorna i dati presenti sul database
  //App ---> Database
 Future<void> updateData() async {    
        //Ordinamento delle attività per data
        if (overlayTutorial.tutorial_mode) {
          toDoListOgg.sort((a, b) => a.taskDateData.compareTo(b.taskDateData));
          _myBox.put("Tutorial", toDoListOgg);
        }
        else {
          toDoListOgg.sort((a, b) => a.taskDateData.compareTo(b.taskDateData));
          _myBox.put("TODO", toDoListOgg);
          //Firebase
          if (_firebaseAuth.currentUser!=null) {
            final String currentUserId = _firebaseAuth.currentUser!.uid;
            //Elimina le attività per ricaricarle
            await _fireStore.collection('users').doc(currentUserId).collection('todo').get().then((snapshot) {
              for (DocumentSnapshot ds in snapshot.docs){
                ds.reference.delete();
              }
            });
            //Ricarica le attività
            for(TileData todo in toDoListOgg){
              await _fireStore
              .collection('users')
              .doc(currentUserId)
              .collection('todo')
              .add(todo.toMap());
            }
          }
        }
  }

  //bool isThereData() {
  //  return _myBox.get("activities") == null;
  //}
}
