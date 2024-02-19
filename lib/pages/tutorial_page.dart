import 'package:flutter/material.dart';
import 'package:toody/utilities/colors_var.dart';
import 'package:toody/utilities/overlay.dart';
import 'package:toody/utilities/todo_database.dart';

//Da risolvere bug checkbox
class TutorialPage extends StatelessWidget {
  final Function() loadDataHomePage;
   const TutorialPage({
    Key? key,
    required this.loadDataHomePage,
  }) : super(key: key);
  //const TutorialPage({super.key, super.loadDataHomePage});
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorVar.background, // Sfondo giallo
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0), //spazio dal bordo superiore (vertical) e laterali (horizontal)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Informazioni", style: TextStyle(color: ColorVar.principale, fontSize: 25, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Text("L'app TooDy utilizza colori diversi per differenziare le attività in base alla loro scadenza", textAlign: TextAlign.justify, style: TextStyle(color: ColorVar.textBasic, fontSize: 20, fontWeight: FontWeight.w400)),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width*0.075,
                  width: MediaQuery.of(context).size.width*0.075,
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 59, 209, 255), borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 1.6)),
                ),
                const SizedBox(width: 20),
                Expanded(child: Text("Le attività di colore azzurro, sono attività con scadenze non odierne" , textAlign: TextAlign.justify, style: TextStyle(color: ColorVar.textBasic, fontSize: 20, fontWeight: FontWeight.w400)))
              ]
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width*0.075,
                  width: MediaQuery.of(context).size.width*0.075,
                  decoration: BoxDecoration(color: ColorVar.taskOggi, borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 1.6)),
                ),
                const SizedBox(width: 20),
                Expanded(child: Text("Le attività di colore verde acqua, sono attività con scadenze odierne" , textAlign: TextAlign.justify, style: TextStyle(color: ColorVar.textBasic, fontSize: 20, fontWeight: FontWeight.w400,)))
              ]
            ),
            Row(
              children: [
                TextButton(onPressed: () {
                  ToDoDatabase().tutorialInitialize();
                  Navigator.pop(context);
                  overlayTutorial.tutorial_mode=true;
                  loadDataHomePage();
                }, child: Text("Tour", style: TextStyle(color: ColorVar.principale)),
                ),
              ],
            ),
          ]
        )
      )
    );
  }  
}