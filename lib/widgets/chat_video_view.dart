import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/chat_video_player_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import 'chat_send_progress_view.dart';

class ChatVideoView extends StatefulWidget {
  final Message message;

  const ChatVideoView({Key? key, required this.message}) : super(key: key);

  @override
  _ChatVideoViewState createState() => _ChatVideoViewState();
}

class _ChatVideoViewState extends State<ChatVideoView> {
  double w = 100.w;
  double h = 100;
  String? snapshotUrl;
  String? snapshotPath;
  String? url;
  String? path;

  @override
  void initState() {
    path = widget.message.videoElem?.videoPath;
    url = widget.message.videoElem?.videoUrl;
    snapshotUrl = widget.message.videoElem?.snapshotUrl;
    snapshotPath = widget.message.videoElem?.snapshotPath;
    double trulyW = widget.message.videoElem?.snapshotWidth?.toDouble() ?? w;
    double trulyH = widget.message.videoElem?.snapshotHeight?.toDouble() ?? h;

    if (trulyW > w) {
      h = trulyH * w / trulyW;
    } else {
      w = trulyW;
      h = trulyH;
    }
    super.initState();
  }

  Widget _buildThumbView() {
    if (_isReceivedMsg()) {
      if (null != snapshotUrl && snapshotUrl!.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: snapshotUrl!,
          width: w,
          height: h,
          fit: BoxFit.fitWidth,
          placeholder: (context, url) => CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => _errorWidget(),
        );
      }
    } else {
      if (null != snapshotPath &&
          snapshotPath!.isNotEmpty &&
          File(snapshotPath!).existsSync()) {
        return Image(
          image: FileImage(File(snapshotPath!)),
          height: h,
          width: w,
          fit: BoxFit.fitWidth,
          errorBuilder: (_, error, stack) => _errorWidget(),
        );
      } else {
        if (null != snapshotUrl && snapshotUrl!.isNotEmpty) {
          return CachedNetworkImage(
            imageUrl: snapshotUrl!,
            width: w,
            height: h,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => CupertinoActivityIndicator(),
            errorWidget: (context, url, error) => _errorWidget(),
          );
        }
      }
    }
    return Container(width: w, height: h);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      color: Color(0xFFB3D7FF),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildThumbView(),
          assetImage('ic_video_play'),
          ChatSendProgressView(
            height: h,
            width: w,
            message: widget.message,
          ),
        ],
      ),
    ).intoGesture(onTap: () {
      NavigatorManager.push(
          context,
          ChatVideoPlayerView(
            path: path,
            url: url,
          ));
    });
  }

  bool _isReceivedMsg() => widget.message.sendID != OpenIM.iMManager.uid;

  static Widget _errorWidget() => assetImage('ic_pic_load_error');
}
