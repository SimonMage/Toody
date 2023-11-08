import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:toody/pages/information_page.dart';


// ignore: must_be_immutable
class ToDoTile extends StatelessWidget {
  final String taskName;
  final String descr;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  final DateTime? taskDate;

  ToDoTile({
    Key? key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    this.taskDate,
    required this.descr,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Center(
  child: Container(
    width: double.infinity,
    //color: Colors.yellow, 
    padding: const EdgeInsets.all(15),
   decoration: BoxDecoration(
    border: Border.all(color: Colors.yellow),
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    color: Colors.yellow
  ),
   margin: const EdgeInsets.all(9),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(scale: 1.5,
                        child: Checkbox(value: taskCompleted,
                                        onChanged: onChanged,
                                        checkColor: Colors.blue[700],
                                       activeColor: Colors.yellow,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0),),
                                        side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 2.0, color: Colors.blue[700] ?? Colors.blue)),
                                        )
                        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (context) => information_page(taskName: taskName, descr: descr, taskCompleted: taskCompleted, taskDate: taskDate)
                      )
                    );
                },
                child: Text(
                  taskName,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: Colors.blue[700]),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                descr,
                style: const TextStyle(fontSize: 14.0,color: Colors.black),
              )
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined),
                    const SizedBox(width: 3),
                    Text(DateFormat('dd/MM/yyyy').format(taskDate!), // Usa DateFormat per formattare la data
                      style: const TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined),
                    const SizedBox(width: 3),
                    Text(DateFormat('HH:mm').format(taskDate!), // Usa DateFormat per formattare l'orario
                      style: const TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ],
                )
                
              ],
            )
          ],
        )
      ],
    ),
  ),
)
  ;}

}