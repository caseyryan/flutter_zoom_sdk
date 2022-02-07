import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/schedule_meeting.dart';
import 'package:flutter_zoom_sdk_example/start_meeting_screen.dart';

import 'join_screen_mobile.dart';
import 'join_screen_web.dart';
import 'meeting_screen.dart';

// for complete example see https://github.com/evilrat/flutter_zoom_sdk/tree/master/example

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example Zoom SDK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [ ],
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) {
          if (kIsWeb) {
            return JoinScreenWeb();
          }
          return JoinScreenMobile();
        },
        '/meeting': (context) {
          if (kIsWeb) {
            return JoinScreenWeb();
          }
          return MeetingScreen();
        },
        '/startmeeting': (context) => StartMeetingWidget(),
        '/schedule': (context) => ScheduleMeeting(),
      },
    );
  }
}
