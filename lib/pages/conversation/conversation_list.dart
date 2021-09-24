import 'dart:convert';

import 'package:eechart/blocs/chat_bloc.dart';
import 'package:eechart/blocs/conversation_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/pages/chat/chat.dart';
import 'package:eechart/utils/date_util.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/copy_custom_pop_up_menu.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  late ConversationBloc _bloc;

  @override
  void initState() {
    _bloc = new ConversationBloc()..getAllConversationList();
    super.initState();
  }

  Widget _buildItem({required ConversationInfo info}) => Slidable(
        actionPane: SlidableScrollActionPane(),
        actionExtentRatio: 0.2,
        child: Container(
          color: info.isPinned == 1 ? Color(0xFFEFF5FE) : null,
          height: 73.h,
          padding: EdgeInsets.symmetric(horizontal: 22.h),
          child: Row(
            children: [
              ChatAvatarView(size: 48.w, url: info.faceUrl),
              SizedBox(
                width: 12.w,
              ),
              Container(
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(color: Color(0xFFE5EBFF), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          info.showName ?? info.latestMsg?.senderNickName ?? '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          _lastMsg(info: info),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ).intoExpanded(),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateUtil.getChatTime(info.latestMsgSendTime ?? 0),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF999999),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        buildRedDot(count: info.unreadCount ?? 0),
                      ],
                    ),
                  ],
                ),
              ).intoExpanded(),
            ],
          ),
        ),
        secondaryActions: <Widget>[
          _slideAction(
            onTap: () {
              _bloc.pinConversation(
                conversationID: info.conversationID,
                isPinned: !(info.isPinned == 1),
              );
            },
            colors: [Color(0xFF87C0FF), Color(0xFF0060E7)],
            text: (info.isPinned == 1)
                ? S.of(context).cancel_top
                : S.of(context).top,
            width: 80.w,
          ),
          _slideAction(
            onTap: () {
              _bloc.deleteConversation(conversationID: info.conversationID);
            },
            colors: [Color(0xFFFFD576), Color(0xFFFFAB41)],
            text: S.of(context).delete,
            width: 80.w,
          ),
          if ((info.unreadCount ?? 0) > 0)
            _slideAction(
              onTap: () {
                if (info.isSingleChat) {
                  _bloc.markSingleMessageHasRead(userId: info.userID ?? '');
                } else if (info.isGroupChat) {
                  _bloc.markGroupMessageHasRead(groupId: info.groupID ?? '');
                }
              },
              colors: [Color(0xFFC9C9C9), Color(0xFF7A7A7A)],
              text: S.of(context).have_read,
              width: 84.w,
            ),
        ],
      );

  String _lastMsg({required ConversationInfo info}) {
    if (info.latestMsg?.contentType == MessageType.picture) {
      return '[图片]';
    } else if (info.latestMsg?.contentType == MessageType.video) {
      return '[视频]';
    } else if (info.latestMsg?.contentType == MessageType.voice) {
      return '[语音]';
    } else if (info.latestMsg?.contentType == MessageType.file) {
      return '[文件]';
    }  else if (info.latestMsg?.contentType == MessageType.location) {
      return '[位置]';
    } else if (info.latestMsg?.contentType == MessageType.merger) {
      return '[合并消息]';
    } else if (info.latestMsg?.contentType == MessageType.card) {
      return '[名片]';
    } else if (info.latestMsg?.contentType == MessageType.revoke) {
      if (info.latestMsg?.sendID == OpenIM.iMManager.uid) {
        return '[你撤回了一条消息]';
      } else {
        return '"[${info.latestMsg!.senderNickName}你撤回了一条消息]';
      }
    } else if (info.latestMsg?.contentType == MessageType.at_text) {
      String text = info.latestMsg?.content?.trim() ?? '';
      try {
        Map map = json.decode(text);
        text = map['text'];
        bool isAtSelf = map['isAtSelf'];
        if (isAtSelf == true) {
          text = '[@ you]$text';
        }
      } catch (e) {}
      return text;
    }
    /* else if (info.latestMsg?.contentType == MessageType.accept_friend) {
      try {
        Map map = json.decode(info.latestMsg?.content?.trim() ?? '');
        return map['defaultTips'];
      } catch (e) {}
      return info.latestMsg?.content?.trim() ?? '';
    }else if (info.latestMsg?.contentType == MessageType.create_group) {
      try {
        Map map = json.decode(info.latestMsg?.content?.trim() ?? '');
        return map['defaultTips'];
      } catch (e) {}
      return info.latestMsg?.content?.trim() ?? '';
    }*/
    else {
      String text = info.latestMsg?.content?.trim() ?? '';
      if (text.contains("\"defaultTips\":")) {
        try {
          Map map = json.decode(text);
          return map['defaultTips'];
        } catch (e) {}
      }
    }
    if (null != info.draftText && '' != info.draftText) {
      if (null != info.groupID &&
          info.groupID!.isNotEmpty &&
          info.draftText!.trim().isNotEmpty) {
        Map map = json.decode(info.draftText!);
        Map textMap = map['text'];
        return '[Draft]${textMap.values.first}';
      }
      return '[Draft]${info.draftText}';
    }
    return info.latestMsg?.content?.trim() ?? '';
  }

  SlideAction _slideAction({
    VoidCallback? onTap,
    required List<Color> colors,
    required String text,
    required double width,
  }) =>
      SlideAction(
        onTap: onTap,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ).intoContainer(
            // width: width,
            alignment: Alignment.center,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 12.w)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: eechartAppbar(
        context,
        right: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPop(context: context, ctrl: _popupCtrl),
            SizedBox(width: 12.w),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _bloc.conversationListCtrl.stream,
        builder: (_, AsyncSnapshot<List<ConversationInfo>> hot) =>
            ListView.builder(
                itemCount: hot.data?.length ?? 0,
                itemExtent: 73.h,
                itemBuilder: (_, index) {
                  ConversationInfo c = hot.data![index];
                  draftTextMap[c.conversationID] = c.draftText ?? '';
                  return _buildItem(info: c).intoGesture(
                    onTap: () {
                      if (null != c.groupID && c.groupID!.isNotEmpty) {
                        _bloc.updateGroupMemberInfo(groupId: c.groupID!);
                      }
                      NavigatorManager.push(
                        context,
                        ChatPage(
                          uid: c.userID,
                          gid: c.groupID,
                          title: c.showName,
                        ),
                      ).then((value) {
                        if (c.draftText != value) {
                          _bloc.setConversationDraft(
                            conversationID: c.conversationID,
                            draftText: value,
                          );
                        }
                      });
                    },
                  );
                }),
      ),
    );
  }

  final _popupCtrl = CustomPopupMenuController();
}
