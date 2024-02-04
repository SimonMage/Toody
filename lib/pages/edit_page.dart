import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:toody/utilities/todo_database.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  int index; //L'indice dell'elemento di cui si stanno visionando i dettagli
  final Function(bool?)? onChanged;

  
  EditPage({
    Key? key,
    required this.index,
    required this.onChanged,
    }) : super(key: key);
    
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _EditPageState createState() => _EditPageState(index, onChanged);

  static void limitLines(String text, int maxLines, TextEditingController textController)  {
    var lines = text.split('\n');
    if (lines.length > maxLines) {
      lines.removeRange(maxLines, lines.length);
      textController.text = lines.join('\n');
    }
  }
  }


class _EditPageState extends State<EditPage> {
  int index;
  Function(bool?)? onChanged;
  _EditPageState(this.index, this.onChanged);

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: ToDoDatabase.toDoListOgg[index].taskNameData);
    final TextEditingController descrController = TextEditingController(text: ToDoDatabase.toDoListOgg[index].descrData);
    DateTime selectedDate = ToDoDatabase.toDoListOgg[index].taskDateData;
    return Scaffold(
      backgroundColor: Colors.yellow[200], // Sfondo giallo
        body: Column(
          children: [
            TextField(
                controller: nameController,
                maxLength: 15, //limite lunghezza titolo
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Color(0xFF1976D2)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)))
              ),
            TextField(
                controller: descrController,
                maxLength: 100, //limite lunghezza descrizione
                cursorColor: Colors.blue,
                maxLines: 3,  //massima altezza che prende il textfield
                minLines: 1,  //minima altezza che prende il tetxfield
                onChanged: (text) { //chiama la funzione per non far digitare piu di un tot di righe
                  EditPage.limitLines(text, 12, descrController);
                },
                keyboardType: TextInputType.multiline, //appare la tastiera non con invio ma con rimando a capo
                decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    labelStyle: TextStyle(color: Color(0xFF1976D2)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)))
              ),
              Row(
                children: [
                  const Text('Data e Orario:'),
                  TextButton(
                    onPressed: () async {
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

                      if (date == null) {
                        setState(() {
                          selectedDate = ToDoDatabase.toDoListOgg[index].taskDateData;
                        });
                      }
                    },
                    child: const Text('Modifica', style: TextStyle(color: Colors.blue))
                  )
                ]
              ),
              TextButton(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF1976D2)),
              child: const Text('Salva le modifiche'),
              onPressed: () {
                ToDoDatabase.toDoListOgg[index].taskDateData=selectedDate;
                ToDoDatabase.toDoListOgg[index].taskNameData=nameController.text;
                ToDoDatabase.toDoListOgg[index].descrData=descrController.text;
                Navigator.pop(context);
              },
            ),
          ],
        ),
    );
  }

}