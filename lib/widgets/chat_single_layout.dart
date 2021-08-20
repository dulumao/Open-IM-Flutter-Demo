import 'package:bubble/bubble.dart';
import 'package:eechart/common/packages.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:rxdart/rxdart.dart';

import 'chat_avatar_view.dart';
import 'copy_custom_pop_up_menu.dart';

class ChatSingleLayout extends StatelessWidget {
  final Message message;

  // final bool isSenSuccess;
  final CustomPopupMenuController popupCtrl;
  final Widget child;
  final int index;
  final Subject<int> subject;
  final Widget Function() menuBuilder;
  final Function()? onTapLeftAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressRightAvatar;

  const ChatSingleLayout({
    Key? key,
    required this.child,
    required this.index,
    required this.message,
    required this.menuBuilder,
    required this.subject,
    // required this.isSenSuccess,
    required this.popupCtrl,
    this.onTapLeftAvatar,
    this.onLongPressLeftAvatar,
    this.onTapRightAvatar,
    this.onLongPressRightAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _layoutAlignment(),
      children: [
        _buildAvatar(
          _senderFaceUrl(),
          _isReceivedMsg,
          onTap: onTapLeftAvatar,
          onLongPress: onLongPressLeftAvatar,
        ),
        _buildSendFailView(
          !_isReceivedMsg,
          fail: message.status == MessageStatus.failed,
        ),
        if (message.status == MessageStatus.succeeded)
          _buildReadStatusView(context),
        CopyCustomPopupMenu(
          controller: popupCtrl,
          barrierColor: Colors.transparent,
          arrowColor: Color(0xFF666666),
          verticalMargin: 0,
          // horizontalMargin: 0,
          child: Bubble(
            margin: BubbleEdges.only(
              left: _isReceivedMsg ? 4.w : 0,
              right: _isReceivedMsg ? 0 : 4.w,
            ),
            // alignment: Alignment.topRight,
            nip: _nip(),
            color: _bubbleColor(),
            child: InkWell(
              child: child,
              onTap: () => _onItemClick?.addSafely(index),
            ),
          ),
          menuBuilder: menuBuilder,
          pressType: PressType.longPress,
        ),
        // _buildSendFailView(isReceivedMsg, fail: !isSenSuccess),
        _buildAvatar(
          loginUserInfo?.icon,
          !_isReceivedMsg,
          onTap: onTapRightAvatar,
          onLongPress: onLongPressRightAvatar,
        ),
      ],
    );
  }

  Subject<int>? get _onItemClick => subject;

  bool get _isReceivedMsg => message.sendID != OpenIM.iMManager.uid;

  MainAxisAlignment _layoutAlignment() =>
      _isReceivedMsg ? MainAxisAlignment.start : MainAxisAlignment.end;

  BubbleNip _nip() =>
      _isReceivedMsg ? BubbleNip.leftCenter : BubbleNip.rightCenter;

  Color _bubbleColor() =>
      _isReceivedMsg ? Color(0xFFF0F0F0) : Color(0xFFDCEBFE);

  Widget _buildAvatar(
    String? url,
    bool show, {
    final Function()? onTap,
    final Function()? onLongPress,
  }) =>
      ChatAvatarView(
        url: url,
        visible: show,
        onTap: onTap,
        onLongPress: onLongPress,
      );

  Widget _buildSendFailView(bool show, {bool fail = false}) => Visibility(
        visible: show && fail,
        child: assetImage('ic_msg_error'),
      );

  String? _senderFaceUrl() {
    var url = groupMemberInfoMap[message.sendID!]?.faceUrl;
    if (null != url && url.isNotEmpty) {
      return url;
    }
    return message.senderFaceUrl;
  }

  String _senderNickname() {
    var name = groupMemberInfoMap[message.sendID!]?.nickName;
    if (null != name && name.isNotEmpty) {
      return name;
    }
    return message.senderNickName ?? '';
  }

  Widget _buildReadStatusView(BuildContext context) {
    bool read = message.isRead ?? false;
    return Visibility(
      visible: !_isReceivedMsg,
      child: Text(
        read ? S.of(context).status_have_read : S.of(context).status_unread,
        style: TextStyle(
          fontSize: 12.sp,
          color: read ? Color(0xFF999999) : Color(0xFF1B72EC),
        ),
      ),
    );
  }
}
