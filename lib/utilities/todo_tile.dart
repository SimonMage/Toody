import 'package:flutter/material.dart';
class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  final DateTime taskDate;


  ToDoTile({
    super.key, 
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.taskDate,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 25, top: 25),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row (
          children: [
            Column(
              children: [
                Container (
                  child: Row(
                    children: [
                      //Checkbox
                      Checkbox(value: taskCompleted, onChanged: onChanged),
                      //Nome lista
                      Text(taskName),
                    ]
                  )
                ),
                Container (
                  child: Row(
                    children: [
                      Text(taskDate.day.toString() + "/" + taskDate.month.toString() + "/" + taskDate.year.toString() + "  " + taskDate.hour.toString() + ":" + taskDate.minute.toString() + ":" + taskDate.second.toString()),
                    ]
                  )
                ),
              ],
            ),
          ]
        ),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(12),),
      ),
    );
  }
}