import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{

  await Hive.initFlutter();
  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      localizationsDelegates: const [
         GlobalMaterialLocalizations.delegate
       ],
       supportedLocales: const [
         Locale('it')
       ],
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}