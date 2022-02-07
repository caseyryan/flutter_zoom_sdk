import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/schedule_meeting.dart';
import 'package:flutter_zoom_sdk_example/start_meeting_screen.dart';

import 'meeting_screen.dart';

class JoinScreenMobile extends StatefulWidget {
  @override
  _JoinScreenMobileState createState() => _JoinScreenMobileState();
}

class _JoinScreenMobileState extends State<JoinScreenMobile> {
  // https://zoom.us/j/97079021528?pwd=aFBkeTVmL3NFM3ZUbDVIZXFKMDQrUT09
  TextEditingController _meetingIdController = TextEditingController(
    text: '97079021528',
  );
  TextEditingController _meetingPasswordController = TextEditingController(
    text: 'aFBkeTVmL3NFM3ZUbDVIZXFKMDQrUT09',
  );

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    return Scaffold(
      appBar: AppBar(
        title: Text('Join meeting mobile'),
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
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _meetingIdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Meeting ID',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _meetingPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () => joinMeeting(context),
                      child: Text('Join'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () => startMeeting(context),
                      child: Text('Start Meeting'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () => scheduleMeeting(context),
                      child: Text('Schedule'),
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

  joinMeeting(BuildContext context) {
    if (_meetingIdController.text.isNotEmpty &&
        _meetingPasswordController.text.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return MeetingScreen(
              meetingId: _meetingIdController.text,
              meetingPassword: _meetingPasswordController.text,
            );
          },
        ),
      );
    } else {
      if (_meetingIdController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      } else if (_meetingPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }
  }

  startMeeting(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return StartMeetingWidget(meetingId: _meetingIdController.text);
        },
      ),
    );
  }

  scheduleMeeting(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ScheduleMeeting(meetingId: _meetingIdController.text);
        },
      ),
    );
  }
}
