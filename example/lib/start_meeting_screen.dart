import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';

// ignore: must_be_immutable
class StartMeetingWidget extends StatefulWidget {

  late ZoomOptions zoomOptions;
  late ZoomMeetingOptions loginOptions;


  StartMeetingWidget({Key? key, meetingId}) : super(key: key) {
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "tYcFMsdEXBkW9oXrK39xbkzEtNkhZPxbbjeb",
      appSecret: "bi43TIfWjS2tuWd48Htw0gPoGcZENzMNQmUQ",
    );
    this.loginOptions = new ZoomMeetingOptions(
        userId: 'Some Coolguy',
        meetingPassword: '',
        meetingId: '',
        disableDialIn: "false",
        disableDrive: "false",
        disableInvite: "false",
        disableShare: "false",
        disableTitlebar: "false",
        viewOptions: "false",
        noAudio: "false",
        noDisconnectAudio: "false"
    );
  }

  @override
  _StartMeetingWidgetState createState() => _StartMeetingWidgetState();
}

class _StartMeetingWidgetState extends State<StartMeetingWidget> {
  late Timer timer;

  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid)
      result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
    else
      result = status == "MEETING_STATUS_IDLE";

    return result;
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
          title: Text('Loading meeting '),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _isLoading ? CircularProgressIndicator() : Container(),
            Expanded(
              child: ZoomView(onViewCreated: (controller) {

                print("Created the view");

                controller.initZoom(this.widget.zoomOptions)
                    .then((results) {
                  print(results);

                  if(results[0] == 0) {

                    controller.zoomStatusEvents.listen((status) {
                      print("Meeting Status Stream: " + status[0] + " - " + status[1]);
                      if (_isMeetingEnded(status[0])) {
                        Navigator.pop(context);
                        timer.cancel();
                      }
                    });

                    print("listen on event channel");

                    controller.login(this.widget.loginOptions).then((loginResult) {
                      print("LoginResultBool :- " + loginResult.toString());
                      if(loginResult){
                        print("LoginResult :- Logged In");
                        setState(() {
                          _isLoading = false;
                        });
                      }else{
                        print("LoginResult :- Logged In Failed");
                      }
                    });
                  }

                }).catchError((error) {
                  print(error);
                });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
