import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:toody/utilities/colors_var.dart';

//per info sulla personalizzazione della notifica sui vari attributi da poter modificare
// https://pub.dev/packages/awesome_notifications#-notification-structures

class NotificationUtilities {

  static Future<void> creaNotifica({required String nome, required String descrizione, required DateTime quando, required int idNotif}) async {

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: idNotif,
        channelKey: "basic_channel", //deve essere stato inizializzato nel main
        title: nome,
        body: descrizione,
        category: NotificationCategory.Alarm, //in base a categoria che gli dai usa suono del dispositivo per quella categoria
        notificationLayout: NotificationLayout.BigText, //layout type della notifica
        locked: true, //indica se impedire all'utente di ignorare la notifica
        wakeUpScreen: true, //se notifica riattiva lo schermo
        autoDismissible: false, //indica se eliminare automaticamente la notifica quando l'utente la tocca
        fullScreenIntent: true, //mostrare le notifiche in popup anche se l'utente sta utilizzando un'altra app.
        backgroundColor: ColorVar.principale,
        color: ColorVar.textBasic, //text color della notifica
      ),
      actionButtons: [NotificationActionButton(key: "Close", label: "Apri TooDy", autoDismissible: true)],
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

  static void cancellaNotifica ({required int idNotif}){
    AwesomeNotifications().cancel(idNotif); //cancella notifica con quel id
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