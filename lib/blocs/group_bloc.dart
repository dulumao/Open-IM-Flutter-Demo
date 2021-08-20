import 'dart:async';
import 'dart:convert';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/models/contact_info.dart';
import 'package:eechart/widgets/loading_view.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:rxdart/rxdart.dart';

class GroupBloc extends BlocBase {
  // var uidCtrl = BehaviorSubject<String>();
  BehaviorSubject<List<GroupInfo>> searchGroupCtrl = BehaviorSubject();
  BehaviorSubject<GroupInfo> groupInfoCtrl = BehaviorSubject();
  BehaviorSubject<List<GroupMembersInfo>> groupMemberCtrl = BehaviorSubject();
  BehaviorSubject<List<GroupMembersInfo>> searchGroupMemberCtrl =
      BehaviorSubject();
  BehaviorSubject<bool> joinedGroupCheckCtrl = BehaviorSubject();
  BehaviorSubject<int> groupRoleCtrl = BehaviorSubject();
  BehaviorSubject<List<GroupApplicationInfo>> groupApplicationListCtrl =
      BehaviorSubject();

  final List<GroupMembersInfo> _groupMemberList = List.empty(growable: true);
  final String gid;

  BehaviorSubject<List<GroupInfo>> joinedGrouListCtrl = BehaviorSubject();

  // Dedup _groupInfoChangedDedup = Dedup();

  late StreamSubscription _groupInfoChangedSub;
  late StreamSubscription _groupApplicationSub;
  late StreamSubscription _groupMemberChangedSub;

  GroupBloc({required this.gid}) {
    _groupInfoChangedSub = subsStream<GroupInfoChangedEvent>((event) {
      // _groupInfoChangedDedup.run(fuc: () {
      // });
      // groupInfoCtrl.addSafely(event.gInfo);
      getGroupInfo();
    });
    _groupApplicationSub = subsStream<GroupApplicationEvent>((event) {
      getGroupApplicationList();
    });
    _groupMemberChangedSub = subsStream<GroupMemberChangeEvent>((event) {
      getGroupMembers();
    });
  }

  Future<dynamic> createGroup(List<ContactInfo> list) {
    var roles = list.map((e) => GroupMemberRole(uid: e.uid)).toList();
    return LoadingView.wrap(
      context,
      OpenIM.iMManager.groupManager.createGroup(
        groupInfo: null,
        list: roles,
      ),
    );
  }

  void getGroupInfo() {
    OpenIM.iMManager.groupManager.getGroupsInfo(
        gidList: [gid]).then((value) => groupInfoCtrl.addSafely(value[0]));
  }

  void getGroupMembers({List<GroupMembersInfo>? list}) {
    if (null != list) {
      groupMemberCtrl.addSafely(_groupMemberList
        ..clear()
        ..addAll(list));
      return;
    }
    OpenIM.iMManager.groupManager
        .getGroupMemberList(groupId: gid)
        .then((value) {
      if (null != value.data) {
        groupMemberCtrl.addSafely(_groupMemberList
          ..clear()
          ..addAll(value.data!));
      }
    });
  }

  void searchGroupMembers(String nickname) {
    searchGroupMemberCtrl.addSafely(nickname.isEmpty
        ? []
        : _groupMemberList
            .where((e) => e.nickName!.contains(nickname))
            .toList());
  }

  Future<List<GroupInviteResult>> inviteUserToGroup({
    required List<ContactInfo> list,
    String? reason,
  }) {
    List<String> uidList = list.map((e) => e.uid).toList();
    return LoadingView.wrap(
        context,
        OpenIM.iMManager.groupManager.inviteUserToGroup(
          groupId: gid,
          uidList: uidList,
          reason: reason,
        ));
  }

  Future<List<GroupInviteResult>> kickGroupMember({
    required List<GroupMembersInfo> list,
    String? reason,
  }) {
    List<String> uidList = list.map((e) => e.userId!).toList();
    return LoadingView.wrap(
        context,
        OpenIM.iMManager.groupManager.kickGroupMember(
          groupId: gid,
          uidList: uidList,
          reason: reason,
        ));
  }

  void isJoinedGroup() {
    OpenIM.iMManager.groupManager
        .isJoinedGroup(gid: gid)
        .then((value) => joinedGroupCheckCtrl.addSafely(value));
  }

  Future<dynamic> setGroupInfo({required GroupInfo gInfo}) {
    return LoadingView.wrap(
        context,
        OpenIM.iMManager.groupManager.setGroupInfo(
          groupInfo: gInfo,
        ));
  }

  void searchGroup({required String gid}) {
    print('========gid:$gid');
    OpenIM.iMManager.groupManager.getGroupsInfo(
        gidList: [gid]).then((value) => searchGroupCtrl.addSafely(value));
  }

  void joinGroup() {
    OpenIM.iMManager.groupManager
        .joinGroup(gid: gid, reason: null)
        .then((value) {
      Fluttertoast.showToast(msg: S.of(context).application_has_been_sent);
    });
  }

  Future<dynamic> transferGroupOwner({required String uid}) {
    return LoadingView.wrap(
      context,
      OpenIM.iMManager.groupManager.transferGroupOwner(gid: gid, uid: uid),
    );
  }

  void getGroupMembersRole({required String uid}) {
    OpenIM.iMManager.groupManager.getGroupMembersInfo(
      groupId: gid,
      uidList: [uid],
    ).then((list) {
      if (list.length > 0) {
        GroupMembersInfo info = list[0];
        groupRoleCtrl.addSafely(info.role ?? 0);
      }
    });
  }

  Future<dynamic> quitGroup() {
    print('gid:$gid');
    return LoadingView.wrap(
      context,
      OpenIM.iMManager.groupManager.quitGroup(gid: gid),
    );
  }

  void getGroupApplicationList() {
    OpenIM.iMManager.groupManager.getGroupApplicationList().then((value) {
      groupApplicationListCtrl.addSafely(value.user ?? []);
    });
  }

  void acceptGroupApplication({required GroupApplicationInfo info}) {
    LoadingView.wrap(
      context,
      OpenIM.iMManager.groupManager
          .acceptGroupApplication(
            info: info,
            reason: 'reason',
          )
          .then((value) => getGroupApplicationList()),
    );
  }

  void refuseGroupApplication({required GroupApplicationInfo info}) {
    LoadingView.wrap(
      context,
      OpenIM.iMManager.groupManager
          .refuseGroupApplication(
            info: info,
            reason: 'reason',
          )
          .then((value) => getGroupApplicationList()),
    );
  }

  void getJoinedGroupList() {
    LoadingView.wrap(
      context,
      OpenIM.iMManager.groupManager
          .getJoinedGroupList()
          .then((value) => joinedGrouListCtrl.addSafely(value)),
    );
  }

  @override
  void dispose() {
    searchGroupCtrl.close();
    groupMemberCtrl.close();
    groupInfoCtrl.close();
    joinedGroupCheckCtrl.close();
    searchGroupMemberCtrl.close();
    groupRoleCtrl.close();
    groupApplicationListCtrl.close();
    joinedGrouListCtrl.close();
    _groupInfoChangedSub.cancel();
    _groupApplicationSub.cancel();
    _groupMemberChangedSub.cancel();
  }
}
