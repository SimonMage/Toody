// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:toody/utilities/colors_var.dart';

class overlayTutorial extends StatelessWidget {
  static bool tutorial_mode=false;
  static bool tutorial_message_active=false;

  const overlayTutorial({super.key});
  
  //50 massima larghezza per l'emulatore
  static OverlayEntry showTutorial(BuildContext context, String message, double top, double left) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context)=>Positioned(
        top: top,
        left: left,
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Container(
              padding: const EdgeInsets.only(top:13, bottom: 13, left: 10, right: 15),
              decoration: BoxDecoration(
                border: Border.all(color: ColorVar.taskBasic), //bordi del container gialli
                borderRadius: const BorderRadius.all(Radius.circular(15)), //bordi circolari
                color: ColorVar.taskBasic,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(message),
                ],
              ),
            ),
          ),
      ),
      );

      //if (overlayTutorial.tutorial_mode) {
        overlayState.insert(overlayEntry);
      //}

      //await Future.delayed(Duration(seconds: 2));
      //overlayEntry.remove();
      return overlayEntry;
  }

  static removeTutorial(OverlayEntry overlayEntry) {
    //if (overlayTutorial.tutorial_mode) {
        overlayEntry.remove();
    //}
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}