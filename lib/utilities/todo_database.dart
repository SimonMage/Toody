// ignore_for_file: file_names
import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List<dynamic> toDoList =[];

  final _myBox=Hive.box('mybox');

  //Metodo eseguito nel caso non esista un precedente database
  //salvato localmente(primo utilizzo app oppure database mancante)
  //void createData() {
  //  toDoList=[];
  //}

  //Metodo che carica i dati dal database
  //Database ---> App
  void loadData() {
    toDoList=_myBox.get("TODO");
  }

  //Metodo che aggiorna i dati presenti sul database
  //App ---> Database
  void updateData() {
    //Ordinamento delle attività per data
    toDoList.sort((a,b)=> a[2].compareTo(b[2]));
    _myBox.put("TODO", toDoList);
  }

  //bool isThereData() {
  //  return _myBox.get("activities") == null;
  //}
}