import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toody/utilities/todo_database.dart';
import 'pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TileDataAdapter());  //per ogni tipo prima di usare Hive devi registrare il suo adattatore
  await Hive.openBox('mybox');

  //imposta orientamenti permessi
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    //delegates localizazzione
    final localizationsDelegates = [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    final supportedLocales = [
      const Locale('it'),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}