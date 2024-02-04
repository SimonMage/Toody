import 'package:hive_flutter/hive_flutter.dart';
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

}


class ToDoDatabase {
  static List<dynamic> toDoListOgg = []; //lista di oggetti TileData

  final _myBox = Hive.box('mybox');

  //Metodo eseguito nel caso non esista un precedente database
  //salvato localmente(primo utilizzo app oppure database mancante)
  //void createData() {
  //  toDoList=[];
  //}

  //Metodo che carica i dati dal database
  //Database ---> App
  void loadData() {
    toDoListOgg = _myBox.get("TODO");
  }
  

  //Metodo che aggiorna i dati presenti sul database
  //App ---> Database
  void updateData() {
    //Ordinamento delle attività per data
    
    toDoListOgg.sort((a, b) => a.taskDateData.compareTo(b.taskDateData));
    _myBox.put("TODO", toDoListOgg);
  }

  //bool isThereData() {
  //  return _myBox.get("activities") == null;
  //}
}
