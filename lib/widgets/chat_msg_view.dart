import 'dart:async';
import 'dart:convert';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/chat_bloc.dart';
import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/pages/contacts/add_friend.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/at_text.dart';
import 'package:eechart/widgets/chat_download_progress_view.dart';
import 'package:eechart/widgets/chat_file_view.dart';
import 'package:eechart/widgets/chat_group_layout.dart';
import 'package:eechart/widgets/chat_picture_view.dart';
import 'package:eechart/widgets/chat_single_layout.dart';
import 'package:eechart/widgets/chat_video_view.dart';
import 'package:eechart/widgets/chat_voice_view.dart';
import 'package:eechart/widgets/copy_custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:rxdart/rxdart.dart';

import 'chat_location_view.dart';

class ChatMsgView extends StatefulWidget {
  final Subject<int>? subject;
  final Message message;
  final int index;
  final Function()? onDelete;
  final Function()? onForward;
  final Function()? onRevoke;
  final Function()? onDownload;

  ChatMsgView({
    Key? key,
    this.subject,
    required this.message,
    required this.index,
    this.onDelete,
    this.onForward,
    this.onRevoke,
    this.onDownload,
  }) : super(key: key);

  @override
  _ChatMsgViewState createState() => _ChatMsgViewState();
}

class _ChatMsgViewState extends State<ChatMsgView> {
  late CustomPopupMenuController _popupCtrl;
  late StreamSubscription _sendStatusSubs;

  int? get _msgType => _message.contentType;

  bool _isReceivedMsg() => _message.sendID != OpenIM.iMManager.uid;

  Message get _message => widget.message;

  ChatBloc? bloc;

  @override
  void initState() {
    _sendStatusSubs = subsStream<MsgSendResultEvent>((event) {
      if (!mounted) return;
      if (_message.clientMsgID == event.id) {
        setState(() {
          _message.status =
              event.success ? MessageStatus.succeeded : MessageStatus.failed;
        });
      }
    });
    _popupCtrl = CustomPopupMenuController();
    super.initState();
  }

  @override
  void dispose() {
    _popupCtrl.dispose();
    _sendStatusSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ChatBloc>(context);
    var isGroupChat = bloc?.isGroupChat ?? false;
    switch (_msgType) {
      case MessageType.revoke:
        return _buildTps(S.of(context).msg_tips_1);
    }
    return isGroupChat
        ? ChatGroupLayout(
            child: _buildContentView(),
            index: widget.index,
            message: _message,
            menuBuilder: () => _buildPopMenu(),
            subject: widget.subject!,
            // isSenSuccess: _sendSuccess,
            popupCtrl: _popupCtrl,
            onTapLeftAvatar: () => _clickAvatar(),
            onLongPressLeftAvatar: () {
              bloc?.addAtUser(
                [
                  UserInfo(uid: _message.sendID!, name: _message.senderNickName)
                ],
              );
            },
          )
        : ChatSingleLayout(
      child: _buildContentView(),
            index: widget.index,
            message: _message,
            menuBuilder: () => _buildPopMenu(),
            subject: widget.subject!,
            // isSenSuccess: _sendSuccess,
            popupCtrl: _popupCtrl,
          );
  }

  void _clickAvatar() {
    NavigatorManager.push(
      context,
      BlocProvider(
        bloc: ContactBloc()..checkFriend(_message.sendID!),
        child: SelectResultPage(
          info: UserInfo(
            uid: _message.sendID!,
            icon: _message.senderFaceUrl,
            name: _message.senderNickName,
          ),
        ),
      ),
    );
  }

  _buildPopMenu() => _buildLongPressMenu(onCopy: () {
        longPressCopy(context, _message.content ?? '');
      }, onDel: () {
        if (null != widget.onDelete) widget.onDelete!();
      }, onForward: () {
        if (null != widget.onForward) widget.onForward!();
      }, onRevoke: () {
        if (null != widget.onRevoke) widget.onRevoke!();
      }, onDownload: () {
        if (null != widget.onRevoke) widget.onDownload!();
      });

  Widget _buildContentView() {
    if (_msgType == MessageType.text) {
      return _buildText(_message.content?.trim() ?? '');
    } else if (_msgType == MessageType.picture) {
      return _buildPictureView();
    } else if (_msgType == MessageType.voice) {
      return _buildVoiceAnimView();
    } else if (_msgType == MessageType.video) {
      return _buildVideoView();
    } else if (_msgType == MessageType.file) {
      return _buildFileView();
    } else if (_msgType == MessageType.at_text) {
      String value = _message.content?.trim() ?? '';
      try {
        Map map = json.decode(value);
        value = map['text'];
      } catch (e) {}
      return _buildAtText(value);
    } else if (_msgType == MessageType.revoke) {
      return _buildText('');
    } else if (_msgType == MessageType.location) {
      return ChatLocationView(message: _message);
    }
    /*else if (_msgType == MessageType.accept_friend) {
      String value = _message.content?.trim() ?? '';
      try {
        Map map = json.decode(value);
        value = map['text'];
      } catch (e) {}
      return _buildText(value);
    }*/
    else {
      String value = _message.content?.trim() ?? '';
      if (value.contains("\"defaultTips\":")) {
        try {
          Map map = json.decode(value);
          value = map['defaultTips'];
        } catch (e) {}
      }
      return _buildText(value);
    }
    // return Container();
  }

  Widget _buildAtText(String content) => Container(
        constraints: BoxConstraints(
          maxWidth: 0.5.sw,
        ),
        child: AtText(
          textAlign: _isReceivedMsg() ? TextAlign.left : TextAlign.right,
          text: content,
        ),
      );

  Widget _buildText(String content) => Container(
        constraints: BoxConstraints(
          maxWidth: 0.5.sw,
        ),
        child: Text(
          content,
          textAlign: _isReceivedMsg() ? TextAlign.left : TextAlign.right,
          softWrap: true,
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 14.sp,
          ),
        ),
      );

  Widget _buildTps(String tips) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isReceivedMsg()
                ? _message.senderNickName ?? ''
                : S.of(context).you,
            softWrap: true,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 5),
          Text(
            tips,
            softWrap: true,
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 12.sp,
            ),
          ),
        ],
      );

  Widget _buildPictureView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ChatPictureView(
          // key: UniqueKey(),
          message: widget.message,
        ),
        if (_isReceivedMsg())
          ChatDownloadProgressView(
            stream: bloc?.downloadCtrl.stream,
            message: _message,
          ),
      ],
    );
  }

  Widget _buildVoiceAnimView() {
    return ChatVoiceView(
      // key: UniqueKey(),
      message: widget.message,
      index: widget.index,
      subject: widget.subject,
    );
  }

  Widget _buildVideoView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ChatVideoView(
          // key: UniqueKey(),
          message: widget.message,
        ),
        if (_isReceivedMsg())
          ChatDownloadProgressView(
            stream: bloc?.downloadCtrl.stream,
            message: _message,
          ),
      ],
    );
  }

  Widget _buildFileView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ChatFileView(
          // key: UniqueKey(),
          message: widget.message,
        ),
        if (_isReceivedMsg())
          ChatDownloadProgressView(
            stream: bloc?.downloadCtrl.stream,
            message: _message,
          ),
      ],
    );
  }

  Widget _buildLongPressMenu({
    required Function() onCopy,
    required Function() onDel,
    required Function() onForward,
    required Function() onRevoke,
    required Function() onDownload,
  }) {
    var menus = <Widget>[];
    if (_msgType == MessageType.text) {
      menus.add(SizedBox(width: 9.w));
      menus.add(_copyMenuItem(onCopy));
      menus.add(SizedBox(width: 18.w));
      menus.add(_delMenuItem(onDel));
      menus.add(SizedBox(width: 18.w));
      menus.add(_forwardMenuItem(onForward));
      if (!_isReceivedMsg()) {
        menus.add(SizedBox(width: 18.w));
        menus.add(_revokeMenuItem(onRevoke));
      }
      menus.add(SizedBox(width: 9.w));
    } else if (_msgType == MessageType.picture ||
        _msgType == MessageType.video ||
        _msgType == MessageType.voice ||
        _msgType == MessageType.file) {
      menus.add(SizedBox(width: 9.w));
      menus.add(_delMenuItem(onDel));
      menus.add(SizedBox(width: 18.w));
      menus.add(_forwardMenuItem(onForward));
      if (!_isReceivedMsg()) {
        menus.add(SizedBox(width: 18.w));
        menus.add(_revokeMenuItem(onRevoke));
      } else {
        menus.add(SizedBox(width: 18.w));
        menus.add(_downloadMenuItem(onDownload));
      }
      menus.add(SizedBox(width: 9.w));
    }
    /*else if (_msgType == MessageType.voice) {
      menus.add(SizedBox(width: 18.w));
      menus.add(_delMenuItem(onDel));
      menus.add(SizedBox(width: 18.w));
      menus.add(_revokeMenuItem(onRevoke));
      menus.add(SizedBox(width: 18.w));
    }*/
    else {
      menus.add(SizedBox(width: 18.w));
      menus.add(_delMenuItem(onDel));
      menus.add(SizedBox(width: 18.w));
    }
    return Container(
      padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
      decoration: BoxDecoration(
        color: Color(0xFF666666),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: menus,
      ),
    );
  }

  Widget _copyMenuItem(VoidCallback callback) => _buildMenuItem(
        icon: 'ic_menu_copy',
        label: S.of(context).menu_copy,
      ).intoGesture(onTap: () {
        callback();
        _popupCtrl.hideMenu();
      });

  Widget _delMenuItem(VoidCallback callback) => _buildMenuItem(
        icon: 'ic_menu_del',
        label: S.of(context).menu_del,
      ).intoGesture(onTap: () {
        callback();
        _popupCtrl.hideMenu();
      });

  Widget _forwardMenuItem(VoidCallback callback) => _buildMenuItem(
        icon: 'ic_menu_forward',
        label: S.of(context).menu_forward,
      ).intoGesture(onTap: () {
        callback();
        _popupCtrl.hideMenu();
      });

  Widget _revokeMenuItem(VoidCallback callback) => _buildMenuItem(
        icon: 'ic_menu_revoke',
        label: S.of(context).menu_revoke,
      ).intoGesture(onTap: () {
        callback();
        _popupCtrl.hideMenu();
      });

  Widget _downloadMenuItem(VoidCallback callback) => _buildMenuItem(
        icon: 'ic_menu_download',
        label: S.of(context).download,
      ).intoGesture(onTap: () {
        callback();
        _popupCtrl.hideMenu();
      });

  Widget _buildMenuItem({required String icon, required String label}) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          assetImage(icon),
          SizedBox(
            height: 3.h,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: Colors.white),
          )
        ],
      );
}
