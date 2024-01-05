import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

//per info sulla personalizzazione della notifica sui vari attributi da poter modificare
// https://pub.dev/packages/awesome_notifications#-notification-structures

class NotificationUtilities {

  static void creaNotifica({required String nome, required String descrizione, required DateTime quando}) async {

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(1000000) + 1,
        channelKey: "basic_channel",
        title: nome,
        body: descrizione,
        category: NotificationCategory.Alarm,
        notificationLayout: NotificationLayout.BigText, //layout type della notifica
        locked: true, //indica se impedire all'utente di ignorare la notifica
        wakeUpScreen: true, //se notifica riattiva lo schermo
        autoDismissible: false, //indica se eliminare automaticamente la notifica quando l'utente la tocca
        fullScreenIntent: true, //mostrare le notifiche in popup anche se l'utente sta utilizzando un'altra app.
        backgroundColor: Colors.blue,
        color: Colors.black, //text color della notifica
      ),
      actionButtons: [NotificationActionButton(key: "Close", label: "Chiudi memo", autoDismissible: true)],
      schedule: NotificationCalendar(
        minute: quando.minute,
        hour: quando.hour,
        day: quando.day,
        weekday: quando.weekday,
        month: quando.month,
        year: quando.year,
        preciseAlarm: true, //schedule precise, anche dispositivo con poca batteria
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(), //timezone (fuso orario) identifier
        allowWhileIdle: true //mostra la notifica anche se dispositivo con poca batteria
      )
    );
  }
  
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {}
}
