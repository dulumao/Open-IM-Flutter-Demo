import 'dart:async';

import 'package:eechart/common/packages.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class DownloadInfo {
  String msgId;
  int progress;

  DownloadInfo(this.msgId, this.progress);
}

class ChatDownloadProgressView extends StatefulWidget {
  ChatDownloadProgressView({
    Key? key,
    // this.radius = 10,
    this.stream,
    required this.message,
  }) : super(key: key);

  // final double radius;
  final Message message;
  final Stream<DownloadInfo>? stream;

  @override
  _ChatDownloadProgressViewState createState() =>
      _ChatDownloadProgressViewState();
}

class _ChatDownloadProgressViewState extends State<ChatDownloadProgressView> {
  int _progress = 100;

  @override
  void initState() {
    widget.stream?.listen((info) {
      if (!mounted) return;
      if (widget.message.clientMsgID == info.msgId) {
        setState(() {
          _progress = info.progress;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _progress != 100,
      child: Container(
        // height: widget.radius * 2,
        // width: widget.radius * 2,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
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
