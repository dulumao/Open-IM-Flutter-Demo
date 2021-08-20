import 'dart:io';

import 'package:eechart/common/packages.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

class ChatVoiceView extends StatefulWidget {
  final Message message;
  final int index;
  final Subject<int>? subject;

  const ChatVoiceView({
    Key? key,
    required this.message,
    required this.index,
    required this.subject,
  }) : super(key: key);

  @override
  _ChatVoiceViewState createState() => _ChatVoiceViewState();
}

class _ChatVoiceViewState extends State<ChatVoiceView> {
  bool _isPlaying = false;
  bool _isExistSource = false;
  AudioPlayer? _voicePlayer;

  Message get _message => widget.message;

  @override
  void initState() {
    if (_isVoiceType()) {
      _voicePlayer = AudioPlayer();
      _voicePlayer?.playerStateStream.listen((state) {
        switch (state.processingState) {
          case ProcessingState.idle:
          case ProcessingState.loading:
          case ProcessingState.buffering:
          case ProcessingState.ready:
            break;
          case ProcessingState.completed:
            setState(() {
              if (_isPlaying) {
                _isPlaying = false;
                _voicePlayer?.stop();
              }
            });
            break;
        }
      });
      String? path = _message.soundElem?.soundPath;
      String? url = _message.soundElem?.sourceUrl;
      // int? duration = _message.soundElem?.duration;
      if (_isReceivedMsg()) {
        if (null != url && url.isNotEmpty) {
          _isExistSource = true;
          _voicePlayer?.setUrl(url);
        }
      } else {
        if (null != url && url.isNotEmpty) {
          _isExistSource = true;
          _voicePlayer?.setUrl(url);
        } else if (path != null && path.isNotEmpty) {
          var file = File(path);
          if (file.existsSync()) {
            _isExistSource = true;
            _voicePlayer?.setFilePath(path);
          }
        }
      }
    }
    _onItemClick?.stream.listen((i) {
      if (!mounted) return;
      print('click:$i');
      if (_isVoiceType() && _isExistSource) {
        print('sound click:$i');
        if (_isClickedLocation(i)) {
          setState(() {
            if (_isPlaying) {
              print('sound stop:$i');
              _isPlaying = false;
              _voicePlayer?.stop();
            } else {
              print('sound start:$i');
              _isPlaying = true;
              _voicePlayer?.play();
            }
          });
        } else {
          if (_isPlaying) {
            setState(() {
              print('sound stop:$i');
              _isPlaying = false;
              _voicePlayer?.stop();
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _voicePlayer?.dispose();
    super.dispose();
  }

  bool _isClickedLocation(i) => i == widget.index;

  bool _isVoiceType() => _msgType == MessageType.voice;

  int? get _msgType => _message.contentType;

  bool _isReceivedMsg() => _message.sendID != OpenIM.iMManager.uid;

  Subject<int>? get _onItemClick => widget.subject;

  Widget _buildVoiceAnimView() {
    var anim;
    var png;
    var turns;
    if (_isReceivedMsg()) {
      anim = 'assets/anim/voice_black.json';
      png = 'ic_voice_black';
      turns = 0;
    } else {
      anim = 'assets/anim/voice_blue.json';
      png = 'ic_voice_blue';
      turns = 90;
    }
    return Row(
      children: [
        Visibility(
          visible: !_isReceivedMsg(),
          child: Text(
            '${_message.soundElem?.duration ?? 0}``',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF333333),
            ),
          ),
        ),
        _isPlaying
            ? RotatedBox(
                quarterTurns: turns,
                child: Lottie.asset(anim, height: 19.h, width: 18.w),
              )
            : assetImage(png, height: 19.h, width: 18.w),
        Visibility(
          visible: _isReceivedMsg(),
          child: Text(
            '${_message.soundElem?.duration ?? 0}``',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVoiceAnimView();
  }
}
