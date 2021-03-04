import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:custom_local_notification/Notification/notificationHelper.dart';
import 'package:custom_local_notification/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CustomizedNotification extends StatefulWidget {
  @override
  _CustomizedNotificationState createState() => _CustomizedNotificationState();
}

class _CustomizedNotificationState extends State<CustomizedNotification> {
  String startTime = "";
  String endTime = "";

  var dateTimeNow = DateTime.now();

  @override
  void initState() {
    super.initState();
    getTime();
  }

  static periodicCallback() {
    NotificationHelper().showNotificationBtweenInterval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              /*Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Notification Start From",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        startTime,
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Notification Stop From",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        endTime,
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),*/
              Expanded(
                flex: 2,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*Container(
                        height: 50,
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () async {

                            onTimePeriodic();
                          },
                          child: Text(
                            "Okay , Trigger Alarm",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),*/
                      Text('Time ${dateTimeNow.toString()}'),
                      FlatButton(
                          onPressed: () {
                            DatePicker.showTimePicker(context, showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) async {

                              setState(() {
                                dateTimeNow = date;
                              });

                              //getNotification(1, 'รายชื่อยาที่รับประทาน', '1');
                              /*await AndroidAlarmManager.oneShotAt(
                                  date,
                                  1,
                                  getNotification(1, 'รายชื่อยาที่รับประทาน', '1'),
                                  exact: true,
                                  wakeup: true,
                                  allowWhileIdle: true,
                                  alarmClock: true);*/

                              //await AndroidAlarmManager.periodic(Duration(seconds: 15), 0, getNotification(1, 'รายชื่อยาที่รับประทาน', '1'));
                              await AndroidAlarmManager.oneShotAt(date, 0, periodicCallback);


                              print('confirm $date');

                            }, currentTime: DateTime.now());
                          },
                          child: Text(
                            'show time picker',
                            style: TextStyle(color: Colors.blue),
                          )
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // getD(){
  //   SharedPreferences.getInstance().then((value) {
  //     var a = value.getString('dai');
  //     print(a);
  //   });
  // }

  //   Future sujan() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.setString("dai", "lado");
  // }

  onTimePeriodic() {
    SharedPreferences.getInstance().then((value) async {
      var a = value.getBool('oneTimePeriodic') ?? false;
      if (!a) {
        await AndroidAlarmManager.periodic(Duration(seconds: 10), 0, periodicCallback);
        onlyOneTimePeriodic();
      } else {
        print("Cannot run more than once");
      }
    });
  }

  getTime() {
    SharedPreferences.getInstance().then((value) {
      var a = value.getString('startTime');
      var b = value.getString('endTime');
      if (a != null && b != null) {
        setState(() {
          startTime = DateFormat('jm').format(DateTime.parse(a));
          endTime = DateFormat('jm').format(DateTime.parse(b));
        });
      }
    });
  }
}
