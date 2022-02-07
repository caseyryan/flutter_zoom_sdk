import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zoom_platform_interface/zoom_platform_interface.dart';

import 'js_interop.dart';
import 'zoom_js.dart';

export 'package:zoom_platform_interface/zoom_platform_interface.dart'
    show ZoomOptions, ZoomMeetingOptions;

class ZoomWeb extends ZoomPlatform {
  StreamController<dynamic>? streamController;
  static void registerWith(Registrar registrar) {
    ZoomPlatform.instance = ZoomWeb();
  }

  @override
  Future<List> initZoom(ZoomOptions options) async {
    final Completer<List> completer = Completer();
    var sus = ZoomMtg.checkSystemRequirements();
    var susmap = convertToDart(sus);
    print(susmap);

    ZoomMtg.i18n.load(options.language);
    ZoomMtg.preLoadWasm();
    ZoomMtg.prepareWebSDK();
    ZoomMtg.init(InitParams(
        leaveUrl: "/index.html",
        showMeetingHeader: options.showMeetingHeader,
        disableInvite: options.disableInvite,
        disableCallOut: options.disableCallOut,
        disableRecord: options.disableRecord,
        disableJoinAudio: options.disableJoinAudio,
        audioPanelAlwaysOpen: options.audioPanelAlwaysOpen,
        isSupportAV: options.isSupportAV,
        isSupportChat: options.isSupportChat,
        isSupportQA: options.isSupportQA,
        isSupportCC: options.isSupportCC,
        isSupportPolling: options.isSupportPolling,
        isSupportBreakout: options.isSupportBreakout,
        screenShare: options.screenShare,
        rwcBackup: options.rwcBackup,
        videoDrag: options.videoDrag,
        sharingMode: options.sharingMode,
        videoHeader: options.videoHeader,
        isLockBottom: options.isLockBottom,
        isSupportNonverbal: options.isSupportNonverbal,
        isShowJoiningErrorDialog: options.isShowJoiningErrorDialog,
        disablePreview: options.disablePreview,
        disableCORP: options.disableCORP,
        inviteUrlFormat: options.inviteUrlFormat,
        disableVoIP: options.disableVOIP,
        disableReport: options.disableReport,
        meetingInfo: options.meetingInfo,
        success: allowInterop((var res) {
          completer.complete([0, 0]);
        }),
        error: allowInterop((var res) {
          completer.complete([1, 0]);
        })));
    return completer.future;
  }

  @override
  Future<bool> startMeeting(ZoomMeetingOptions options) async {
    return false;
  }

  @override
  Future<bool> joinMeeting(ZoomMeetingOptions options) async {
    final Completer<bool> completer = Completer();
    // final signature = ZoomMtg.generateSignature(SignatureParams(
    //     meetingNumber: options.meetingId,
    //     apiKey: options.jwtAPIKey!,
    //     apiSecret: "ApiKey",
    //     role: 0));
    ZoomMtg.join(
      JoinParams(
        meetingNumber: options.meetingId,
        userName: options.displayName != null ? options.displayName : options.userId,
        signature: options.jwtSignature,
        apiKey: options.jwtAPIKey,
        passWord: options.meetingPassword,
        success: allowInterop((var res) {
          completer.complete(true);
        }),
        error: allowInterop(
          (var res) {
            completer.complete(false);
          },
        ),
      ),
    );
    return completer.future;
  }

  @override
  Future<List> meetingStatus(String meetingId) async {
    return ["a", "b"];
  }

  @override
  Stream<dynamic> onMeetingStatus() {
    // final Completer<bool> completer = Completer();
    streamController?.close();
    streamController = StreamController<dynamic>();
    ZoomMtg.inMeetingServiceListener('onMeetingStatus', allowInterop((status) {
      //print(stringify(MeetingStatus status));
      var r = List<String>.filled(2, "");
      // 1(connecting), 2(connected), 3(disconnected), 4(reconnecting)
      switch (status.meetingStatus) {
        case 1:
          r[0] = "MEETING_STATUS_CONNECTING";
          break;
        case 2:
          r[0] = "MEETING_STATUS_INMEETING";
          break;
        case 3:
          r[0] = "MEETING_STATUS_DISCONNECTING";
          break;
        case 4:
          r[0] = "MEETING_STATUS_INMEETING";
          break;
        default:
          r[0] = status.meetingStatus.toString();
          break;
      }
      streamController!.add(r);
    }));
    return streamController!.stream;
  }
}
