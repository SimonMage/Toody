import 'package:hive_flutter/hive_flutter.dart';
part 'todo_database.g.dart'; //todo_database.g.dart fa parte di questo file

//serve id per ogni classe che vuoi salvare con Hive e id (unico per la classe) per ogni parametro da salvare
//annotazioni servono per generare automaticamente todo_database.g.dart con un adattatore per la classe (che converte l'oggetto da e a binario)
@HiveType(typeId: 1)
class TileData extends HiveObject {

  @HiveField(0)
  String taskNameData;

  @HiveField(1)  
  String descrData;

  @HiveField(2)
  DateTime? taskDateData;

  @HiveField(3)
  bool taskCompletedData;

  @HiveField(4)
  bool notifActiveData;

  @HiveField(5)
  String notifSoundData;

  TileData({
    required this.taskNameData,
    required this.taskCompletedData,
    required this.taskDateData,
    required this.descrData,
    required this.notifActiveData,
    required this.notifSoundData
  });

@override
  String toString() {
    return "taskNameData: $taskNameData\ntaskCompletedData: $taskCompletedData\ntaskDateData: $taskDateData\ndescrData:$descrData";
  }

}


class ToDoDatabase {
  List<dynamic> toDoListOgg = []; //lista di oggetti TileData

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
