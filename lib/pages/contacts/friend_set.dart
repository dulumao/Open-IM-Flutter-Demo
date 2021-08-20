import 'dart:async';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/pages/contacts/set_remark.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/dialog_view.dart';
import 'package:eechart/widgets/switcher_button.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:sprintf/sprintf.dart';

class FriendSetPage extends StatefulWidget {
  const FriendSetPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _FriendSetPageState createState() => _FriendSetPageState();
}

class _FriendSetPageState extends State<FriendSetPage> {
  late StreamSubscription _friendInfoChangedSubs;
  late ContactBloc _bloc;
  late String _uid;

  int? _isBlackList;
  String? _nickname;

  @override
  void initState() {
    _uid = widget.uid;
    _bloc = ContactBloc()..getUsersInfo(_uid);
    _friendInfoChangedSubs =
        eventBus.on<FriendNicknameChangedEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _nickname = event.nickname;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _friendInfoChangedSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.searchUserListCtrl.stream,
      builder: (_, AsyncSnapshot<List<UserInfo>> hot) {
        UserInfo? _u;
        if (null != hot.data && (hot.data?.length ?? 0) > 0) {
          _u = hot.data![0];
        }
        return Scaffold(
          appBar: backAppbar(context, title: S.of(context).friend_set_text1),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Color(0xFFE8F2FF),
                  height: 10.h,
                ),
                Container(
                  margin: EdgeInsets.only(top: 32.h, bottom: 5.h),
                  height: 80.h,
                  width: 80.h,
                  child: ChatAvatarView(size: 79.h, url: _u?.icon),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFE8F2FF), width: 2),
                  ),
                ),
                Text(
                  _nickname ?? _u?.getShowName() ?? '',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                _buildItemView(
                  label: S.of(context).friend_set_text2,
                  backgroundColor: Color(0xFFE8F2FF),
                ).intoGesture(
                  onTap: () => NavigatorManager.push(
                    context,
                    BlocProvider(
                      bloc: ContactBloc()
                        ..initNickname(_nickname ?? _u?.getShowName()),
                      child: RemarkSetPage(
                        uid: _uid,
                      ),
                    ),
                  ),
                ),
                _buildItemView(
                  label: S.of(context).friend_set_text3,
                  showSwitch: true,
                  switchValue: true,
                  onChanged: (value) {},
                ),
                _buildItemView(
                  label: S.of(context).friend_set_text4,
                  showSwitch: true,
                  switchValue: (_isBlackList ?? _u?.isInBlackList) == 1,
                  onChanged: (value) {
                    showCommonDialog(
                      context,
                      title: sprintf(S.of(context).dialog_text2,
                          [_nickname ?? _u?.getShowName()]),
                      leftText: S.of(context).cancel,
                      rightText: S.of(context).confirm,
                    ).then((value) {
                      if (value == true) {
                        _bloc.addToBlackList(uid: _uid).then((value) {
                          setState(() {
                            _isBlackList = 1;
                          });
                        });
                      }
                    });
                  },
                ),
                _buildItemView(label: S.of(context).friend_set_text5)
                    .intoGesture(
                  onTap: () => showCommonDialog(
                    context,
                    title: sprintf(S.of(context).dialog_text1,
                        [_nickname ?? _u?.getShowName()]),
                    leftText: S.of(context).cancel,
                    rightText: S.of(context).clear,
                  ),
                ),
                SizedBox(height: 156.h,),
                Container(
                  height: 45.h,
                  color: Color(0xFF1B72EC),
                  alignment: Alignment.center,
                  child: Text(
                    S.of(context).friend_set_text6,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).intoGesture(
                  onTap: () => showCommonDialog(
                    context,
                    title: sprintf(S.of(context).dialog_text3,
                        [_nickname ?? _u?.getShowName()]),
                    leftText: S.of(context).cancel,
                    rightText: S.of(context).delete,
                  ).then((value) {
                    if (value == true) {
                      _bloc
                          .deleteFromFriendList(uid: _u?.uid ?? '')
                          .then((value) {
                        // Navigator.of(context);
                        NavigatorManager.backMain(context);
                      });
                    }
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemView({
    required String label,
    Color? backgroundColor,
    bool showSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onChanged,
  }) =>
      Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: BorderDirectional(
            bottom: BorderSide(
              color: Color(0xFF999999).withOpacity(0.4),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF333333),
              ),
            ),
            Spacer(),
            showSwitch
                ? SwitcherButton(
                    value: switchValue,
                    onChanged: onChanged,
                  )
                : assetImage('ic_next'),
          ],
        ),
      );
}
