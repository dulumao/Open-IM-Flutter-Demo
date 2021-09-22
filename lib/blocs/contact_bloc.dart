import 'dart:async';

import 'package:azlistview/azlistview.dart';
import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/models/contact_info.dart';
import 'package:eechart/utils/dedup_util.dart';
import 'package:eechart/widgets/loading_view.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:rxdart/rxdart.dart';

List<ContactInfo> topList = List.empty(growable: true);
List<ContactInfo> contactList = List.empty(growable: true);

class ContactBloc extends BlocBase {
  BehaviorSubject<List<ContactInfo>> contactListCtrl = BehaviorSubject();

  BehaviorSubject<String> uidCtrl = BehaviorSubject();

  BehaviorSubject<List<UserInfo>> friendApplicationListCtrl = BehaviorSubject();
  BehaviorSubject<List<UserInfo>> searchUserListCtrl = BehaviorSubject();
  BehaviorSubject<UserInfo> checkFriendCtrl = BehaviorSubject();
  BehaviorSubject<int> friendApplicationNumCtrl = BehaviorSubject();
  BehaviorSubject<int> groupApplicationNumCtrl = BehaviorSubject();
  TextEditingController remarkEditCtrl = TextEditingController();

  BehaviorSubject<List<UserInfo>> blackListCtrl = BehaviorSubject();

  List<UserInfo> _blackList = List.empty(growable: true);

  void getContactList() async {
    /* IsolateHandler.spawn(handleContactList, {
      "topList": topList.map((e) => e.toJson()).toList(),
    }, onData: (result) {
      contactList =
          (result as List).map((e) => ContactInfo.fromJson(e)).toList();
      contactListCtrl.addSafely(contactList);
    });*/

    OpenIM.iMManager.friendshipManager.getFriendList().then((value) {
      var list = value.map((e) {
        userInfoMap[e.uid] = e;
        return ContactInfo.fromUserInfo(e);
      }).toList();
      list.retainWhere((u) => u.isInBlackList == 0);
      for (int i = 0, length = list.length; i < length; i++) {
        String pinyin = PinyinHelper.getPinyinE(list[i].nickname);
        String tag = pinyin.substring(0, 1).toUpperCase();
        list[i].namePinyin = pinyin;
        if (RegExp("[A-Z]").hasMatch(tag)) {
          list[i].tagIndex = tag;
        } else {
          list[i].tagIndex = "#";
        }
      }
      // A-Z sort.
      SuspensionUtil.sortListBySuspensionTag(list);
      // show sus tag.
      SuspensionUtil.setShowSuspensionStatus(list);
      // add topList.
      list.insertAll(0, topList);

      contactListCtrl.addSafely(contactList = list);
    });
  }

  void getUid() {
    OpenIM.iMManager.getLoginUid().then((value) {
      uidCtrl.addSafely(value ?? '--');
    });
  }

  void getFriendApplicationList() {
    OpenIM.iMManager.friendshipManager
        .getFriendApplicationList()
        .then((list) => friendApplicationListCtrl.addSafely(list))
        .then((list) => _culNuHandleNum(list));
  }

  void _culNuHandleNum(List<UserInfo> list) {
    int i = 0;
    for (UserInfo info in list) {
      if (info.flag == 0) i++;
    }
    friendApplicationNumCtrl.addSafely(i);
    postFriendApplicationCountEvent(i);
  }

  void getUsersInfo(String uid) {
    if (uid.isEmpty) return;
    //ac6b0878cba4000a798f99eb7f5c12f0
    OpenIM.iMManager
        .getUsersInfo([uid]).then((list) => searchUserListCtrl.addSafely(list));
  }

  void checkFriend(String uid) {
    if (uid.isEmpty) return;
    OpenIM.iMManager.friendshipManager.checkFriend([uid]).then((value) {
      checkFriendCtrl.addSafely(value[0]);
    });
  }

  void addFriend({required String uid, required String reason}) {
    LoadingView.show(context);
    OpenIM.iMManager.friendshipManager
        .addFriend(uid: uid, reason: reason)
        .then((value) => LoadingView.dismiss())
        .then((value) => Fluttertoast.showToast(
            msg: S.of(context).application_has_been_sent));
  }

  Future<dynamic> deleteFromFriendList({required String uid}) {
    return OpenIM.iMManager.friendshipManager.deleteFromFriendList(uid: uid);
  }

  void initNickname(String? uname) {
    remarkEditCtrl.text = uname ?? '';
  }

  Future<dynamic> setFriendInfo({required String uid}) {
    if (remarkEditCtrl.text.isEmpty) return Future.error('text is empty');
    return OpenIM.iMManager.friendshipManager
        .setFriendInfo(uid: uid, comment: remarkEditCtrl.text)
        .then((value) => postFriendNicknameChanged(uid, remarkEditCtrl.text));
  }

  Future<dynamic> addToBlackList({required String uid}) {
    return OpenIM.iMManager.friendshipManager.addToBlackList(uid: uid);
  }

  void getBlackList() {
    OpenIM.iMManager.friendshipManager
        .getBlackList()
        .then((value) => blackListCtrl.addSafely(_blackList
          ..clear()
          ..addAll(value)));
  }

  Future<dynamic> deleteFromBlackList({required UserInfo info}) {
    return OpenIM.iMManager.friendshipManager
        .deleteFromBlackList(uid: info.uid);
    // .then((value) => blackListCtrl.addSafely(_blackList..remove(info)));
  }

  Future<dynamic> acceptFriendApplication(
      {required BuildContext context, required String uid}) {
    return LoadingView.wrap(
      context,
      OpenIM.iMManager.friendshipManager.acceptFriendApplication(uid: uid),
    );
  }

  Future<dynamic> refuseFriendApplication(
      {required BuildContext context, required String uid}) {
    return LoadingView.wrap(
      context,
      OpenIM.iMManager.friendshipManager.refuseFriendApplication(uid: uid),
    );
  }

  void searchContacts() {}

  void getGroupApplicationList() {
    OpenIM.iMManager.groupManager.getGroupApplicationList().then((value) {
      groupApplicationNumCtrl.addSafely(value.count ?? 0);
      postGroupApplicationCountEvent(value.count ?? 0);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    contactListCtrl.close();
    uidCtrl.close();
    friendApplicationListCtrl.close();
    searchUserListCtrl.close();
    checkFriendCtrl.close();
    blackListCtrl.close();
    friendApplicationNumCtrl.close();
    groupApplicationNumCtrl.close();
    remarkEditCtrl.dispose();
    _friendInfoChangedSubs.cancel();
    _blackListSubs.cancel();
    _friendApplicationList.cancel();
    _friendListSubs.cancel();
    _friendAcceptSubs.cancel();
    _groupApplicationSub.cancel();
  }

  ContactBloc() {
    _friendInfoChangedSubs = subsStream<FriendInfoChangedEvent>((event) {
      // getContactList();
    });
    _blackListSubs = subsStream<BlackListEvent>((event) {
      _blackListDedup.run(fuc: () {
        getBlackList();
      });
    });
    _friendApplicationList = subsStream<FriendApplicationListEvent>((event) {
      _friendApplicationListDedup.run(fuc: () {
        getFriendApplicationList();
      });
    });
    _friendListSubs = subsStream<FriendListEvent>((event) {
      _friendListDedup.run(fuc: () {
        getContactList();
      });
    });

    _friendAcceptSubs = subsStream<FriendAcceptEvent>((event) {
      _friendAcceptDedup.run(fuc: () {
        checkFriend((event.u as UserInfo).uid);
      });
    });

    _groupApplicationSub = subsStream<GroupApplicationEvent>((event) {
      getGroupApplicationList();
    });
  }

  Dedup _blackListDedup = Dedup();
  Dedup _friendApplicationListDedup = Dedup();
  Dedup _friendListDedup = Dedup();
  Dedup _friendAcceptDedup = Dedup();

  late StreamSubscription _friendInfoChangedSubs;
  late StreamSubscription _blackListSubs;
  late StreamSubscription _friendApplicationList;
  late StreamSubscription _friendListSubs;
  late StreamSubscription _friendAcceptSubs;
  late StreamSubscription _groupApplicationSub;
}
