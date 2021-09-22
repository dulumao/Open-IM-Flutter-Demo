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
  void applicationProcessed(String groupId, GroupMembersInfo opUser,
      int agreeOrReject, String opReason) {
    postGroupApplicationEvent();
  }

  @override
  void blackListAdd(UserInfo u) {
    postBlackListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void blackListDeleted(UserInfo u) {
    postBlackListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void connectFailed(int? code, String? errorMsg) {
  }

  @override
  void connectSuccess() {
  }

  @override
  void connecting() {
  }

  @override
  void conversationChanged(List<ConversationInfo> list) {
    postConversationListEvent();
  }

  @override
  void friendApplicationListAccept(UserInfo u) {
    postFriendApplicationListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void friendApplicationListAdded(UserInfo u) {
    postFriendApplicationListEvent(u);
    postFriendListEvent(u);
  }

  @override
  void friendApplicationListDeleted(UserInfo u) {
    postFriendApplicationListEvent(u);
  }

  @override
  void friendApplicationListReject(UserInfo u) {
    postFriendApplicationListEvent(u);
  }

  @override
  void friendInfoChanged(UserInfo u) {
    userInfoMap[u.uid] = u;
    postFriendInfoChangedEvent(u);
    postFriendListEvent(u);
  }

  @override
  void friendListAdded(UserInfo u) {
    postFriendListEvent(u);
    postFriendAcceptEvent(u);
  }

  @override
  void friendListDeleted(UserInfo u) {
    postFriendListEvent(u);
  }

  @override
  void groupCreated(String groupId) {
  }

  @override
  void groupInfoChanged(String groupId, GroupInfo info) {
    postGroupInfoChangedEvent(info);
  }

  @override
  void kickedOffline() {
  }

  @override
  void memberEnter(String groupId, List<GroupMembersInfo> list) {
    postGroupMemberChangeEvent();
    postGroupApplicationEvent();
  }

  @override
  void memberInvited(
      String groupId, GroupMembersInfo opUser, List<GroupMembersInfo> list) {
    postGroupMemberChangeEvent();
  }

  @override
  void memberKicked(
      String groupId, GroupMembersInfo opUser, List<GroupMembersInfo> list) {
    postGroupMemberChangeEvent();
  }

  @override
  void memberLeave(String groupId, GroupMembersInfo info) {
    postGroupMemberChangeEvent();
  }

  @override
  void newConversation(List<ConversationInfo> list) {
    postConversationListEvent();
  }

  @override
  void progress(String msgID, int progress) {
    postMessageSendProgressEvent(msgID, progress);
  }

  @override
  void receiveJoinApplication(
      String groupId, GroupMembersInfo info, String opReason) {
    postGroupApplicationEvent();
  }

  @override
  void recvC2CReadReceipt(List<HaveReadInfo> list) {
    postMessageHaveReadEvent(list);
  }

  @override
  void recvMessageRevoked(String msgId) {
    postRevokeMessageEvent(msgId);
  }

  @override
  void recvNewMessage(Message msg) {
    postMessageEvent(msg);
  }

  @override
  void selfInfoUpdated(UserInfo info) {
  }

  @override
  void syncServerFailed() {
  }

  @override
  void syncServerFinish() {
  }

  @override
  void syncServerStart() {
  }

  @override
  void totalUnreadMessageCountChanged(int i) {
    postUnreadMsgCountEvent(i);
  }

  @override
  void userSigExpired() {
  }
}
