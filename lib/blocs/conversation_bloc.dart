import 'dart:async';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/dedup_util.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:rxdart/rxdart.dart';

class ConversationBloc extends BlocBase {
  BehaviorSubject<List<ConversationInfo>> conversationListCtrl =
      BehaviorSubject();
  late StreamSubscription _conversationListSubs;
  final Dedup _dedup = Dedup();

  ConversationBloc() {
    _conversationListSubs = subsStream<ConversationListEvent>((event) {
      _dedup.run(fuc: () {
        getAllConversationList();
      });
    });
  }

  void getAllConversationList() {
    /*IsolateHandler.spawn(getConversationList, 'getConversationList', {},
        onData: (data) {
      List l = json.decode(data);
      var list = l.map((e) => ConversationInfo.fromJson(e)).toList();
      conversationListCtrl.addSafely(list);
    });*/
    OpenIM.iMManager.conversationManager
        .getAllConversationList()
        .then((list) => conversationListCtrl.addSafely(list));
  }

  Future<dynamic> markSingleMessageHasRead({required String userId}) {
    return OpenIM.iMManager.conversationManager
        .markSingleMessageHasRead(userID: userId);
  }

  Future<dynamic> markGroupMessageHasRead({required String groupId}) {
    return OpenIM.iMManager.conversationManager
        .markGroupMessageHasRead(groupID: groupId);
  }

  void pinConversation(
      {required String conversationID, required bool isPinned}) {
    OpenIM.iMManager.conversationManager
        .pinConversation(conversationID: conversationID, isPinned: isPinned);
  }

  void deleteConversation({required String conversationID}) {
    OpenIM.iMManager.conversationManager
        .deleteConversation(conversationID: conversationID);
  }

  void setConversationDraft({
    required String conversationID,
    required String draftText,
  }) {
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: conversationID,
      draftText: draftText,
    );
  }

  void updateGroupMemberInfo({required String groupId}) {
    OpenIM.iMManager.groupManager
        .getGroupMemberList(groupId: groupId)
        .then((value) {
      (value.data ?? []).forEach((member) {
        groupMemberInfoMap[member.userId!] = member;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    conversationListCtrl.close();
    _conversationListSubs.cancel();
  }
}

