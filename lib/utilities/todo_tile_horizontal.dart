import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/utilities/colors_var.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:toody/pages/edit_page.dart';
import 'package:toody/utilities/overlay.dart';

class ToDoTileHorizontal extends StatelessWidget {
  final int index;
  final Function(bool?)? onChanged;
  final Function() refreshDataInformationPage;

  const ToDoTileHorizontal({
    Key? key,
    required this.index,
    required this.onChanged,
    required this.refreshDataInformationPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
                    if (overlayTutorial.step==4 || !overlayTutorial.tutorial_mode) {
                        if (overlayTutorial.tutorial_mode) {
                          overlayTutorial.removeTutorial(overlayTutorial.overlay);
                          overlayTutorial.tutorial_message_active=false;
                          overlayTutorial.step+=1;
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EditPage(index: index, onChanged: onChanged, taskDate: ToDoDatabase.toDoListOgg[index].taskDateData, refreshDataInformationPage: refreshDataInformationPage)), (route) => false);
                        }
                        else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPage(index: index, onChanged: onChanged, taskDate: ToDoDatabase.toDoListOgg[index].taskDateData, refreshDataInformationPage: refreshDataInformationPage)));
                      }
                    }
                  },
      child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 55.0), //spazio dal bordo superiore (vertical) e laterali (horizontal)
        child: Material( //wrappare con material per avere ombra di profondita
          elevation: 20, //profondita ombra
          shadowColor: ColorVar.taskBasic, //colore ombra
          borderRadius: BorderRadius.circular(20.0), //bordi circolari del material devono essere uguali a quelli della classe wrappata (container)
          child: Container(
            width: MediaQuery.of(context).size.width-20,
            height: MediaQuery.of(context).size.height * 0.6, //percentuale di grandezza container
            decoration: BoxDecoration(  //bordi container tondi
              color: HomePage.sameDay(ToDoDatabase.toDoListOgg[index].taskDateData, DateTime.now()) ? ColorVar.taskOggi : ColorVar.taskBasic,
              borderRadius: BorderRadius.circular(20.0) //bordi circolari
            ),
            padding: const EdgeInsets.only(left:10.0, right:10, top: 10), //spazio vuoto tra limite container e contenuto container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      ToDoDatabase.toDoListOgg[index].taskNameData, 
                        style: TextStyle(fontSize: 35.0, color: ColorVar.textSuPrincipale, fontWeight: FontWeight.w500)
                    ),
                    const SizedBox(width: 5),
                    if (ToDoDatabase.toDoListOgg[index].taskCompletedData)
                      const Icon(Icons.done, size: 30),
                  ]
                ),
                const SizedBox(height: 0), //spazio tra titolo e data/ora
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size:20),
                    const SizedBox(width: 3), //spazio tra icona calendario e data
                    Text(DateFormat('dd/MM/yyyy').format(ToDoDatabase.toDoListOgg[index].taskDateData!), style: TextStyle(fontSize: 15, color: ColorVar.textBasic)),
                    const SizedBox(width: 10), //spazio tra stringa data e icona orologio
                    const Icon(Icons.timer_outlined, size: 20),
                    const SizedBox(width: 3), //spazio tra icona orologio e ora
                    Text(DateFormat('HH:mm').format(ToDoDatabase.toDoListOgg[index].taskDateData!),style: TextStyle(fontSize: 15, color: ColorVar.textBasic)),
                  ]
                ),
                const SizedBox(height: 15), //spazio tra data/ora e descrizione
                Text(ToDoDatabase.toDoListOgg[index].descrData, style: TextStyle(fontSize: 17.0, color: ColorVar.textBasic, fontWeight: FontWeight.w400))
              ]
            )
          )
        )
      )
      )
    );        
  }
}