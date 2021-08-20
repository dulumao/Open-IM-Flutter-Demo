import 'dart:io';

import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/media_path.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/utils/permissions.dart';
import 'package:lottie/lottie.dart';
import 'package:record/record.dart';

class ChatRecordVoiceView extends StatefulWidget {
  const ChatRecordVoiceView({Key? key}) : super(key: key);

  @override
  _RecordVoiceViewState createState() => _RecordVoiceViewState();
}

class _RecordVoiceViewState extends State<ChatRecordVoiceView> {
  bool _recording = false;
  late String _path;
  int _long = 0;

  void _start() async {
    Permissions.storage(() async {
      _path = '$imCachePath/voice/${_now()}.m4a';
      File file = File(_path);
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      print('_path:$_path');
      _long = _now();
      Record.start(path: _path);
    });
  }

  void _stop() async {
    _long = (_now() - _long) ~/ 1000;
    print('-----------time:${_now() - _long}');
    print('-----------time:$_long');
    bool isRecording = await Record.isRecording();
    if (isRecording) Record.stop();
  }

  int _now() => DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // type: MaterialType.transparency,
      backgroundColor: Color(0xFF333333).withOpacity(0.5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // width: 192.w,
            // height: 119.h,
            padding: EdgeInsets.only(
              top: 40.h,
              bottom: 51.h,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  imageResStr('ic_voice_ic1'),
                ),
              ),
            ),
            child: Lottie.asset('assets/anim/voice_record.json',
                width: 124.w,
                // height: 28.h,
                animate: _recording,
                fit: BoxFit.fitWidth),
          ),
          // assetImage('ic_voice_ic1'),
          SizedBox(
            height: 162.h,
          ),
          Row(
            children: [
              _buildWhiteButton(
                text: S.of(context).cancel,
                callback: () {
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              _buildWhiteButton(
                text: S.of(context).send,
                callback: () {
                  Navigator.pop(
                    context,
                    {"path": _path, "time": _long},
                  );
                },
              )
            ],
          ),
          SizedBox(
            height: 26.h,
          ),
          _buildBlueButton(
            text: S.of(context).talk_longPress,
            onStart: _start,
            onStop: _stop,
          )
        ],
      ).intoContainer(padding: EdgeInsets.symmetric(horizontal: 62.w)),
    );
  }

  Widget _buildWhiteButton({
    required String text,
    required Function() callback,
  }) =>
      Container(
        // padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
        width: 72.w,
        height: 44.h,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ).intoGesture(onTap: callback);

  Widget _buildBlueButton({
    required String text,
    required Function() onStart,
    required Function() onStop,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPressStart: (details) {
          setState(() {
            _recording = true;
            onStart();
          });
        },
        onLongPressEnd: (details) {
          setState(() {
            _recording = false;
            onStop();
          });
        },
        onLongPressMoveUpdate: (details) {},
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
          // width: 252.w,
          height: 45.h,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          decoration: BoxDecoration(
            color: _recording ? Colors.grey : Color(0xFF1B72EC),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
}

Future<dynamic> recordVoice({required BuildContext context}) {
  return NavigatorManager.showPageDialog(context, ChatRecordVoiceView());
  // return showDialog(
  //   context: context,
  //   builder: (_) => RecordVoiceView(),
  //   barrierColor: Colors.transparent,
  // );
}
