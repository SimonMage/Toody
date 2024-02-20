import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toody/pages/home_page.dart';
import 'package:toody/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    Key? key,
    required this.homePageRefresh,
  }) : super(key: key);
  final Function() homePageRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //L'utente ha eseguito l'accesso
          if (snapshot.hasData) {
            return const HomePage();
          }
          //L'utente non ha eseguito l'accesso
          else {
            return LoginPage(homePageRefresh: homePageRefresh);
          }
        }
      )
    );
  }
}