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

//Da risolvere bug checkbox
class InformationPage extends StatefulWidget {
  int index; //L'indice dell'elemento di cui si stanno visionando i dettagli
  final Function(bool?)? onChanged;
  static late ShakeDetector detector;
  //static late OverlayEntry tutorialoverlay;

  InformationPage({
    Key? key,
    required this.index,
    required this.onChanged,
    }) : super(key: key);

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
    super.initState();
    InformationPage.detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        if (!HomePage.signal) {
          setState(() {
          ScaffoldMessenger.of(context).showSnackBar( //appare snackbar con quante task di oggi ci sono
            SnackBar(
              content: Text('Attività svolta', style: TextStyle(color: ColorVar.textSuPrincipale)),
              backgroundColor: ColorVar.principale
            )
          );
          Vibration.vibrate(pattern: [200, 300, 400], intensities: [200, 0, 100]); //vibra
        });
        ToDoDatabase.toDoListOgg[index].taskCompletedData=true;
        ToDoDatabase().updateData();
        HomePage.countTask();  
        Navigator.pop(context); //torni alla home
        }
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 1.7,
    );
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
    /*if (overlayTutorial.tutorial_mode && !overlayTutorial.tutorial_message_active) {
      overlayTutorial.tutorial_message_active=true;
      Future.delayed(Duration.zero,(){
        InformationPage.tutorialoverlay=overlayTutorial.showTutorial(context, "Puoi scorrere a destra e sinistra clicca sulla descrizione per modificare", MediaQuery.of(context).size.height * 0.20, 0);
      });
    }*/
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
                  //overlayTutorial.tutorial_message_active=false;
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const StatsPage()) //bottone rimanda a pagina stats
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorVar.principale, //colore interno bottone
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5), //spazio tra bordi bottone e contenuto
                  elevation: 10, //ombra bottone
                  shadowColor: ColorVar.principale, //colore ombra bottone
                  foregroundColor: Colors.white
                ), //colore animazione bottone
                child: Text('Hai ancora ${HomePage.todayTaskToDo} attività da completare oggi', style: TextStyle(color: ColorVar.textSuPrincipale, fontSize: 18.0))
              )
            )
          )
        ]
      ),
    );
  }
}
