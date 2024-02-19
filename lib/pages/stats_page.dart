import 'package:flutter/material.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/utilities/colors_var.dart';

//Da risolvere bug checkbox
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});
  //static late OverlayEntry tutorialoverlay;

  
  //impaginazione alternativa@override
  Widget buildAlternativa(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorVar.background, // Sfondo giallo
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 55.0), //spazio dal bordo superiore (vertical) e laterali (horizontal)
        child: Material( //material per ombre di profondita
          elevation: 20, //profondita dell ombra
          shadowColor: ColorVar.textBasic, //colore ombra
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
                Text("task del mese da completare: " '${HomePage.monthTaskToDo}', style: const TextStyle(fontSize: 17.0))
              ]
            )
          )
        )
      )
    );
  }

  
  @override
  Widget build(BuildContext context) {
    /*if (overlayTutorial.tutorial_mode && !overlayTutorial.tutorial_message_active) {
      overlayTutorial.tutorial_message_active=true;
      Future.delayed(Duration.zero,(){
        StatsPage.tutorialoverlay=overlayTutorial.showTutorial(context, "Qui puoi vedere le statistiche, in 10 secondi tornerai automaticamente alla modalità utente", MediaQuery.of(context).size.height * 0.20, 0);
        Future.delayed(const Duration(seconds: 10),(){
          overlayTutorial.tutorial_mode=false;
          overlayTutorial.tutorial_message_active=false;
          overlayTutorial.removeTutorial(StatsPage.tutorialoverlay);
          //Navigator.popUntil(context, ModalRoute.withName('/'));
          ToDoDatabase().loadData();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
        });
      });
    }*/
    return Scaffold(
      backgroundColor: ColorVar.background, // Sfondo giallo
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 55.0), //spazio dal bordo superiore (vertical) e laterali (horizontal)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material( //material per ombre di profondita
              elevation: 20, //profondita dell ombra
              shadowColor: ColorVar.principale, //colore ombra
              borderRadius: BorderRadius.circular(20.0), //bordo circolare del material (da fare uguale al bordo della classe che wrappa)
              child: Container(
                decoration: BoxDecoration(
                  color: ColorVar.principale, //bordi blu
                  borderRadius: BorderRadius.circular(20.0) //bordi container tondi
                ),
                padding: const EdgeInsets.only(left:10.0, top: 5, right: 10.0, bottom: 5), //spazio vuoto tra limite container e contenuto container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Statistiche task", style: TextStyle(fontSize: 30.0, color: ColorVar.textSuPrincipale, fontWeight: FontWeight.w500)),
                  ]
                )
              )
            ),
            const SizedBox(height: 15), //spazio tra i due container
            Material( //material per ombre di profondita
              elevation: 20, //profondita dell ombra
              shadowColor: ColorVar.taskBasic, //colore ombra
              borderRadius: BorderRadius.circular(20.0), //bordo circolare del material (da fare uguale al bordo della classe che wrappa)
              child: Container(
                width: double.infinity, //rimepie tutto lo shcermo in orizontale (meno il bordo del padding)
                height: MediaQuery.of(context).size.height * 0.6, //percentuale di grandezza container
                decoration: BoxDecoration(  
                  color: ColorVar.taskBasic, //colore bordi
                  borderRadius: BorderRadius.circular(20.0) //bordi container tondi
                ),
                padding: const EdgeInsets.only(left:10.0, top: 10, right: 10.0), //spazio vuoto tra limite container e contenuto container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("task del giorno", style: TextStyle(fontSize: 23.0, color: ColorVar.principale, fontWeight: FontWeight.w400)),
                    Text("task del giorno completate: " '${HomePage.todayTask}', style: TextStyle(fontSize: 17.0, color: ColorVar.textBasic)),
                    Text("task del giorno da completare : " '${HomePage.todayTaskToDo}', style: TextStyle(fontSize: 17.0, color: ColorVar.textBasic)),
                    const SizedBox(height: 30), //spazio tra task giorno e task settimana
              
                    Text("task della settimana", style: TextStyle(fontSize: 23.0, color: ColorVar.principale, fontWeight: FontWeight.w400)),
                    Text("task della settimana completate: " '${HomePage.weekTask}', style: TextStyle(fontSize: 17.0, color: ColorVar.textBasic)),
                    Text("task della settimana da completare: " '${HomePage.weekTaskToDo}', style: TextStyle(fontSize: 17.0, color: ColorVar.textBasic)),
                    const SizedBox(height: 30), //spazio tra task settimana e task mese
                
                    Text("task del mese", style: TextStyle(fontSize: 23.0, color: ColorVar.principale, fontWeight: FontWeight.w400)),
                    Text("task del mese completate: " '${HomePage.monthTask}', style: TextStyle(fontSize: 17.0, color: ColorVar.textBasic)),
                    Text("task del mese da completare: " '${HomePage.monthTaskToDo}', style: TextStyle(fontSize: 17.0, color: ColorVar.textBasic))
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }  
}