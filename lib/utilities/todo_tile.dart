import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/pages/information_page.dart';
import 'package:toody/utilities/todo_database.dart';

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
  return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.yellow),
        borderRadius: const BorderRadius.all(Radius.circular(15)), //bordi circolari
        color: ToDoDatabase.toDoListOgg[index].taskDateData.day==DateTime.now().day && ToDoDatabase.toDoListOgg[index].taskDateData.month==DateTime.now().month && ToDoDatabase.toDoListOgg[index].taskDateData.year==DateTime.now().year ? Color.fromARGB(255, 255, 204, 0) : Colors.yellow),
      margin: const EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.5,
            child: Checkbox(
              value: ToDoDatabase.toDoListOgg[index].taskCompletedData,
              onChanged: onChanged,
              checkColor: const Color(0xFF1976D2), //colore spunta
              activeColor: ToDoDatabase.toDoListOgg[index].taskDateData.day==DateTime.now().day && ToDoDatabase.toDoListOgg[index].taskDateData.month==DateTime.now().month && ToDoDatabase.toDoListOgg[index].taskDateData.year==DateTime.now().year ? Color.fromARGB(255, 255, 204, 0) : const Color(0xFFFFEB3B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 2.0, color: Color(0xFF1976D2))),
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
                    //Disattiva il listening della pagina home
                    await () => HomePage.detector.stopListening();

                    //Attiva il detector della pagina information
                    await () => InformationPage.detector.startListening();

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InformationPage(
                        index: index,
                        onChanged: onChanged) //crea l information page con il numero di task del giorno
                    )).then((_) async {
                      //Disattiva il detector della pagina information
                      await () => InformationPage.detector.stopListening();
                      
                      //Riattiva il detector della pagina home quando l'utente torna indietro
                      await () => HomePage.detector.startListening();

                      loadDataHomePage();
                      }
                    );
                  },
                  style: const ButtonStyle(alignment: Alignment.centerLeft,padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                  child: Text(ToDoDatabase.toDoListOgg[index].taskNameData, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xFF1976D2)))
                ),
                const SizedBox(height: 0), //spazio tra titolo e descrizione
                Text(HomePage.primaRiga(HomePage.abbreviaStringa(ToDoDatabase.toDoListOgg[index].descrData, 20)), style: const TextStyle(fontSize: 14.0, color: Colors.black))
              ]
            )
          ),
          const SizedBox(height: 0), //spazio vuoto tra contenuto tile e bordo alto
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
                        Text(DateFormat('dd/MM/yyyy').format(ToDoDatabase.toDoListOgg[index].taskDateData!), style: const TextStyle(fontSize: 14.0, color: Colors.black))
                    ]
                  ),
                  const SizedBox(height: 2), //spazio tra data e ora
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined),
                      const SizedBox(width: 3), //spazio tra icona orologio e ora
                      Text(DateFormat('HH:mm').format(ToDoDatabase.toDoListOgg[index].taskDateData!), style: const TextStyle(fontSize: 14.0, color: Colors.black))
                    ]
                  )
                ]
              )
            ]
          )
        ]
      )
  );
 }
}
