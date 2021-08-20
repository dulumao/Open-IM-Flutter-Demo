import 'dart:async';

import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class ChatSendProgressView extends StatefulWidget {
  const ChatSendProgressView({
    Key? key,
    required this.width,
    required this.height,
    required this.message,
  }) : super(key: key);

  final double width;
  final double height;

  final Message message;

  @override
  _ChatProgressViewState createState() => _ChatProgressViewState();
}

class _ChatProgressViewState extends State<ChatSendProgressView> {
  late StreamSubscription _progressSubs;
  bool _showSendProgress = false;
  int _progress = 0;

  @override
  void initState() {
    _showSendProgress = widget.message.status == MessageStatus.sending;
    _progressSubs = subsStream<ProgressEvent>((event) {
      if (!mounted) return;
      if (widget.message.clientMsgID == event.id) {
        setState(() {
          _progress = event.progress;
          if (_progress == 100) {
            _showSendProgress = false;
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _progressSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _showSendProgress,
      child: Container(
        height: widget.height,
        width: widget.width,
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.center,
        child: Text(
          '$_progress%',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
