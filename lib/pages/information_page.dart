import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Da risolvere bug checkbox
class information_page extends StatefulWidget {
  String taskName;
  String descr;
  bool taskCompleted;
  Function(bool?)? onChanged;
  DateTime? taskDate;
  bool notifActive;
  String notifSound;
  Function(bool?)? onChanged1;

  information_page({
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
  @override
  _information_pageState createState() => _information_pageState(
      taskName,
      taskCompleted,
      onChanged,
      taskDate,
      descr,
      notifActive,
      notifSound,
      onChanged1);
}

class _information_pageState extends State<information_page> {
  String taskName;
  String descr;
  bool taskCompleted;
  Function(bool?)? onChanged;
  DateTime? taskDate;
  bool notifActive;
  String notifSound;
  Function(bool?)? onChanged1;
  _information_pageState(
      this.taskName,
      this.taskCompleted,
      this.onChanged,
      this.taskDate,
      this.descr,
      this.notifActive,
      this.notifSound,
      this.onChanged1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
              child: Column(
            children: [
              Text(
                taskName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.blue[700]),
                textAlign: TextAlign.left,
              ),
            ],
          )),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                descr,
                style: TextStyle(fontSize: 17.0),
              )
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined),
              const SizedBox(width: 3),
              Text(
                DateFormat('dd/MM/yyyy')
                    .format(taskDate!), // Usa DateFormat per formattare la data
                style: const TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.timer_outlined),
              const SizedBox(width: 3),
              Text(
                DateFormat('HH:mm').format(
                    taskDate!), // Usa DateFormat per formattare l'orario
                style: const TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: notifActive,
                    //onChanged: onChanged1,
                    onChanged: (bool? value) {
                      setState(() {
                        notifActive = value ?? false;
                      });
                    },
                    checkColor: Colors.blue[700],
                    activeColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    side: MaterialStateBorderSide.resolveWith((states) =>
                        BorderSide(
                            width: 2.0,
                            color: Colors.blue[700] ?? Colors.blue)),
                  )),
              const SizedBox(width: 14),
              Text(
                "Notifica",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue[700]),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Suono: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue[700]),
              ),
              const SizedBox(width: 14),
              Text(
                notifSound,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
