import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/config.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/media_path.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:path_provider/path_provider.dart';

class IMBloc extends BlocBase {
  static const PLATFORM = 1;

  IMBloc() {
    init();
  }

  void init() async {
    imCachePath = (await getApplicationDocumentsDirectory()).path;
    OpenIM.iMManager
      ..initSDK(
        platform: PLATFORM,
        ipApi: Config.IP_API,
        ipWs: Config.IP_WS,
        dbPath: "$imCachePath/",
        listener: OnInitSDKListener(
          onConnectFailed: (code, msg) {},
          onConnecting: () {},
          onConnectSuccess: () {},
          onKickedOffline: () {},
          onSelfInfoUpdated: (info) {},
          onUserSigExpired: () {},
        ),
      )
      ..messageManager.addAdvancedMsgListener(OnAdvancedMsgListener(
        onRecvC2CReadReceipt: (list) {
          postMessageHaveReadEvent(list);
        },
        onRecvMessageRevoked: (id) {
          postRevokeMessageEvent(id);
        },
        onRecvNewMessage: (msg) {
          postMessageEvent(msg);
        },
      ))
      ..messageManager.setMsgSendProgressListener(OnMsgSendProgressListener(
        onProgress: (msgID, progress) {
          postMessageSendProgressEvent(msgID, progress);
        },
      ))
      ..conversationManager.setConversationListener(OnConversationListener(
        onConversationChanged: (list) {
          postConversationListEvent();
        },
        onNewConversation: (list) {
          postConversationListEvent();
        },
        onTotalUnreadMessageCountChanged: (i) {
          postUnreadMsgCountEvent(i);
        },
      ))
      ..friendshipManager.setFriendshipListener(OnFriendshipListener(
        onBlackListAdd: (u) {
          postBlackListEvent(u);
          postFriendListEvent(u);
        },
        onBlackListDeleted: (u) {
          postBlackListEvent(u);
          postFriendListEvent(u);
        },
        onFriendListAdded: (u) {
          postFriendListEvent(u);
          postFriendAcceptEvent(u);
        },
        onFriendListDeleted: (u) {
          postFriendListEvent(u);
        },
        onFriendInfoChanged: (u) {
          userInfoMap[u.uid] = u;
          postFriendInfoChangedEvent(u);
          postFriendListEvent(u);
        },
        onFriendApplicationListAccept: (u) {
          postFriendApplicationListEvent(u);
          postFriendListEvent(u);
        },
        onFriendApplicationListAdded: (u) {
          postFriendApplicationListEvent(u);
          postFriendListEvent(u);
        },
        onFriendApplicationListDeleted: (u) {
          postFriendApplicationListEvent(u);
        },
        onFriendApplicationListReject: (u) {
          postFriendApplicationListEvent(u);
        },
      ))
      ..groupManager.setGroupListener(
        OnGroupListener(
          onGroupCreated: (gid) {},
          onGroupInfoChanged: (gid, info) {
            postGroupInfoChangedEvent(info);
          },
          onMemberEnter: (gid, list) {
            postGroupMemberChangeEvent();
            postGroupApplicationEvent();
          },
          onMemberLeave: (gid, info) {
            postGroupMemberChangeEvent();
          },
          onMemberInvited: (gid, info, list) {
            postGroupMemberChangeEvent();
          },
          onMemberKicked: (gid, info, list) {
            postGroupMemberChangeEvent();
          },
          onApplicationProcessed: (groupId, opUser, agreeOrReject, opReason) {
            postGroupApplicationEvent();
          },
          onReceiveJoinApplication: (groupId, info, opReason) {
            postGroupApplicationEvent();
          },
        ),
      );
  }

  forceReConn() {
    OpenIM.iMManager.forceReConn();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
