import 'dart:async';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/chat_bloc.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/chat/chat_view.dart';
import 'package:eechart/pages/contacts/friend_set.dart';
import 'package:eechart/pages/group/group_setting.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:keyboard_utils/keyboard_listener.dart' as ku;
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatPage extends StatefulWidget {
  final String? uid;
  final String? gid;
  final String? title; //show name
  final bool exitGroupBackMainPage;

  // final String? avatarUrl;

  const ChatPage({
    Key? key,
    this.uid,
    this.gid,
    this.title,
    this.exitGroupBackMainPage = true,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends BaseState<ChatPage> {
  late ChatBloc _bloc;
  final _refreshController = RefreshController();

  final _autoScrollController = AutoScrollController();

  // final ItemScrollController itemScrollController = ItemScrollController();
  // final ItemPositionsListener itemPositionsListener =
  //     ItemPositionsListener.create();

  String? _uid;
  String? _gid;
  String? _title;

  KeyboardUtils _keyboardUtils = KeyboardUtils();
  late int _idKeyboardListener;

  late StreamSubscription _friendInfoChangedSubs;

  int _index = 0;

  bool get _isSingleChat => null != _uid && _uid!.trim().isNotEmpty;

  bool get _isGroupChat => null != _gid && _gid!.trim().isNotEmpty;

  @override
  void initState() {
    _uid = widget.uid;
    _gid = widget.gid;
    _title = widget.title;
    if (_uid != null && _uid!.isNotEmpty) {
      var name = userInfoMap[_uid]?.getShowName();
      if (null != name && name.isNotEmpty) {
        _title = name;
      }
    }
    _friendInfoChangedSubs =
        eventBus.on<FriendNicknameChangedEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _title = event.nickname;
        });
      }
    });

    super.initState();
  }

  @override
  void initData() {
    _bloc = ChatBloc(uid: _uid, gid: _gid)
      // ..markSingleMessageHasRead()
      ..initMsgList()
      ..scrollListCtrl.listen((index) => _scrollMsgBottom(index: index))
      ..loadHistoryMsgFinishedCtrl.listen((value) {
        _refreshController.refreshCompleted();
      });
    _idKeyboardListener = _keyboardUtils.add(
      listener: ku.KeyboardListener(
        willHideKeyboard: () {},
        willShowKeyboard: (double keyboardHeight) {
          _autoScrollController.jumpTo(_autoScrollController.position.maxScrollExtent);
        },
      ),
    );
    // itemPositionsListener.itemPositions.addListener(() {
    //   try {
    //     ItemPosition item = itemPositionsListener.itemPositions.value.first;
    //     print('===============$item');
    //   } catch (e) {}
    // });
    super.initData();
  }

  @override
  void dispose() {
    _friendInfoChangedSubs.cancel();
    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: ChatView(
        refreshController: _refreshController,
        autoScrollController: _autoScrollController,
        // itemScrollController: itemScrollController,
        // itemPositionsListener: itemPositionsListener,
        title: _title,
        onClickMoreBtn: () {
          if (_isSingleChat) {
            NavigatorManager.push(context, FriendSetPage(uid: _uid!));
          } else if (_isGroupChat) {
            NavigatorManager.push(
              context,
              GroupSettingPage(
                gid: _gid!,
                exitGroupBackMainPage: widget.exitGroupBackMainPage,
              ),
            ).then((close) {
              if (close == true) {
                Navigator.pop(context);
              }
            });
          }
        },
      ),
    );
  }

  void _scrollMsgBottom({int index = 0}) {
    _index = index;
    print('============_scrollMsgBottom=====index:$_index');
    // _autoScrollController.jumpTo(_autoScrollController.position.maxScrollExtent);
    // Timer(Duration(milliseconds: 100), () {
    // double initPos = _autoScrollController.position.maxScrollExtent + 25.0;


    // _autoScrollController.animateTo(
    //   initPos,
    //   duration: const Duration(milliseconds: 50),
    //   curve: Curves.fastOutSlowIn,
    // );
    // });

    _autoScrollController.scrollToIndex(
      index,
      duration: Duration(milliseconds: 10),
    );

    // itemScrollController.scrollTo(
    //     index: index,
    //     duration: Duration(seconds: 1),
    //     curve: Curves.easeInOutCubic);
    // itemScrollController.jumpTo(index: index);
    // if(index > 1)
    // itemScrollController.jumpTo(index: index-1);
  }
}
