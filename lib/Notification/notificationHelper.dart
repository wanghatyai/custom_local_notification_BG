import 'package:custom_local_notification/sharedPrefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {

  var reminderStatusText;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  static BuildContext context;
  SharedPreferences sharedPreferences;

  NotificationHelper() {
    initializedNotification();
  }

  initializedNotification() async {
    /*androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);*/
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    /*flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification);*/
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payLoad) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('OKay'),
                  onPressed: () {
                    // do something here
                  },
                )
              ],
            )
    );
  }

  Future<void> showNotificationBtweenInterval() async {
    await initSharedPrefs();
    //await notificationCompare();

    var now = DateTime.now();
    var currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    var a = sharedPreferences.getString('startTime');
    var b = sharedPreferences.getString('endTime');
    print(a);
    print(b);
    print(currentTime);

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel_Id',
      'Channel Name',
      'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
      ticker: 'test ticker',
      playSound: true,
    );

    //IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    //NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails);

    /*if (DateTime.parse(a).millisecondsSinceEpoch > currentTime.millisecondsSinceEpoch) {
      print("current Time is less than startTime so  , Cannot play notification");
      await flutterLocalNotificationsPlugin.cancel(0);
    }*/

    /*if (currentTime.millisecondsSinceEpoch >= DateTime.parse(a).millisecondsSinceEpoch
        && currentTime.millisecondsSinceEpoch <= DateTime.parse(b).millisecondsSinceEpoch) {

      print('play notification');
      await flutterLocalNotificationsPlugin.show(
          0,
          "Hello there!",
          "Plaease subscribe my channel",
          notificationDetails);
    }*/

    print('play notification');
    await flutterLocalNotificationsPlugin.show(
        0,
        "แจ้งเตือนรับประทานยา!",
        "ถึงเวลากินยาแล้วค่ะ",
        platformChannelSpecifics);

    /*if (currentTime.millisecondsSinceEpoch > DateTime.parse(b).millisecondsSinceEpoch) {
      print("current time is greater than end time so, cannto play notification");
      await flutterLocalNotificationsPlugin.cancel(0);
    }*/
  }

  /*getNotification(index, reminderCode, reminderStatus)async{

    if(reminderStatus == '1'){
      reminderStatusText = 'ถึงเวลากินยาแล้วค่ะ';
    }else if(reminderStatus == '2'){
      reminderStatusText = 'กินยาทันที';
    }

    print(reminderStatusText);

    //var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1',
        'reminder',
        'แจ้งเตือนกินยา',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        index,
        'รายการยา : $reminderCode',
        'สถานะ : $reminderStatusText',
        //scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: '$reminderCode'
    );
  }*/

  Future notificationCompare() async {
    await initSharedPrefs();
    var now = DateTime.now();
    var currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    var a = sharedPreferences.getString('startTime');
    var b = sharedPreferences.getString('endTime');

    var onlyCurrentDate = currentTime.toString().substring(0, 10);
    var onlyStartDate = a.toString().substring(0, 10);
    var onlyEndDate = b.toString().substring(0, 10);

    if (onlyEndDate == onlyCurrentDate && onlyStartDate == onlyCurrentDate) {
      print("same date");
      print(a.substring(11, 13));
    } else {
      print('date different');
      String startHour = a.substring(11, 13);
      String endHour = b.substring(11, 13);
      var setStart = DateTime(now.year, now.month, now.day, int.parse(startHour), 00);
      await setStartTime(setStart);
      var setEnd = DateTime(now.year, now.month, now.day, int.parse(endHour), 00);
      await setEndTime(setEnd);
    }
  }

  Future initSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
