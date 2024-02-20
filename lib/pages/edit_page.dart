// ignore_for_file: must_be_immutable, library_private_types_in_public_api, no_logic_in_create_state, unused_local_variable 
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/pages/information_page.dart';
import 'package:toody/utilities/colors_var.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:toody/utilities/overlay.dart';

class EditPage extends StatefulWidget {
  int index; //L'indice dell'elemento di cui si stanno visionando i dettagli
  final Function(bool?)? onChanged;
  final DateTime taskDate;
  final Function() refreshDataInformationPage;
  
  EditPage({
    Key? key,
    required this.index,
    required this.onChanged,
    required this.taskDate,
    required this.refreshDataInformationPage,
  }) : super(key: key);
    
  @override
  _EditPageState createState() => _EditPageState(index, onChanged, taskDate, refreshDataInformationPage);
}


class _EditPageState extends State<EditPage> {
  int index;
  DateTime selectedDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController descrController = TextEditingController();
  Function(bool?)? onChanged;
  Function() refreshDataInformationPage;
  _EditPageState(this.index, this.onChanged, this.selectedDate, this.refreshDataInformationPage);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ToDoDatabase.toDoListOgg[index].taskNameData);
    descrController = TextEditingController(text: ToDoDatabase.toDoListOgg[index].descrData);
  }
  
  //Funzione necessaria per aggiornare la pagina
  void editPageRefresh() {
      setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    if (overlayTutorial.tutorial_mode && !overlayTutorial.tutorial_message_active) {
      overlayTutorial.tutorial_message_active=true;
      Future.delayed(Duration.zero,(){
          overlayTutorial.overlay=overlayTutorial.showTutorial(context, "Modifica l'attività e premi salva", MediaQuery.of(context).size.height * 0.70);
      });
    }
    return Scaffold(
      backgroundColor: ColorVar.background,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 50), //spazio dal container principale
        child: Column(
          children: [
            Material( //material per ombra di profondita
              elevation: 20, //profondita ombre
              shadowColor: ColorVar.taskBasic, //colore ombre
              borderRadius: BorderRadius.circular(20.0), //bordi del material (devono essere gli stessi)
              child: Container(
                decoration: BoxDecoration(color: ColorVar.taskBasic, borderRadius: BorderRadius.circular(20.0)), //bordi tondi
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15), //spazio tra background e container principale
                  child: Column(
                    children: [
                      Text("Modifica task", style: TextStyle(fontSize: 25.0, color: ColorVar.textSuPrincipale, fontWeight: FontWeight.w500, )),
                      TextField(
                        autocorrect: true,
                        cursorRadius: const Radius.circular(30),
                        controller: nameController,
                        maxLength: 15, //limite lunghezza titolo
                        cursorColor: ColorVar.principale,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(fontSize:22, color: ColorVar.principale, fontWeight: FontWeight.w400),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.textBasic)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.principale)))
                      ),
                      TextField(
                        autocorrect: true,
                        cursorRadius: const Radius.circular(30),
                        controller: descrController,
                        maxLength: 100, //limite lunghezza descrizione
                        cursorColor: ColorVar.principale,
                        maxLines: 3,  //massima altezza che prende il textfield
                        minLines: 1,  //minima altezza che prende il tetxfield
                        onChanged: (text) { //chiama la funzione per non far digitare piu di un tot di righe
                          HomePage.limitLines(text, 12, descrController);
                        },
                        keyboardType: TextInputType.multiline, //appare la tastiera non con invio ma con rimando a capo
                        decoration: InputDecoration(
                          labelText: 'Descrizione',
                          labelStyle: TextStyle(fontSize:22, color: ColorVar.principale, fontWeight: FontWeight.w400),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.textBasic)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.principale)))
                      ),
                      Row(
                        children: [
                          Text('Data e Orario:', style: TextStyle(fontSize:16, color: ColorVar.principale, fontWeight: FontWeight.w400)),
                          TextButton(
                            onPressed: () async {
                              HomePage.countTask ();
                              final date = await DatePicker.showDateTimePicker(
                                locale: LocaleType.it, //italiano
                                context,
                                showTitleActions: true,
                                onConfirm: (date) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                },
                                currentTime: selectedDate
                              );
                            },
                            child: Text('Modifica', style: TextStyle(color: ColorVar.textSuPrincipale, fontSize: 16, fontWeight: FontWeight.w500))
                          )
                        ]
                      ),
                      const SizedBox(height: 15),//spazio tra bottone per salvare e 
                      ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorVar.textSuPrincipale, //colore interno bottone
                        elevation: 10, //ombra bottone
                        shadowColor: ColorVar.textSuPrincipale, //colore ombra bottone
                        foregroundColor: Colors.black
                      ),
                      icon: const Icon(Icons.edit),
                      label: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Stack(
                          children: [
                            Text("Salva le modifiche", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0, color: ColorVar.principale)),
                          ],
                        ),
                      ),
                      onPressed: () {
                          if (overlayTutorial.step==5 || !overlayTutorial.tutorial_mode) {
                          ToDoDatabase.toDoListOgg[index].taskDateData=selectedDate;
                          ToDoDatabase.toDoListOgg[index].taskNameData=nameController.text;
                          ToDoDatabase.toDoListOgg[index].descrData=descrController.text;
                          ToDoDatabase().updateData();
                          HomePage.countTask();
                          if (overlayTutorial.tutorial_mode) {
                            overlayTutorial.removeTutorial(overlayTutorial.overlay);
                            overlayTutorial.step+=1;
                            overlayTutorial.tutorial_message_active=false;
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => InformationPage(index: index, onChanged: onChanged)), (route) => false);
                          }
                          else {
                            refreshDataInformationPage();
                            Navigator.pop(context);
                          }
                          }
                        }
                    ),
                    const SizedBox(height: 15)
                    ]
                  )
                )
              )
            ),
            const SizedBox(height: 50),
            Expanded(child: Container(color: ColorVar.background))
          ]
        )
      )
    );
  }
}