import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Da risolvere bug checkbox
class InformationPage extends StatefulWidget {
  final String taskName;
  final String descr;
  bool taskCompleted;
  final Function(bool?)? onChanged;
  final DateTime? taskDate;
  bool notifActive;
  final String notifSound;
  final Function(bool?)? onChanged1;

  InformationPage({
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
  _InformationPageState createState() => _InformationPageState(taskName, taskCompleted, onChanged, taskDate, descr, notifActive, notifSound, onChanged1);
  }

class _InformationPageState extends State<InformationPage> {
  String taskName;
  String descr;
  bool taskCompleted;
  Function(bool?)? onChanged;
  DateTime? taskDate;
  bool notifActive;
  String notifSound;
  Function(bool?)? onChanged1;
  _InformationPageState(this.taskName, this.taskCompleted, this.onChanged, this.taskDate, this.descr, this.notifActive, this.notifSound, this.onChanged1);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow[200], //colore background
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.95,
            heightFactor: 0.92,
            child: Container(
                  decoration: BoxDecoration(  //bordi container tondi
                    color: Colors.yellow, borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.all(20.0), //spazio vuoto tra limite container e contenuto container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(taskName, style: TextStyle(fontSize: 30.0, color: Colors.blue[700], fontWeight: FontWeight.w500)),
                      const SizedBox(height: 0), //spazio tra titolo e data/ora
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined, size:20),
                          const SizedBox(width: 3), //spazio tra icona calendario e data
                          Text(DateFormat('dd/MM/yyyy').format(taskDate!), style: const TextStyle(fontSize: 12.0, color: Colors.black)),
                          const SizedBox(width: 10), //spazio tra stringa data e icona orologio
                          const Icon(Icons.timer_outlined, size: 20),
                          const SizedBox(width: 3), //spazio tra icona orologio e ora
                          Text(DateFormat('HH:mm').format(taskDate!),style: const TextStyle(fontSize: 12.0, color: Colors.black)),
                        ]
                      ),
                      const SizedBox(height: 15), //spazio tra data/ora e descrizione
                      Text(descr, style: const TextStyle(fontSize: 17.0)),
                      const SizedBox(height: 15), //spazio tra descrizione e notifica
                      Row(
                        children: [
                          Text("Notifica", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Colors.blue[700])),
                          const SizedBox(width: 14), //spazio tra stringa notifica e checkbox
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              value: notifActive,
                              onChanged: (bool? value) {
                                setState(() {
                                  notifActive = value ?? false;
                                });
                              },
                              checkColor: Colors.blue[700],
                              activeColor: Colors.yellow,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)), //bordi chedckbox tondi
                              side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 2.0, color: Colors.blue[700] ?? Colors.blue))
                            )
                          )
                        ]
                      ),
                      const SizedBox(height: 0),//spazio tra notifica e suono
                      Row(
                        children: [
                          Text("Suono: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.blue[700])),
                          const SizedBox(width: 27), //spazio tra stringa suono e stringa notifSound
                          Text(notifSound, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.blue[700])),
                        ]
                      )
                    ]
                  )
            )
          )
        )
      )
    );
  }
}
