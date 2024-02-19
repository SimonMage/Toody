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
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoadingSignIn = false;
  bool _isLoadingSignUp = false;


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
        content: Text("Log in effettuato con la mail ${emailController.text}", style: TextStyle(color: ColorVar.textSuPrincipale))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
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

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    final snackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: ColorVar.principale,
        showCloseIcon: true,
        margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
        behavior: SnackBarBehavior.floating,
        closeIconColor: ColorVar.taskBasic,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
        content: Text("Registrazione effettuata con la mail ${emailController.text}", style: TextStyle(color: ColorVar.textSuPrincipale))
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
        return "Non esiste un account con tale mail";
      case "wrong-password":
        return "La password è errata per la mail data";
      case "invalid-credential":
        return "Le credenziali messe sono errate o scadute";
      default:
        return "Errore di autenticazione";
    }
  }

 //impaginazione vecchia funzionante 100%
  Widget buildAlternativa(BuildContext context) {
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
                      TextButton(onPressed: () => signIn(context), child: Text("Accedi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.blue[700]))),
                      TextButton(onPressed: () => signUp(context), child: Text("Registrati", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.blue[700])))
                    ]
                  )
                )
              )
            )
          )
      );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorVar.background,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 35), //spazio dal container principale
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
                      Text("Accedi e usa TooDy su più dispositivi", style: TextStyle(fontSize: 25.0, color: ColorVar.principale, fontWeight: FontWeight.w500)),
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
                      const SizedBox(height: 20), //spazio tra textfield password e bottone accedi
                       TextButton(
                        onPressed: () => signIn(context),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text("Accedi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: _isLoadingSignIn ? ColorVar.taskBasic : ColorVar.principale)),
                            if (_isLoadingSignIn) CircularProgressIndicator(backgroundColor: ColorVar.textSuPrincipale, color: ColorVar.principale )
                          ]
                        )
                      ),
                      TextButton(
                        onPressed: () => signUp(context),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [ 
                            Text("Registrati", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: _isLoadingSignUp ? ColorVar.taskBasic : ColorVar.principale)),
                            if (_isLoadingSignUp) CircularProgressIndicator(backgroundColor: ColorVar.textSuPrincipale, color: ColorVar.principale)
                          ]  
                        )
                      ),
                      const SizedBox(height: 10)
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
