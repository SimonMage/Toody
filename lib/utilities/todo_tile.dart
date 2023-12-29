import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toody/pages/information_page.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final String descr;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final DateTime? taskDate;
  final bool notifActive;
  final String notifSound;
  final Function(bool?)? onChanged1;

  const ToDoTile({
    Key? key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    this.taskDate,
    required this.descr,
    required this.notifActive,
    required this.notifSound,
    required this.onChanged1,
  }) : super(key: key);

//funzione per abbreviare la descrizione se supera una certa lunghezza
  String abbreviaStringa(String input, int lunghezzaMassima) {
  if (input.length <= lunghezzaMassima) {
    return input;
  } else {
    return '${input.substring(0, lunghezzaMassima)}...';
  }
}

@override
 Widget build(BuildContext context) {
  return Center(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.yellow),
        borderRadius: const BorderRadius.all(Radius.circular(15)), //bordi circolari
        color: Colors.yellow),
      margin: const EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.5,
            child: Checkbox(
              value: taskCompleted,
              onChanged: onChanged,
              checkColor: Colors.blue[700], //colore spunta
              activeColor: Colors.yellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 2.0, color: Colors.blue[700] ?? Colors.blue)),
            )
          ),
          const SizedBox(width: 14), //spazio tra checkbox e titolo/descrizione
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InformationPage(
                        taskName: taskName,
                        descr: descr,
                        onChanged: onChanged,
                        taskCompleted: taskCompleted,
                        taskDate: taskDate,
                        notifActive: notifActive,
                        notifSound: notifSound,
                        onChanged1: onChanged1)
                    ));
                  },
                  style: const ButtonStyle(alignment: Alignment.centerLeft,padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                  child: Text(taskName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.blue[700]))
                ),
                const SizedBox(height: 0), //spazio tra titolo e descrizione
                Text(abbreviaStringa(descr, 20), style: const TextStyle(fontSize: 14.0, color: Colors.black))
              ]
            )
          ),
          const SizedBox(height: 0), //spazio vuoto tra contenuto tile e bordo alto
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined),
                      const SizedBox(width: 3), //spazio tra icona calendario e stringa data
                        Text(DateFormat('dd/MM/yyyy').format(taskDate!), style: const TextStyle(fontSize: 14.0, color: Colors.black))
                    ]
                  ),
                  const SizedBox(height: 2), //spazio tra data e ora
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined),
                      const SizedBox(width: 3), //spazio tra icona orologio e ora
                      Text(DateFormat('HH:mm').format(taskDate!), style: const TextStyle(fontSize: 14.0, color: Colors.black))
                    ]
                  )
                ]
              )
            ]
          )
        ]
      )
    )
  );
 }
}
