import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/config.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/media_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:path_provider/path_provider.dart';

class IMBloc extends BlocBase {
  static const PLATFORM = 1;
  late AdvancedMsgListenerImpl msgListenerImpl;

  IMBloc() {
    init();
  }

  void init() async {
    imCachePath = (await getApplicationDocumentsDirectory()).path;
    OpenIM.iMManager.initSDK(
      platform: PLATFORM,
      ipApi: Config.IP_API,
      ipWs: Config.IP_WS,
      dbPath: "$imCachePath/",
      listener: InitSDKListenerImpl(),
    );

    _listenerSet();
  }

  void _listenerSet() {
    ///
    // OpenIM.iMManager.friendshipManager
    //     .setFriendshipListener(FriendshipListenerImpl());

    ///
    msgListenerImpl = AdvancedMsgListenerImpl(
      onNewMessage: (s) {
        postMessageEvent(s);
      },
      onMessageRevoked: (s) {
        postRevokeMessageEvent(s);
      },
      onMessageHaveRead: (s) {
        postMessageHaveReadEvent(s);
      },
    );

    ///
    OpenIM.iMManager.messageManager.addAdvancedMsgListener(msgListenerImpl);

    ///
    OpenIM.iMManager.messageManager
        .setMsgSendProgressListener(MsgSendProgressListenerImpl());

    ///
    OpenIM.iMManager.conversationManager
        .setConversationListener(ConversationListenerImpl());

    // ///
    OpenIM.iMManager.friendshipManager
        .setFriendshipListener(FriendshipListenerImpl());

    ///
    OpenIM.iMManager.groupManager.setGroupListener(GroupListenerImpl());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    OpenIM.iMManager.messageManager
        .removeAdvancedMsgListener(msgListenerImpl);
  }

  /*void reLogin() async {
    String account = SpUtil.getString("account");
    if (account.isNotEmpty) {
      var imToken = SpUtil.getObj(
        account,
        (v) => OpenImToken.fromJson(v.cast()),
      );
      String uid = imToken?.uid ?? '';
      String token = imToken?.token ?? '';
      if (uid.isNotEmpty && token.isNotEmpty) {
        await OpenIM.iMManager.logout();
        // _listenerSet();
        OpenIM.iMManager.login(uid: uid, token: token);
      }
    }
  }*/

  forceReConn() {
    OpenIM.iMManager.forceReConn();
  }
}

class InitSDKListenerImpl implements InitSDKListener {
  @override
  void onConnectFailed(int? int, String? errorMsg) {
    // TODO: implement onConnectFailed
    print('=======flutter============>onConnectFailed');
  }

  @override
  void onConnectSuccess() {
    // TODO: implement onConnectSuccess
    print('=======flutter============>onConnectSuccess');
  }

  @override
  void onConnecting() {
    // TODO: implement onConnecting
    print('=======flutter============>onConnecting');
  }

  @override
  void onKickedOffline() {
    // TODO: implement onKickedOffline
    print('=======flutter============>onKickedOffline');
  }

  @override
  void onSelfInfoUpdated(UserInfo info) {
    // TODO: implement onSelfInfoUpdated
    print('=======flutter============>onSelfInfoUpdated');
  }

  @override
  void onUserSigExpired() {
    // TODO: implement onUserSigExpired
    print('=======flutter============>onUserSigExpired');
  }
}

class FriendshipListenerImpl implements FriendshipListener {
  @override
  void onBlackListAdd(u) {
    // TODO: implement onBlackListAdd
    print('=======flutter onBlackListAdd============>$u');
    postBlackListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onBlackListDeleted(u) {
    // TODO: implement onBlackListDeleted
    print('=======flutter onBlackListDeleted============>$u');
    postBlackListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onFriendApplicationListAccept(u) {
    // TODO: implement onFriendApplicationListAccept
    print('=======flutter onFriendApplicationListAccept============>$u');
    postFriendApplicationListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onFriendApplicationListAdded(u) {
    // TODO: implement onFriendApplicationListAdded
    print('=======flutter onFriendApplicationListAdded============>$u');
    postFriendApplicationListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onFriendApplicationListDeleted(u) {
    // TODO: implement onFriendApplicationListDeleted
    print('=======flutter onFriendApplicationListDeleted============>$u');
    postFriendApplicationListEvent(u);
    // postFriendListEvent(u);
  }

  @override
  void onFriendApplicationListReject(u) {
    // TODO: implement onFriendApplicationListReject
    print('=======flutter onFriendApplicationListReject============>$u');
    postFriendApplicationListEvent(u);
  }

  @override
  void onFriendInfoChanged(u) {
    // TODO: implement onFriendInfoChanged
    print('=======flutter onFriendInfoChanged============>$u');
    userInfoMap[u.uid] = u;
    postFriendInfoChangedEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onFriendListAdded(u) {
    // TODO: implement onFriendListAdded
    print('=======flutter onFriendListAdded============>$u');
    postFriendListEvent(u);
    postFriendAcceptEvent(u);
  }

  @override
  void onFriendListDeleted(u) {
    // TODO: implement onFriendListDeleted
    print('=======flutter onFriendListDeleted============>$u');
    postFriendListEvent(u);
  }
}

class AdvancedMsgListenerImpl extends AdvancedMsgListener {
/*  final String _id;*/
  final ValueChanged<Message>? onNewMessage;
  final ValueChanged<String>? onMessageRevoked;
  final ValueChanged<List<HaveReadInfo>>? onMessageHaveRead;

  AdvancedMsgListenerImpl(/*  this._id, */ {
    this.onNewMessage,
    this.onMessageRevoked,
    this.onMessageHaveRead,
  }) /*: super(id: _id)*/;

/*  @override
  // TODO: implement id
  String get id => _id;*/

  @override
  void onRecvNewMessage(Message msg) {
    // TODO: implement onRecvNewMessage
    print('=======flutter onRecvNewMessage============>');
    if (null != onNewMessage) onNewMessage!(msg);
  }

  @override
  void onRecvMessageRevoked(String msgId) {
    // TODO: implement onRecvMessageRevoked
    print('=======flutter onRecvMessageRevoked============>');
    if (null != onMessageRevoked) onMessageRevoked!(msgId);
  }

  @override
  void onRecvC2CReadReceipt(List<HaveReadInfo> list) {
    if (null != onMessageHaveRead) onMessageHaveRead!(list);
  }
}

class MsgSendProgressListenerImpl implements MsgSendProgressListener {
  @override
  void onProgress(String msgID, int progress) {
    print('=======flutter onProgress============>$msgID');
    postMessageSendProgressEvent(msgID, progress);
  }
}

class ConversationListenerImpl implements ConversationListener {
  @override
  void onConversationChanged(List<ConversationInfo> list) {
    // TODO: implement onConversationChanged
    postConversationListEvent();
  }

  @override
  void onNewConversation(List<ConversationInfo> list) {
    // TODO: implement onNewConversation
    postConversationListEvent();
  }

  @override
  void onSyncServerFailed() {
    // TODO: implement onSyncServerFailed
  }

  @override
  void onSyncServerFinish() {
    // TODO: implement onSyncServerFinish
  }

  @override
  void onSyncServerStart() {
    // TODO: implement onSyncServerStart
  }

  @override
  void onTotalUnreadMessageCountChanged(int i) {
    // TODO: implement onTotalUnreadMessageCountChanged
    postUnreadMsgCountEvent(i);
  }
}

class GroupListenerImpl implements GroupListener {
  @override
  void onApplicationProcessed(String groupId, GroupMembersInfo opUser,
      int agreeOrReject, String opReason) {
    // TODO: implement onApplicationProcessed
    postGroupApplicationEvent();
  }

  @override
  void onGroupCreated(String groupId) {
    // TODO: implement onGroupCreated
  }

  @override
  void onGroupInfoChanged(String groupId, GroupInfo info) {
    // TODO: implement onGroupInfoChanged
    postGroupInfoChangedEvent(info);
  }

  @override
  void onMemberEnter(String groupId, List<GroupMembersInfo> list) {
    // TODO: implement onMemberEnter
    postGroupMemberChangeEvent();
    postGroupApplicationEvent();
  }

  @override
  void onMemberInvited(
      String groupId, GroupMembersInfo opUser, List<GroupMembersInfo> list) {
    // TODO: implement onMemberInvited
    postGroupMemberChangeEvent();
  }

  @override
  void onMemberKicked(
      String groupId, GroupMembersInfo opUser, List<GroupMembersInfo> list) {
    // TODO: implement onMemberKicked
    postGroupMemberChangeEvent();
  }

  @override
  void onMemberLeave(String groupId, GroupMembersInfo info) {
    // TODO: implement onMemberLeave
    postGroupMemberChangeEvent();
  }

  @override
  void onReceiveJoinApplication(
      String groupId, GroupMembersInfo info, String opReason) {
    // TODO: implement onReceiveJoinApplication
    postGroupApplicationEvent();
  }
}
