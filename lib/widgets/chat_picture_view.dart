import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/date_util.dart';
import 'package:eechart/utils/media_path.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/chat_picture_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import 'chat_send_progress_view.dart';

class ChatPictureView extends StatefulWidget {
  const ChatPictureView({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  _ChatPictureViewState createState() => _ChatPictureViewState();
}

class _ChatPictureViewState extends State<ChatPictureView> {
  String? _sourcePath;
  String? _sourceUrl;
  String? _snapshotPath;
  String? _snapshotUrl;
  late double _width;
  late double _height;

  late String _tag;

  @override
  void initState() {
    var msg = widget.message;
    _sourcePath = msg.pictureElem?.sourcePath;
    _sourceUrl = msg.pictureElem?.sourcePicture?.url;
    _snapshotUrl = msg.pictureElem?.snapshotPicture?.url;
    var w = msg.pictureElem?.sourcePicture?.width ?? 1;
    var h = msg.pictureElem?.sourcePicture?.height ?? 1;
    _width = 100.w;
    _height = _width * h / w;

    _tag = '${DateUtil.getNowDateMs()}';
    MediaPath.getSmallPicPath(
      sourcePath: _sourcePath,
      minWidth: _width.toInt(),
      minHeight: _height.toInt(),
    ).then((path) {
      if(!mounted) return;
      setState(() {
        _snapshotPath = path;
      });
    });
    super.initState();
  }

  Widget _snapshotPicView() => CachedNetworkImage(
        imageUrl: _snapshotUrl!,
        height: _height,
        width: _width,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => Container(
          width: 20,
          height: 20,
          child: CupertinoActivityIndicator(),
        ),
        errorWidget: (context, url, error) => _errorWidget(),
      );

  Widget _sourcePicView() => CachedNetworkImage(
        imageUrl: _sourceUrl!,
        height: _height,
        width: _width,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => Container(
          width: 20,
          height: 20,
          child: CupertinoActivityIndicator(),
        ),
        errorWidget: (context, url, error) => _errorWidget(),
      );

  Widget _pathPicView() => null == _snapshotPath
      ? Container(
          height: _height,
          width: _width,
          // child: assetImage('ic_pic_load_error'),
        )
      : Stack(
          children: [
            Image(
              image: FileImage(File(_snapshotPath!)),
              height: _height,
              width: _width,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, error, stack) => _errorWidget(),
            ),
            ChatSendProgressView(
              height: _height,
              width: _width,
              message: widget.message,
            ),
          ],
        );

  Widget _buildChildView() {
    Widget? child;
    if (_priorityUrl) {
      if (null != _snapshotUrl && _snapshotUrl!.isNotEmpty) {
        child = _snapshotPicView();
      } else if (null != _sourceUrl && _sourceUrl!.isNotEmpty) {
        child = _sourcePicView();
      } else if (null != _sourcePath && _sourcePath!.isNotEmpty) {
        child = _pathPicView();
      }
    } else {
      if (null != _sourcePath &&
          _sourcePath!.isNotEmpty &&
          File(_sourcePath!).existsSync()) {
        child = _pathPicView();
      } else if (null != _snapshotUrl && _snapshotUrl!.isNotEmpty) {
        child = _snapshotPicView();
      } else if (null != _sourceUrl && _sourceUrl!.isNotEmpty) {
        child = _sourcePicView();
      }
    }
    return child ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(tag: _tag, child: _buildChildView()),
    ).intoGesture(onTap: () {
      NavigatorManager.push(
        context,
        PicturePreview(url: _sourceUrl, path: _sourcePath, tag: _tag),
      );
    });
  }

  static Widget _errorWidget() => assetImage('ic_pic_load_error');

  bool get _priorityUrl => widget.message.sendID != OpenIM.iMManager.uid;
}
