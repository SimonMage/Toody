import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/pages/information_page.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:toody/utilities/colors_var.dart';
import 'package:toody/utilities/overlay.dart';

class ToDoTile extends StatelessWidget {
  final int index;
  final Function(bool?)? onChanged;
  final Function() loadDataHomePage;

  const ToDoTile({
    Key? key,
    required this.index,
    required this.onChanged,
    required this.loadDataHomePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(                                              //il bordo della classe material deve essere uguale
      borderRadius: const BorderRadius.all(Radius.circular(15)),  //a quello della classe wrappata (container)
      elevation: 10,    //ombra di profondita
      child: Container(
        padding: const EdgeInsets.only(top:13, bottom: 13, left: 10, right: 15), //spazio tra contenuto della checkbox e bordo
        decoration: BoxDecoration(
          border: Border.all(color: HomePage.sameDay(ToDoDatabase.toDoListOgg[index].taskDateData,DateTime.now()) ? ColorVar.taskOggi : ColorVar.taskBasic), //bordi del container gialli
          borderRadius: const BorderRadius.all(Radius.circular(15)), //bordi circolari
          color: HomePage.sameDay(ToDoDatabase.toDoListOgg[index].taskDateData,DateTime.now()) ? ColorVar.taskOggi : ColorVar.taskBasic
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: ToDoDatabase.toDoListOgg[index].taskCompletedData,
                onChanged: onChanged,
                checkColor: ColorVar.principale, //colore spunta
                activeColor: HomePage.sameDay(ToDoDatabase.toDoListOgg[index].taskDateData,DateTime.now()) ? ColorVar.taskOggi : ColorVar.taskBasic,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)), //checkbox circolare
                side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 2.0, color: ColorVar.principale)), //spessore e colore bordo checkboz
              )
            ),
            const SizedBox(width: 14), //spazio tra checkbox e titolo/descrizione
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      HomePage.signal=false;
                      overlayTutorial.removeTutorial(HomePage.tutorialoverlay);
                      overlayTutorial.tutorial_message_active=false;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InformationPage(
                          index: index,
                          onChanged: onChanged) //crea l information page con il numero di task del giorno
                      )).then((_) async {
                        HomePage.signal=true;
                        loadDataHomePage();
                        }
                      );
                    },
                    style: const ButtonStyle(alignment: Alignment.centerLeft,padding: MaterialStatePropertyAll(EdgeInsets.all(0))), //spazio titolo dalla checkbox
                    child: Text(ToDoDatabase.toDoListOgg[index].taskNameData, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: ColorVar.principale))
                  ),
                  const SizedBox(height: 0), //spazio tra titolo e descrizione
                  Text(HomePage.primaRiga(HomePage.abbreviaStringa(ToDoDatabase.toDoListOgg[index].descrData, 20)), style: TextStyle(fontSize: 14.0, color: ColorVar.textBasic)) //descrizione di cui visualizzi solo la prima riga
                ]
              )
            ),
            const SizedBox(height: 0), //spazio vuoto tra contenuto tile e bordi alti e bassi
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined),
                        const SizedBox(width: 3), //spazio tra icona calendario e stringa data
                          Text(DateFormat('dd/MM/yyyy').format(ToDoDatabase.toDoListOgg[index].taskDateData!), style: TextStyle(fontSize: 14.0, color: ColorVar.textBasic))
                      ]
                    ),
                    const SizedBox(height: 2), //spazio tra data e ora
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined),
                        const SizedBox(width: 3), //spazio tra icona orologio e ora
                        Text(DateFormat('HH:mm').format(ToDoDatabase.toDoListOgg[index].taskDateData!), style: TextStyle(fontSize: 14.0, color: ColorVar.textBasic))
                      ]
                    )
                  ]
                )
              ]
            )
          ]
        )
    )
  );
 }
}
