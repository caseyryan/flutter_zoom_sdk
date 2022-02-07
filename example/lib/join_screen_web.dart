import 'dart:async';
import 'dart:convert';
import 'dart:html' hide Platform;
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk/zoom_web.dart';

const jwtAPIKey = "tYcFMsdEXBkW9oXrK39xbkzEtNkhZPxbbjeb";
const jwtAPISecret = "bi43TIfWjS2tuWd48Htw0gPoGcZENzMNQmUQ";

class JoinScreenWeb extends StatefulWidget {
  @override
  _JoinScreenWebState createState() => _JoinScreenWebState();
}

class _JoinScreenWebState extends State<JoinScreenWeb> {
  TextEditingController _meetingIdController = TextEditingController(
    text: '7756607548',
    // text: '91907195190',
  );
  TextEditingController _meetingPasswordController = TextEditingController(
    // text: 'NEV2YUVRTjFYamQyblJkb01lbmhCdz09',
    text: '',
  );
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join meeting web'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: TextField(
                  controller: _meetingIdController,
                  decoration: InputDecoration(
                    labelText: 'Meeting ID',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: TextField(
                  controller: _meetingPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Meeting Password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    return MaterialButton(
                      onPressed: () => _joinMeeting(context),
                      child: Text('Join'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    return MaterialButton(
                      onPressed: () {
                        return startMeeting(context);
                      },
                      child: Text('Start Meeting'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isMeetingEnded(String status) {
    if (Platform.isAndroid)
      return status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    return status == "MEETING_STATUS_ENDED";
  }

  String generateSignature(
    String apiKey,
    String apiSecret,
    String meetingNumber,
    int role,
  ) {
    final timestamp = DateTime.now().millisecondsSinceEpoch - 30000;
    var str = '${apiKey}${meetingNumber}${timestamp}${role}';
    var bytes = utf8.encode(str);
    final msg = base64.encode(bytes);

    final key = utf8.encode(apiSecret);
    final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    final digest = hmacSha256.convert(utf8.encode(msg));
    final hash = base64.encode(digest.bytes);

    str = '${apiKey}.${meetingNumber}.${timestamp}.${role}.${hash}';
    bytes = utf8.encode(str);
    final signature = base64.encode(bytes);
    return signature.replaceAll(new RegExp("="), "");
  }

  void _joinMeeting(BuildContext context) {
    ZoomOptions zoomOptions = new ZoomOptions(
        domain: "zoom.us",
        appKey: jwtAPIKey,
        appSecret: jwtAPISecret,
        language: "en-US", // Optional
        showMeetingHeader: true, // Optional
        disableInvite: true, // Optional
        disableCallOut: false, // Optional
        disableRecord: false, // Optional
        disableJoinAudio: false, // Optional
        audioPanelAlwaysOpen: false, // Optional
        isSupportAV: true, // Optional
        isSupportChat: false, // Optional
        isSupportQA: true, // Optional
        isSupportCC: true, // Optional
        isSupportPolling: true, // Optional
        isSupportBreakout: true, // Optional
        screenShare: false, // Optional
        rwcBackup: '', // Optional
        videoDrag: true, // Optional
        sharingMode: 'both', // Optional
        videoHeader: true, // Optional
        isLockBottom: true, // Optional
        isSupportNonverbal: true, // Optional
        isShowJoiningErrorDialog: true, // Optional
        disablePreview: false, // Optional
        disableCORP: true, // Optional
        inviteUrlFormat: '', // Optional
        disableVOIP: false, // Optional
        disableReport: true, // Optional
        meetingInfo: const [
          'topic',
          'host',
          'mn',
          'pwd',
          'telPwd',
          'invite',
          'participant',
          'dc',
          'enctype',
          'report'
        ]);

    var meetingOptions = new ZoomMeetingOptions(
      userId: 'username',
      meetingId: _meetingIdController.text,
      meetingPassword: _meetingPasswordController.text,
      disableDialIn: "true",
      disableDrive: "true",
      disableInvite: "true",
      disableShare: "true",
      noAudio: "false",
      noDisconnectAudio: "false",

    );
    var zoom = ZoomWeb();

    zoom.initZoom(zoomOptions).then((results) {
      if (results[0] == 0) {
        // zoom.onMeetingStatus().listen((status) {
        //   print("Meeting Status Stream: " + status[0] + " - " + status[1]);
        //   if (_isMeetingEnded(status[0])) {
        //     timer?.cancel();
        //   }
        // });

        var zr = window.document.getElementById("zmmtg-root");
        if (zr != null) {
          querySelector('body')?.append(zr);
        }
        final signature = generateSignature(
          jwtAPIKey,
          jwtAPISecret,
          _meetingIdController.text,
          1,
        );
        meetingOptions.jwtAPIKey = jwtAPIKey;
        // meetingOptions.jwtSignature = signature;
        // meetingOptions.jwtAPIKey = '';
        meetingOptions.jwtSignature = '';
        

        zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
          timer = Timer.periodic(new Duration(seconds: 2), (timer) {
            zoom.meetingStatus(meetingOptions.meetingId).then((status) {
              print("Meeting Status Polling: " + status[0] + " - " + status[1]);
            });
          });
        });
      }
    });
  }

  void startMeeting(BuildContext context) {
    print('start meeting');
  }
}
