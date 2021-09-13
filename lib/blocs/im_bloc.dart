import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/config.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/media_path.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:path_provider/path_provider.dart';

class IMBloc extends BlocBase
    implements
        InitSDKListener,
        ConversationListener,
        GroupListener,
        AdvancedMsgListener,
        MsgSendProgressListener,
        FriendshipListener {
  static const PLATFORM = 1;

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
      listener: this,
    );

    _listenerSet();
  }

  void _listenerSet() {
    ///
    // OpenIM.iMManager.friendshipManager
    //     .setFriendshipListener(FriendshipListenerImpl());

    ///

    ///
    OpenIM.iMManager.messageManager.addAdvancedMsgListener(this);

    ///
    OpenIM.iMManager.messageManager.setMsgSendProgressListener(this);

    ///
    OpenIM.iMManager.conversationManager.setConversationListener(this);

    // ///
    OpenIM.iMManager.friendshipManager.setFriendshipListener(this);

    ///
    OpenIM.iMManager.groupManager.setGroupListener(this);
  }

  @override
  void dispose() {
    OpenIM.iMManager.messageManager.removeAdvancedMsgListener(this);
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

  @override
  String get id => "id_${DateTime.now().microsecondsSinceEpoch}";

  @override
  void onApplicationProcessed(String groupId, GroupMembersInfo opUser,
      int agreeOrReject, String opReason) {
    postGroupApplicationEvent();
  }

  @override
  void onBlackListAdd(UserInfo u) {
    postBlackListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onBlackListDeleted(UserInfo u) {
    postBlackListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onConnectFailed(int? code, String? errorMsg) {
  }

  @override
  void onConnectSuccess() {
  }

  @override
  void onConnecting() {
  }

  @override
  void onConversationChanged(List<ConversationInfo> list) {
    postConversationListEvent();
  }

  @override
  void onFriendApplicationListAccept(UserInfo u) {
    postFriendApplicationListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onFriendApplicationListAdded(UserInfo u) {
    postFriendApplicationListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onFriendApplicationListDeleted(UserInfo u) {
    postFriendApplicationListEvent(u);
  }

  @override
  void onFriendApplicationListReject(UserInfo u) {
    postFriendApplicationListEvent(u);
  }

  @override
  void onFriendInfoChanged(UserInfo u) {
    userInfoMap[u.uid] = u;
    postFriendInfoChangedEvent(u);
    postFriendListEvent(u);
  }

  @override
  void onFriendListAdded(UserInfo u) {
    postFriendListEvent(u);
    postFriendAcceptEvent(u);
  }

  @override
  void onFriendListDeleted(UserInfo u) {
    postFriendListEvent(u);
  }

  @override
  void onGroupCreated(String groupId) {
  }

  @override
  void onGroupInfoChanged(String groupId, GroupInfo info) {
    postGroupInfoChangedEvent(info);
  }

  @override
  void onKickedOffline() {
  }

  @override
  void onMemberEnter(String groupId, List<GroupMembersInfo> list) {
    postGroupMemberChangeEvent();
    postGroupApplicationEvent();
  }

  @override
  void onMemberInvited(
      String groupId, GroupMembersInfo opUser, List<GroupMembersInfo> list) {
    postGroupMemberChangeEvent();
  }

  @override
  void onMemberKicked(
      String groupId, GroupMembersInfo opUser, List<GroupMembersInfo> list) {
    postGroupMemberChangeEvent();
  }

  @override
  void onMemberLeave(String groupId, GroupMembersInfo info) {
    postGroupMemberChangeEvent();
  }

  @override
  void onNewConversation(List<ConversationInfo> list) {
    postConversationListEvent();
  }

  @override
  void onProgress(String msgID, int progress) {
    postMessageSendProgressEvent(msgID, progress);
  }

  @override
  void onReceiveJoinApplication(
      String groupId, GroupMembersInfo info, String opReason) {
    postGroupApplicationEvent();
  }

  @override
  void onRecvC2CReadReceipt(List<HaveReadInfo> list) {
    postMessageHaveReadEvent(list);
  }

  @override
  void onRecvMessageRevoked(String msgId) {
    postRevokeMessageEvent(msgId);
  }

  @override
  void onRecvNewMessage(Message msg) {
    postMessageEvent(msg);
  }

  @override
  void onSelfInfoUpdated(UserInfo info) {
  }

  @override
  void onSyncServerFailed() {
  }

  @override
  void onSyncServerFinish() {
  }

  @override
  void onSyncServerStart() {
  }

  @override
  void onTotalUnreadMessageCountChanged(int i) {
    postUnreadMsgCountEvent(i);
  }

  @override
  void onUserSigExpired() {
  }
}
