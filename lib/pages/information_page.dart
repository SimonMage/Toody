import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:toody/utilities/todo_tile_horizontal.dart';
import 'package:toody/utilities/physics_scroll.dart';


//Da risolvere bug checkbox
// ignore: must_be_immutable
class InformationPage extends StatefulWidget {
  int index; //L'indice dell'elemento di cui si stanno visionando i dettagli
  final Function(bool?)? onChanged;
  int taskDay; //numero di task del giorno corrente che ci sono

  InformationPage({
    Key? key,
    required this.index,
    required this.onChanged,
    required this.taskDay
    }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _InformationPageState createState() => _InformationPageState(index, onChanged, taskDay);
  }

class _InformationPageState extends State<InformationPage> {
  int index;
  Function(bool?)? onChanged;
  int taskDay;
  _InformationPageState(this.index, this.onChanged, this.taskDay);

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
            ScaffoldMessenger.of(context).showSnackBar( //appare snackbar con quante task di oggi ci sono
               const SnackBar(
                content: Text('Attività svolta', style: TextStyle(color: Colors.white)),
                backgroundColor: Color.fromRGBO(25, 118, 210, 1)
                )
              );
            Vibration.vibrate(pattern: [200, 300, 400], intensities: [200, 0, 100]); //vibra
          
        });
        ToDoDatabase.toDoListOgg[index].taskCompletedData=true;

        //index=(_controller.offset/MediaQuery.of(context).size.width).round();
        //print(index);
        //setState(() {
        //  ToDoDatabase.toDoListOgg[index].taskCompletedData=true;
        //});
        
        Navigator.pop(context); //torni alla home
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 1.7,
    );
    super.initState();
  }
  

  /*
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
  }*/
  void checkboxTask(bool? value, int index) {
    setState(() {
      ToDoDatabase.toDoListOgg[index].taskCompletedData = value!;
      ToDoDatabase().updateData();
    });
  }

@override
  Widget build(BuildContext context) {
    //Permette di scorrere all'elemento selezionato
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.offset + MediaQuery.of(context).size.width*index,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    });
    return Scaffold(
        backgroundColor: Colors.yellow[200], // Sfondo giallo
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
              controller: _controller,
              physics: PagingScrollPhysics(itemDimension: MediaQuery.of(context).size.width),
              itemCount: ToDoDatabase.toDoListOgg.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ToDoTileHorizontal(
                    index: index,
                    onChanged: (value) => checkboxTask(value, index),
                  );
                }
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft, //in basso a sinistra
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 10), //margini da sinistra e dal fondo
                child: Text('Hai ancora $taskDay task oggi', style: const TextStyle(color: Colors.blue, fontSize: 18.0))
                ),
            ),
          ]
        ),
      );
  }

}
