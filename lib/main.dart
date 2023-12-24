import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await Hive.initFlutter();
  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');
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