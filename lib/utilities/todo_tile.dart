import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 25, top: 25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(12),
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