import 'package:flutter/material.dart';
import 'package:toody/pages/home_page.dart';
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
  
  //impaginazione alternativa@override
  Widget buildAlternativa(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorVar.background, // Sfondo giallo
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 55.0), //spazio dal bordo superiore (vertical) e laterali (horizontal)
        child: Material( //material per ombre di profondita
          elevation: 20, //profondita dell ombra
          shadowColor: ColorVar.taskBasic, //colore ombra
          borderRadius: BorderRadius.circular(20.0), //bordo circolare del material (da fare uguale al bordo della classe che wrappa)
          child: Container(
            width: double.infinity, //rimepie tutto lo shcermo in orizontale (meno il bordo del padding)
            height: MediaQuery.of(context).size.height * 0.6, //percentuale di grandezza container
            decoration: BoxDecoration(  //bordi container tondi
              color: ColorVar.taskBasic,
              borderRadius: BorderRadius.circular(20.0)
            ),
            padding: const EdgeInsets.only(left:10.0, top: 10, right: 10.0), //spazio vuoto tra limite container e contenuto container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Statistiche task", style: TextStyle(fontSize: 30.0, color: ColorVar.principale, fontWeight: FontWeight.w500)),
                  
                const SizedBox(height: 15), //spazio tra titolo task oggi
                Text("task del giorno", style: TextStyle(fontSize: 23.0, color: ColorVar.principale, fontWeight: FontWeight.w400)),
                Text("task del giorno completate: " '${HomePage.todayTask}', style: const TextStyle(fontSize: 17.0)),
                Text("task del giorno da completare : " '${HomePage.todayTaskToDo}', style: const TextStyle(fontSize: 17.0)),
                const SizedBox(height: 30), //spazio tra task oggi e task settimana
            
                Text("task del giorno", style: TextStyle(fontSize: 23.0, color: ColorVar.principale, fontWeight: FontWeight.w400)),
                Text("task della settimana completate: " '${HomePage.weekTask}', style: const TextStyle(fontSize: 17.0)),
                Text("task della settimana da completare: " '${HomePage.weekTaskToDo}', style: const TextStyle(fontSize: 17.0)),
                const SizedBox(height: 30), //spazio tra task settimana e task mese
            
                Text("task del giorno", style: TextStyle(fontSize: 23.0, color: ColorVar.principale, fontWeight: FontWeight.w400)),
                Text("task del mese completate: " '${HomePage.monthTask}', style: const TextStyle(fontSize: 17.0)),
                Text("task del mese da completare: " '${HomePage.monthTaskToDo}', style: const TextStyle(fontSize: 17.0)),
              ]
            )
          )
        )
      )
    );
  }

  
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