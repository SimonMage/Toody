import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class information_page extends StatefulWidget {
  String taskName;
  String descr;
  bool taskCompleted;
  Function(bool?)? onChanged;
  DateTime? taskDate;

 information_page({
    Key? key,
    required this.taskName,
    required this.taskCompleted,
    this.taskDate,
    required this.descr,
  }) : super(key: key);
  @override
  _information_pageState createState() => _information_pageState(taskName, taskCompleted, taskDate, descr);
}

class _information_pageState extends State<information_page>
{
  String taskName;
  String descr;
  bool taskCompleted;
  DateTime? taskDate;
  _information_pageState(this.taskName, this.taskCompleted, this.taskDate,this.descr);

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
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: Colors.blue[700]),
                      textAlign: TextAlign.left,
                    ),
            ],)
          ),
          const SizedBox(height: 10),
          Column(children: [
            Text(
              descr,
              style: TextStyle(fontSize: 17.0),
              )
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: 
            [
              const Icon(Icons.calendar_month_outlined),
              const SizedBox(width: 3),
              Text(DateFormat('dd/MM/yyyy').format(taskDate!), // Usa DateFormat per formattare la data
                        style: const TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
              const SizedBox(width: 10),
              const Icon(Icons.timer_outlined),
                    const SizedBox(width: 3),
                    Text(DateFormat('HH:mm').format(taskDate!), // Usa DateFormat per formattare l'orario
                      style: const TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}