// ignore_for_file: must_be_immutable, no_logic_in_create_state, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:toody/pages/stats_page.dart';
import 'package:toody/utilities/colors_var.dart';
import 'package:vibration/vibration.dart';
import 'package:toody/utilities/todo_database.dart';
import 'package:toody/utilities/todo_tile_horizontal.dart';
import 'package:toody/utilities/physics_scroll.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/utilities/notification_utilities.dart';

import 'package:toody/utilities/overlay.dart';

//Da risolvere bug checkbox
class InformationPage extends StatefulWidget {
  int index; //L'indice dell'elemento di cui si stanno visionando i dettagli
  final Function(bool?)? onChanged;
  static late ShakeDetector detector;
  //static late OverlayEntry tutorialoverlay;

  InformationPage({ Key? key, required this.index, required this.onChanged}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState(index, onChanged);
}

class _InformationPageState extends State<InformationPage> {
  int index;
  Function(bool?)? onChanged;
  _InformationPageState(this.index, this.onChanged);
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    InformationPage.detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          if ((overlayTutorial.step==3 || !overlayTutorial.tutorial_mode) && !ToDoDatabase.toDoListOgg[index].taskCompletedData) {
            ScaffoldMessenger.of(context).showSnackBar( //appare snackbar con quante task di oggi ci sono
            SnackBar(
              content: Text('Attività svolta', style: TextStyle(color: ColorVar.textSuPrincipale)),
              duration: const Duration(seconds: 2),
              showCloseIcon: true,
              margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
              behavior: SnackBarBehavior.floating,
              closeIconColor: ColorVar.taskBasic,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
              backgroundColor: ColorVar.principale
            )
          );
          Vibration.vibrate(pattern: [200, 300, 400], intensities: [200, 0, 100]); //vibra
          ToDoDatabase.toDoListOgg[index].taskCompletedData=true;
        if (!overlayTutorial.tutorial_mode) {
                    NotificationUtilities.cancellaNotifica(idNotif: ToDoDatabase.toDoListOgg[index].idNotifify); //cancella notifica di quella task
        }
        ToDoDatabase().updateData();
        HomePage.countTask(); 
        if (overlayTutorial.tutorial_mode) {
          overlayTutorial.removeTutorial(overlayTutorial.overlay);
          overlayTutorial.step+=1;
          Future.delayed(Duration.zero,(){
            overlayTutorial.overlay=overlayTutorial.showTutorial(context, "Puoi scorrere a destra e sinistra, clicca sul riquadro", MediaQuery.of(context).size.height * 0.70);
          });
        }
        }
        });
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 1.7,
    );
     _controller.addListener(() {
      debugPrint(((_controller.position.pixels)/(MediaQuery.of(context).size.width)).toString());
      index=((_controller.position.pixels)/(MediaQuery.of(context).size.width)).ceil();
      debugPrint((((_controller.position.pixels)/(MediaQuery.of(context).size.width)).ceil()).toString());
      });
    super.initState();
  }
  

  void checkboxTask(bool? value, int index) {
    setState(() {
      ToDoDatabase.toDoListOgg[index].taskCompletedData = value!;
      ToDoDatabase().updateData();
    });
  }

  void _refreshDataInformationPage() {
      setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    if (overlayTutorial.tutorial_mode && overlayTutorial.step==6 && !overlayTutorial.tutorial_message_active) {
      overlayTutorial.tutorial_message_active=true;
      Future.delayed(Duration.zero,(){
        overlayTutorial.overlay=overlayTutorial.showTutorial(context, "Clicca sul bottone in basso per visualizzare i dati", MediaQuery.of(context).size.height * 0.70);
      });
    }
    else if (overlayTutorial.tutorial_mode && !overlayTutorial.tutorial_message_active) {
        overlayTutorial.tutorial_message_active=true;
        Future.delayed(Duration.zero,(){
          overlayTutorial.overlay=overlayTutorial.showTutorial(context, "Scuoti per segnare l'attività come svolta", MediaQuery.of(context).size.height * 0.70);
        });
      }
    //Permette di scorrere all'elemento selezionato
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(MediaQuery.of(context).size.width*index,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    });
    return Scaffold(
      backgroundColor: ColorVar.background, // Sfondo
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70, //altezza
            width: MediaQuery.of(context).size.width, //larghezza
            child: ListView.builder(
              controller: _controller,
              physics: PagingScrollPhysics(itemDimension: MediaQuery.of(context).size.width),
              itemCount: ToDoDatabase.toDoListOgg.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return ToDoTileHorizontal(
                  index: index,
                  onChanged: (value) => checkboxTask(value, index),
                  refreshDataInformationPage: _refreshDataInformationPage,
                );
              }
            )
          ),
          Align(
            alignment: Alignment.bottomCenter, //in basso al centro
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10), //margini da sinistra e dal fondo
              child: ElevatedButton(
                onPressed: () {
                  if (overlayTutorial.step==6 || !overlayTutorial.tutorial_mode) {
                    InformationPage.detector.stopListening();
                    if (overlayTutorial.tutorial_mode) {
                      overlayTutorial.tutorial_message_active=false;
                      overlayTutorial.removeTutorial(overlayTutorial.overlay);
                      overlayTutorial.step+=1;
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const StatsPage()), (route) => false);
                    }
                    else {
                      Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const StatsPage()) //bottone rimanda a pagina stats
                      ).then((_) {
                        InformationPage.detector.startListening();
                      });
                    }
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorVar.principale, //colore interno bottone
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5), //spazio tra bordi bottone e contenuto
                  elevation: 10, //ombra bottone
                  shadowColor: ColorVar.principale, //colore ombra bottone
                  foregroundColor: Colors.white
                ), //colore animazione bottone
                child: (HomePage.todayTaskToDo==0) ?
                Text('Hai completato tutte le attività odierne', style: TextStyle(color: ColorVar.textSuPrincipale, fontSize: 18.0))
                :(HomePage.todayTaskToDo==1) ?
                Text("Hai ancora un'attività da completare oggi", style: TextStyle(color: ColorVar.textSuPrincipale, fontSize: 18.0))
                :Text('Hai ancora ${HomePage.todayTaskToDo} attività da completare oggi', style: TextStyle(color: ColorVar.textSuPrincipale, fontSize: 18.0))
              )
            )
          )
        ]
      )
    );
  }
}
