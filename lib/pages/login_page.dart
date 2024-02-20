// ignore_for_file: unused_local_variable, no_logic_in_create_state, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toody/utilities/colors_var.dart';
import 'package:toody/utilities/todo_database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.homePageRefresh,
  }) : super(key: key);
  final Function() homePageRefresh;

  @override
  State<LoginPage> createState() => _LoginPageState(homePageRefresh);
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Function() homePageRefresh;
  _LoginPageState(this.homePageRefresh);
  bool _isLoadingSignIn = false;
  bool _isLoadingSignUp = false;
  bool _isLoadingSignOut = false;
  bool _isLoadingBackup = false;
  bool _isLoadingPassRecover = false;

  signIn(context) async {
    setState(() {
      _isLoadingSignIn = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final snackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: ColorVar.principale,
        showCloseIcon: true,
        margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
        behavior: SnackBarBehavior.floating,
        closeIconColor: ColorVar.taskBasic,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
        content: Text("Log in effettuato con l'email ${emailController.text}", style: TextStyle(color: ColorVar.textSuPrincipale))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      homePageRefresh();
      ToDoDatabase().updateData();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      final snackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: ColorVar.principale,
        showCloseIcon: true,
        margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
        behavior: SnackBarBehavior.floating,
        closeIconColor: ColorVar.taskBasic,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
        content: Text(errorDescr(e), style: TextStyle(color: ColorVar.textSuPrincipale))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar); 
    }

    setState(() {
      _isLoadingSignIn = false;
    });
  }

 signUp(context) async {
  setState(() {
    _isLoadingSignUp = true;
  });

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final String currentUserId = firebaseAuth.currentUser!.uid;

    final snackbar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: ColorVar.principale,
      showCloseIcon: true,
      margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
      behavior: SnackBarBehavior.floating,
      closeIconColor: ColorVar.taskBasic,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Text("Registrazione effettuata con l'email ${emailController.text}", style: TextStyle(color: ColorVar.textSuPrincipale))
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    ToDoDatabase().updateData();
    Navigator.pop(context);
         
  } on FirebaseAuthException catch (e) {
    final snackbar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: ColorVar.principale,
      showCloseIcon: true,
      margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
      behavior: SnackBarBehavior.floating,
      closeIconColor: ColorVar.taskBasic,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
      content: Text(errorDescr(e), style: TextStyle(color: ColorVar.textSuPrincipale))
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  
  setState(() {
    _isLoadingSignUp = false;
  });
 }

  String errorDescr (FirebaseAuthException exception){
    debugPrint (exception.toString());
    switch (exception.code) {
      case "email-already-in-use":
        return "L'email è già stata usata per un'altro account";
      case "invalid-email":
        return "L'email inserita non è valida";
      case "user-disabled":
        return "L'utente associato a questa email è disabilitato";
      case "weak-password":
        return "La password usata è troppo semplice (almeno 6 caratteri)";
      case "user-not-found":
        return "Non esiste un account con tale email";
      case "wrong-password":
        return "La password è errata per l'email data";
      case "invalid-credential":
        return "Le credenziali messe sono errate o scadute";
      default:
        return "Errore di autenticazione";
    }
  }

  logOut(context) async {

    setState(() {
      _isLoadingSignOut = true;
    });
    
    await FirebaseAuth.instance.signOut();

    setState(() {
      _isLoadingSignOut = false;
    });

    final snackbar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: ColorVar.principale,
      showCloseIcon: true,
      margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
      behavior: SnackBarBehavior.floating,
      closeIconColor: ColorVar.taskBasic,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
      content: Text("Log out effettuato", style: TextStyle(color: ColorVar.textSuPrincipale))
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  
  recover(String emailRecover) async {

     setState(() {
    _isLoadingPassRecover = true;
    });

    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.sendPasswordResetEmail(email: emailRecover);
      final snackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: ColorVar.principale,
        showCloseIcon: true,
        margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
        behavior: SnackBarBehavior.floating,
        closeIconColor: ColorVar.taskBasic,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
        content: Text("Email di recupero inviata a ${emailController.text}", style: TextStyle(color: ColorVar.textSuPrincipale))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } on FirebaseAuthException catch (e) {
      final snackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: ColorVar.principale,
        showCloseIcon: true,
        margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
        behavior: SnackBarBehavior.floating,
        closeIconColor: ColorVar.taskBasic,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
        content: Text(errorDescr(e), style: TextStyle(color: ColorVar.textSuPrincipale))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar); 
    }

     setState(() {
    _isLoadingPassRecover = false;
  });
  }
  
  backup() {

     setState(() {
      _isLoadingBackup = true;
    });

    ToDoDatabase().updateData();

    setState(() {
      _isLoadingBackup = false;
    });

    final snackbar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: ColorVar.principale,
      showCloseIcon: true,
      margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
      behavior: SnackBarBehavior.floating,
      closeIconColor: ColorVar.taskBasic,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
      content: Text("Backup effettuato", style: TextStyle(color: ColorVar.textSuPrincipale))
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

 @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser!=null) {
      return alreadyLogged(context);
    }
    else {
      return notLogged(context);
    }
  }

 Widget notLogged(BuildContext context) {
   return Scaffold(
    backgroundColor: ColorVar.background,
    resizeToAvoidBottomInset: false,
    body: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 50), //spazio dal container principale
      child: Column(
        children: [
          Material( //material per ombra di profondita
            elevation: 20, //profondita ombre
            shadowColor: ColorVar.taskBasic, //colore ombre
            borderRadius: BorderRadius.circular(20.0), //bordi del material (devono essere gli stessi)
            child: Container(
              decoration: BoxDecoration(color: ColorVar.taskBasic, borderRadius: BorderRadius.circular(20.0)), //bordi tondi
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 15), //spazio tra background e container principale
                child: Column(
                  children: [
                    Text("Accedi e usa TooDy su più dispositivi", style: TextStyle(fontSize: 25.0, color: ColorVar.textSuPrincipale, fontWeight: FontWeight.w500)),
                    TextField(
                      controller: emailController,
                      cursorColor: ColorVar.principale,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize:20, color: ColorVar.principale, fontWeight: FontWeight.w400),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.textBasic)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.principale)))
                    ),
                    const SizedBox(height: 10), //spazio tra textfield email e stringa password
                    TextField(
                      controller: passwordController,
                      cursorColor: ColorVar.principale,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize:20, color: ColorVar.principale, fontWeight: FontWeight.w400),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.textBasic)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorVar.principale)))
                    ),
                    const SizedBox(height: 30), //spazio tra textfield password e bottone accedi
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorVar.textSuPrincipale, //colore interno bottone
                        elevation: 10, //ombra bottone
                        shadowColor: ColorVar.textSuPrincipale, //colore ombra bottone
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(Icons.login, color: ColorVar.principale),
                      label: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Stack(
                          children: [
                            Text("Accedi", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0, color: _isLoadingSignIn ? ColorVar.textSuPrincipale : ColorVar.principale)),
                            if (_isLoadingSignIn) CircularProgressIndicator(backgroundColor: ColorVar.textSuPrincipale, color: ColorVar.principale )
                          ],
                        ),
                      ),
                      onPressed: () => signIn(context),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorVar.textSuPrincipale, //colore interno bottone
                        elevation: 10, //ombra bottone
                        shadowColor: ColorVar.textSuPrincipale, //colore ombra bottone
                        foregroundColor: Colors.black
                      ),
                      icon: const Icon(Icons.account_circle_outlined),
                      label: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Stack(
                          children: [
                            Text("Registrati", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0, color: _isLoadingSignIn ? ColorVar.textSuPrincipale : ColorVar.principale)),
                            if (_isLoadingSignUp) CircularProgressIndicator(backgroundColor: ColorVar.textSuPrincipale, color: ColorVar.principale )
                          ],
                        ),
                      ),
                      onPressed: () => signUp(context),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorVar.textSuPrincipale, //colore interno bottone
                        elevation: 10, //ombra bottone
                        shadowColor: ColorVar.textSuPrincipale, //colore ombra bottone
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(Icons.question_mark, color: ColorVar.principale),
                      label: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text("Password dimenticata", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0, color: _isLoadingSignIn ? ColorVar.textSuPrincipale : ColorVar.principale)),
                            if (_isLoadingPassRecover) CircularProgressIndicator(backgroundColor: ColorVar.textSuPrincipale, color: ColorVar.principale )
                          ],
                        ),
                      ),
                      onPressed: () => recover(emailController.text),
                    ),
                    const SizedBox(height: 20)
                  ]
                )
              )
            )
          ),
          const SizedBox(height: 50),
          Expanded(child: Container(color: ColorVar.background))
        ]
      )
    )
  );
 }

 Widget alreadyLogged(BuildContext context) {
   return Scaffold (
      backgroundColor: ColorVar.background,
      resizeToAvoidBottomInset: false,
      body: Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 50), //spazio dal container principale
      child: Column(
        children: [
          Material( //material per ombra di profondita
            elevation: 20, //profondita ombre
            shadowColor: ColorVar.taskBasic, //colore ombre
            borderRadius: BorderRadius.circular(20.0), //bordi del material (devono essere gli stessi)
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: ColorVar.taskBasic, borderRadius: BorderRadius.circular(20.0)), //bordi tondi
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 15), //spazio tra background e container principale
                child: Column(
                  children: [
                    Text("Log in effettuato", style: TextStyle(fontSize: 25.0, color: ColorVar.textSuPrincipale, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20), //spazio tra textfield password e bottone accedi
                    Text("Email:", style: TextStyle(fontSize:20, color: ColorVar.principale, fontWeight: FontWeight.w500)),
                    Text((FirebaseAuth.instance.currentUser!.email)!, style: TextStyle(fontSize:15, color: ColorVar.principale, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20), //spazio tra textfield email e stringa password
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorVar.textSuPrincipale, //colore interno bottone
                        elevation: 10, //ombra bottone
                        shadowColor: ColorVar.textSuPrincipale, //colore ombra bottone
                        foregroundColor: Colors.black
                      ),
                      icon: const Icon(Icons.backup_outlined),
                      label: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text("Backup", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0, color: _isLoadingSignIn ? ColorVar.textSuPrincipale : ColorVar.principale)),
                            if (_isLoadingBackup) CircularProgressIndicator(backgroundColor: ColorVar.textSuPrincipale, color: ColorVar.principale )
                          ],
                        ),
                      ),
                      onPressed: () => backup(),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorVar.textSuPrincipale, //colore interno bottone
                        elevation: 10, //ombra bottone
                        shadowColor: ColorVar.textSuPrincipale, //colore ombra bottone
                        foregroundColor: Colors.black
                      ),
                      icon: const Icon(Icons.logout),
                      label: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text("Disconettiti", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0, color: _isLoadingSignIn ? ColorVar.textSuPrincipale : ColorVar.principale)),
                            if (_isLoadingSignOut) CircularProgressIndicator(backgroundColor: ColorVar.textSuPrincipale, color: ColorVar.principale )
                          ],
                        ),
                      ),
                      onPressed: () => logOut(context),
                    ),
                    const SizedBox(height: 20)
                  ]
                )
              )
            )
          ),
          const SizedBox(height: 50),
          Expanded(child: Container(color: ColorVar.background))
        ]
      )
    )
  );
 }
}
