import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            color: Colors.yellow[200], //colore background
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.95, 
                heightFactor: 0.92,
                child: Container(decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(20.0)), //colore container principale
                  padding: const EdgeInsets.all(20.0), //spazio vuoto tra limite container giallo e contenuto container
                  child: Column(
                    children: [
                      Text("Accedi e usa TooDy su più dispositivi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.blue[700])),
                      TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                      const SizedBox(height: 10), //spazio tra textfield email e stringa password
                      TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                      const SizedBox(height: 20), //spazio tra textfield password e bottone accedi
                      TextButton(onPressed: signIn, child: Text("Accedi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.blue[700])))
                    ]
                  )
                )
              )
            )
          )
      );
  }
}
