import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

EventBus eventBus = EventBus();

StreamSubscription subsStream<T>(void onData(T event)?) {
  return eventBus.on<T>().listen(onData);
}

////////////////////
class FriendNicknameChangedEvent {
  final String nickname;
  final String uid;

  FriendNicknameChangedEvent(this.nickname, this.uid);
}

void postFriendNicknameChanged(String uid, String nickname) {
  eventBus.fire(FriendNicknameChangedEvent(nickname, uid));
}

////////////////////////////////////////
//////////// FriendshipListener///////////
////////////////////////////////////////
class FriendInfoChangedEvent {
  UserInfo u;

  FriendInfoChangedEvent(this.u);
}

void postFriendInfoChangedEvent(UserInfo u) {
  eventBus.fire(FriendInfoChangedEvent(u));
}

////////////////////////////////////
class BlackListEvent {
  UserInfo u;

  BlackListEvent(this.u);
}

void postBlackListEvent(UserInfo u) {
  eventBus.fire(BlackListEvent(u));
}

////////////////////////////////////
class FriendApplicationListEvent {
  UserInfo u;

  FriendApplicationListEvent(this.u);
}

void postFriendApplicationListEvent(UserInfo u) {
  eventBus.fire(FriendApplicationListEvent(u));
}

////////////////////////////////////
class FriendListEvent {
  UserInfo u;

  FriendListEvent(this.u);
}

void postFriendListEvent(UserInfo u) {
  eventBus.fire(FriendListEvent(u));
}

////////////////////////////////////
class FriendAcceptEvent {
  UserInfo u;

  FriendAcceptEvent(this.u);
}

void postFriendAcceptEvent(UserInfo u) {
  eventBus.fire(FriendAcceptEvent(u));
}

////////
class ConversationListEvent {}

void postConversationListEvent(/*List<Conversation> list*/) {
  eventBus.fire(ConversationListEvent());
}

///
class MessageEvent {
  final Message message;

  MessageEvent(this.message);
}

void postMessageEvent(Message msg) {
  eventBus.fire(MessageEvent(msg));
}

class RevokeMessageEvent {
  final String msgId;

  RevokeMessageEvent(this.msgId);
}

void postRevokeMessageEvent(String msgId) {
  eventBus.fire(RevokeMessageEvent(msgId));
}

class MessageHaveReadEvent {
  final List<HaveReadInfo> list;

  MessageHaveReadEvent(this.list);
}

void postMessageHaveReadEvent(List<HaveReadInfo> list) {
  eventBus.fire(MessageHaveReadEvent(list));
}

class ProgressEvent {
  final String id;
  final int progress;

  ProgressEvent(this.id, this.progress);
}

void postMessageSendProgressEvent(String id, int progress) {
  eventBus.fire(ProgressEvent(id, progress));
}

////
class MsgSendResultEvent {
  final String id;
  final bool success;

  MsgSendResultEvent(this.id, this.success);
}

void postMsgSendResultEvent(String id, bool success) {
  eventBus.fire(MsgSendResultEvent(id, success));
}

/////
class UnreadMsgCountEvent {
  final int count;

  UnreadMsgCountEvent(this.count);
}

void postUnreadMsgCountEvent(int count) {
  eventBus.fire(UnreadMsgCountEvent(count));
}

/////
class FriendApplicationCountEvent {
  final int count;

  FriendApplicationCountEvent(this.count);
}

void postFriendApplicationCountEvent(int count) {
  eventBus.fire(FriendApplicationCountEvent(count));
}

///
class GroupInfoChangedEvent {
  final GroupInfo gInfo;

  GroupInfoChangedEvent(this.gInfo);
}

void postGroupInfoChangedEvent(GroupInfo gInfo) {
  eventBus.fire(GroupInfoChangedEvent(gInfo));
}

///
class GroupApplicationEvent {
  GroupApplicationEvent();
}

void postGroupApplicationEvent() {
  eventBus.fire(GroupApplicationEvent());
}

////
class GroupApplicationCountEvent {
  final int count;

  GroupApplicationCountEvent(this.count);
}

void postGroupApplicationCountEvent(int count) {
  eventBus.fire(GroupApplicationCountEvent(count));
}

////
class GroupMemberChangeEvent {
  GroupMemberChangeEvent();
}

void postGroupMemberChangeEvent() {
  eventBus.fire(GroupMemberChangeEvent());
}