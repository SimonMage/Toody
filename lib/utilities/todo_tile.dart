import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import 'package:intl/intl.dart';

import 'package:toody/pages/information_page.dart';

>>>>>>> Stashed changes

// ignore: must_be_immutable
class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  final DateTime? taskDate;

  ToDoTile({
    Key? key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    this.taskDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 25, top: 25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(12),
=======
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
>>>>>>> Stashed changes
        ),
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    // Checkbox
                    Checkbox(value: taskCompleted, onChanged: onChanged),
                    // Nome lista
                    Text(taskName),
                  ],
                ),
                if (taskDate != null)
                  Row(
                    children: [
                      //Text("${taskDate!.day}/${taskDate!.month}/${taskDate!.year}"),
                      Text("${taskDate!.day}/${taskDate!.month}/${taskDate!.year} ● ${taskDate!.hour}:${taskDate!.minute}"),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}