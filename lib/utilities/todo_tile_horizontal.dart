import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/pages/information_page.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:toody/pages/edit_page.dart';

class ToDoTileHorizontal extends StatelessWidget {
  final int index;
  final Function(bool?)? onChanged;

  const ToDoTileHorizontal({
    Key? key,
    required this.index,
    required this.onChanged,
  }) : super(key: key);

  @override
 Widget build(BuildContext context) {
  return Center(
    child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 55.0), //spazio dal bordo superiore (vertical) e laterali (horizontal)
              child: Container(
                width: MediaQuery.of(context).size.width-20,
                height: MediaQuery.of(context).size.height * 0.6, //percentuale di grandezza container
                decoration: BoxDecoration(  //bordi container tondi
                color: ToDoDatabase.toDoListOgg[index].taskDateData.day==DateTime.now().day && ToDoDatabase.toDoListOgg[index].taskDateData.month==DateTime.now().month && ToDoDatabase.toDoListOgg[index].taskDateData.year==DateTime.now().year ? Color.fromARGB(255, 255, 204, 0) : Colors.yellow, borderRadius: BorderRadius.circular(20.0)),
                padding: const EdgeInsets.only(left:10.0, right:10.0, top: 10), //spazio vuoto tra limite container e contenuto container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ToDoDatabase.toDoListOgg[index].taskNameData, 
                          style: TextStyle(
                            fontSize: 40.0, 
                            color: Colors.blue[700], 
                            fontWeight: FontWeight.w500,
                            decoration: ToDoDatabase.toDoListOgg[index].taskCompletedData ? TextDecoration.lineThrough : TextDecoration.none)
                          ),
                        IconButton( //bottone edit
                          iconSize: 30,
                          icon: const Icon(Icons.edit),
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditPage(
                                index: index,
                                onChanged: onChanged,)
                            ));
                          },
                          color: Colors.blue[700],
                        ),
                      ]
                    ),
                    const SizedBox(height: 7), //spazio tra titolo e data/ora
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, size:20),
                        const SizedBox(width: 3), //spazio tra icona calendario e data
                        Text(DateFormat('dd/MM/yyyy').format(ToDoDatabase.toDoListOgg[index].taskDateData!), style: const TextStyle(fontSize: 15, color: Colors.black)),
                        const SizedBox(width: 10), //spazio tra stringa data e icona orologio
                        const Icon(Icons.timer_outlined, size: 20),
                        const SizedBox(width: 3), //spazio tra icona orologio e ora
                        Text(DateFormat('HH:mm').format(ToDoDatabase.toDoListOgg[index].taskDateData!),style: const TextStyle(fontSize: 15, color: Colors.black)),
                      ]
                    ),
                    const SizedBox(height: 15), //spazio tra data/ora e descrizione
                    Text(ToDoDatabase.toDoListOgg[index].descrData, style: const TextStyle(fontSize: 17.0))
                  ]
                )
              )
            )
            );        
 }
}