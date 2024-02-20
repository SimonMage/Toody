// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_const_constructors, must_be_immutable, no_logic_in_create_state

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toody/utilities/colors_var.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:toody/pages/home_page.dart';

class overlayWidget extends StatefulWidget {
  String message;
  String? message1;
  double top;
  overlayWidget({
    Key? key,
    required this.message,
    required this.top,
    this.message1,
  }) : super(key: key);

  @override
  State<overlayWidget> createState() => _overlayWidgetState(message, top, message1);
}

class _overlayWidgetState extends State<overlayWidget> with SingleTickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  String message;
  String? message1;
  double top;
  _overlayWidgetState(this.message, this.top, this.message1);
  late Timer countdown;
  int start=10;

  @override
  void initState() {
    super.initState();
    if (overlayTutorial.timer) {
      startTimer();
    }
  }

  void startTimer() {
  const oneSec = Duration(seconds: 1);
  countdown = Timer.periodic(
    oneSec,
    (Timer timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          overlayTutorial.removeTutorial(overlayTutorial.overlay);
        });
      } else {
        setState(() {
          start--;
        });
      }
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        child: Material(
          color: ColorVar.taskBasic,
          borderRadius: BorderRadius.circular(20),
          shadowColor: ColorVar.taskBasic, //colore ombra
          elevation: 20,
          child: Container(
            decoration: BoxDecoration(color: ColorVar.taskBasic,borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.only(left: 17, top: 10, bottom: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      overlayTutorial.timer ? 
                      Text("$message $start ${message1!}", style: TextStyle(color: ColorVar.principale, fontSize: 14))
                      :Text(message, style: TextStyle(color: ColorVar.principale, fontSize: 14)),
                      overlayTutorial.final_message ? 
                      Container() 
                      : Text("${overlayTutorial.step} di ${overlayTutorial.max}", style: TextStyle(fontSize: 14, color: ColorVar.principale),),
                    ],
                  ),
                ),

                overlayTutorial.final_message ? 
                SizedBox(
                  height: 40.0,
                )
                
                : SizedBox(
                  height: 40.0,
                  child: VerticalDivider(color: ColorVar.principale, thickness: 1.0),
                ),
                
                overlayTutorial.final_message ? 
                SizedBox(
                )

                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      iconSize: MediaQuery.of(context).size.width*0.10,
                      icon: Icon(Icons.close, color: ColorVar.principale),
                      onPressed: () {
                        if (overlayTutorial.timer) {
                          countdown.cancel();
                          //start=0;
                        }
                        overlayTutorial.final_message=true;
                        overlayTutorial.removeTutorial(overlayTutorial.overlay);
                        ToDoDatabase.toDoListOgg = [];
                        ToDoDatabase().loadData();
                        overlayTutorial.tutorial_mode=false;
                        overlayTutorial.tutorial_message_active=false;
                        overlayTutorial.step=0;
                        overlayTutorial.timer=false;
                        //Rende l'HomePage l'unica pagina nello stack
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
                      }
                    )
                  ]
                )
              ]
            )
          )
        )
      );
  }
}

class overlayTutorial {
  static bool tutorial_mode=false;
  static bool tutorial_message_active=false;
  static OverlayEntry overlay=OverlayEntry(builder:(context)=>Container());
  static bool final_message=false;
  static int step=0;
  static int max=7;
  static bool timer=false;
  
  static OverlayEntry showTutorial(BuildContext context, String message, double top, [String? message1]) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => overlayWidget(message: message, top: top, message1: message1)
    );

    //if (overlayTutorial.tutorial_mode) {
      overlayState.insert(overlayEntry);
    //}

    //await Future.delayed(Duration(seconds: 2));
    //overlayEntry.remove();
    return overlayEntry;
  }

  static removeTutorial(OverlayEntry overlayEntry) {
    if (overlayTutorial.timer) {
      overlayTutorial.timer=false;
    }
    try {
      overlayEntry.remove();
    } 
    on Exception catch (_){
      debugPrint("Error while removing overlay");
    }
  }
}