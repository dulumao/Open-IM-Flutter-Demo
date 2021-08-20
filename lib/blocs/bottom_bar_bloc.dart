import 'dart:async';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:rxdart/rxdart.dart';

class BottomBarBloc extends BlocBase {
  BehaviorSubject<int> friendApplicationCountCtrl = new BehaviorSubject();
  BehaviorSubject<int> unreadMsgCountCtrl = new BehaviorSubject();
  BehaviorSubject<int> groupApplicationNumCtrl = BehaviorSubject();

  @override
  void dispose() {
    friendApplicationCountCtrl.close();
    unreadMsgCountCtrl.close();
    groupApplicationNumCtrl.close();
    _friendApplicationCount.cancel();
    _unreadMsgCount.cancel();
    _groupApplicationCount.cancel();
  }

  BottomBarBloc() {
    _friendApplicationCount = subsStream<FriendApplicationCountEvent>((event) {
      friendApplicationCountCtrl.addSafely(event.count);
    });

    _unreadMsgCount = subsStream<UnreadMsgCountEvent>((event) {
      unreadMsgCountCtrl.addSafely(event.count);
    });

    _groupApplicationCount = subsStream<GroupApplicationCountEvent>((event) {
      groupApplicationNumCtrl.addSafely(event.count);
    });
  }

  late StreamSubscription _friendApplicationCount;
  late StreamSubscription _unreadMsgCount;
  late StreamSubscription _groupApplicationCount;
}
