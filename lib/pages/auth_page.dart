import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/pages/login_page.dart';

class auth_page extends StatelessWidget {
  const auth_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //L'utente ha eseguito l'accesso
          if (snapshot.hasData) {
            return HomePage();
          }
          //L'utente non ha eseguito l'accesso
          else {
            return login_page();
          }
        },
      ),
    );
  }
}