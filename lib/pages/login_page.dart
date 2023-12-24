import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class login_page extends StatelessWidget {
  login_page({super.key});
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();

  void signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: EmailController.text,
      password: PasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            color: Colors.yellow[200],
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.95, 
                heightFactor: 0.92,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
              Text(
                "Accedi e usa TooDy su più dispositivi",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.blue[700]),
              ),
              TextField(
                controller: EmailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: PasswordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: signIn,
                child: Text(
                  "Accedi",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.blue[700]),
                ),
              ),
            ],
                )
              )
            )
          )
        )
);
  }
}
