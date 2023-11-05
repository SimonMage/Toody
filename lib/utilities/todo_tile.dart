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
    return Center(
  child: Container(
    width: double.infinity,
    color: Colors.yellow, 
    padding: const EdgeInsets.all(15),
   margin: const EdgeInsets.all(9),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(scale: 1.5,child: Checkbox(value: taskCompleted,onChanged: onChanged,)),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(taskName),
              const SizedBox(height: 4),
              Text(descr)
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${taskDate!.day}/${taskDate!.month}/${taskDate!.year}\n${taskDate!.hour}:${taskDate!.minute}")
          ],
        )
      ],
    ),
  ),
)
  ;}
}