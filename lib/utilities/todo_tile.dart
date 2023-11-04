import 'package:flutter/material.dart';


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
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                   // Checkbox 
                    Transform.scale(
                      scale: 1.5,
                      child: Checkbox(value: taskCompleted, onChanged: onChanged),
                     ),
                    // Nome lista
                    Text(
                      taskName, 
                      style: TextStyle(fontSize: 16.0),
                    ),                  ],
                ),
               Container(
                    //Soluzione temporanea per posizionare la data a destra del tile
                    margin: EdgeInsets.only(right:220),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(descr),
                      ],
                    ),
                 ),
                if (taskDate != null)
                 Container(
                    //Soluzione temporanea per posizionare la data a destra del tile
                    margin: EdgeInsets.only(left:220),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("${taskDate!.day}/${taskDate!.month}/${taskDate!.year} ● ${taskDate!.hour}:${taskDate!.minute}"),
                      ],
                    ),
                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}