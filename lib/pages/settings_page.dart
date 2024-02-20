import 'package:flutter/material.dart';
import 'package:toody/utilities/colors_var.dart';


//Da risolvere bug checkbox
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Impostazioni")),
      body: Row(
        children: [
          TextButton(
              onPressed: () {},
              child: Container( //bordi bottone login tondi
                decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 59, 209, 255)),borderRadius: const BorderRadius.all(Radius.circular(5)),color: Colors.yellow),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AuthPage()));
                      },
                      child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: ColorVar.principale)))
                  ]
                )
              ))
        ]
      )
    );
  }
}
