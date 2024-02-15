import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toody/utilities/todo_database.dart';
import 'pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Risolto bug scroll orizzontale dopo navigator.pop
//Colore differente a seconda che attività è da svolgere in giornata oppure no

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TileDataAdapter());  //per ogni tipo prima di usare Hive devi registrare il suo adattatore
  await Hive.openBox('mybox');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  //imposta orientamenti permessi
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);


  await AwesomeNotifications().initialize(
    null, [
      NotificationChannel(
        channelGroupKey: "basic_channel_group",
        channelKey: "basic_channel",
        channelName: "basic notification",
        channelDescription: "basic notification channel"
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "basic_channel_group",
        channelGroupName: "basic group")
    ]
  );
  bool isAllowToSendNotif = await AwesomeNotifications().isNotificationAllowed(); //verifica se ha i permessi per le notifiche
  debugPrint('notifPermesso: $isAllowToSendNotif');

  if(!isAllowToSendNotif){
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

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
      theme: ThemeData(primarySwatch: Colors.lightBlue),
    );
  }
}