import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/group/group_transfer_select.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/dialog_view.dart';
import 'package:eechart/widgets/switcher_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import 'add_group.dart';
import 'group_member_add_select.dart';
import 'group_member_delete_select.dart';
import 'group_member_list.dart';

class GroupSettingPage extends StatefulWidget {
  final String gid;
  final bool exitGroupBackMainPage;

  const GroupSettingPage(
      {Key? key, required this.gid, this.exitGroupBackMainPage = true})
      : super(key: key);

  @override
  _GroupSettingPageState createState() => _GroupSettingPageState();
}

class _GroupSettingPageState extends BaseState<GroupSettingPage> {
  late GroupBloc _bloc;

  @override
  void initData() {
    _bloc = GroupBloc(gid: widget.gid)
      ..context = context
      ..getGroupInfo()
      ..getGroupMembers()
      ..getGroupMembersRole(uid: OpenIM.iMManager.uid);
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(context, title: S.of(context).group_chat_text10),
      backgroundColor: Color(0xFFE8F2FF),
      body: StreamBuilder(
        stream: _bloc.groupRoleCtrl.stream,
        builder: (_, AsyncSnapshot<int> roleHot) {
          int role = roleHot.data ?? GroupRole.member;
          return StreamBuilder(
            stream: _bloc.groupInfoCtrl.stream,
            builder: (_, AsyncSnapshot<GroupInfo> gInfoHot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    _buildGroupInfoView(gInfoHot.data, role),
                    _buildGroupMemberView(role),
                    _buildItemView(
                      label: S.of(context).group_chat_text11,
                      onTap: () => _editAnnouncement(gInfoHot.data!, role),
                    ),
                    _buildItemView(
                      label: S.of(context).group_chat_text12,
                      onTap: () => _groupTransfer(role),
                    ),
                    _buildItemView(
                      label: S.of(context).group_chat_text13,
                      onTap: () => _editMyGroupNickName(),
                    ),
                    SizedBox(height: 10.h),
                    _buildItemView(
                      label: S.of(context).group_chat_text14,
                    ),
                    SizedBox(height: 10.h),
                    _buildItemView(
                      label: S.of(context).group_chat_text15,
                    ),
                    _buildItemView(
                      label: S.of(context).group_chat_text16,
                      showSwitch: true,
                    ),
                    SizedBox(height: 10.h),
                    _buildItemView(
                      label: S.of(context).group_chat_text17,
                      showSwitch: true,
                    ),
                    SizedBox(height: 40.h),
                    _buildExitBtn(
                      gInfoHot.data,
                      roleHot.data ?? GroupRole.member,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGroupMemberView(int role) => StreamBuilder(
        stream: _bloc.groupMemberCtrl.stream,
        builder: (_, AsyncSnapshot<List<GroupMembersInfo>> hot) {
          var list = hot.data;
          var len = list?.length ?? 0;
          if (role == GroupRole.member) {
            len = (len > 5 ? 5 : len) + 1;
          } else {
            len = (len > 5 ? 5 : len) + 2;
          }

          return Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Color(0xFF000000).withOpacity(0.1),
                )
              ],
            ),
            child: Row(
              children: [
                GridView.builder(
                  itemCount: len,
                  // scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 34 / 54,
                  ),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    top: 10.h,
                    bottom: 10.h,
                    left: 22.w,
                  ),
                  itemBuilder: (_, index) {
                    if (role == GroupRole.member) {
                      int add = len - 1;
                      if (index == add) {
                        return _addMemberBtn();
                      }
                      return _buildMemberItemView(info: list![index]);
                    } else {
                      int sub = len - 1;
                      int add = len - 2;
                      if (index == add) {
                        return _addMemberBtn();
                      }
                      if (index == sub) {
                        return _subMemberBtn();
                      }
                      return _buildMemberItemView(info: list![index]);
                    }
                  },
                ).intoExpanded(),
                Container(
                  padding: EdgeInsets.only(right: 22.w, left: 5.w),
                  child: Column(
                    children: [
                      assetImage('ic_group_member_more'),
                      SizedBox(height: 6.h),
                      Text(
                        '',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ).intoGesture(
                  onTap: () => NavigatorManager.push(
                    context,
                    GroupMemberListPage(
                      list: list ?? [],
                      gid: widget.gid,
                      role: role,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget _subMemberBtn() => _buildMemberBtn(
      icon: 'ic_group_member_sub',
      onTap: () {
        NavigatorManager.push(
          context,
          GroupMemberDeleteSelectPage(
            gid: widget.gid,
          ),
        ) /*.then((value) {
          if (value == true) {
            _bloc.getGroupMembers();
          }
        })*/
            ;
      });

  Widget _addMemberBtn() => _buildMemberBtn(
      icon: 'ic_group_member_add',
      onTap: () {
        NavigatorManager.push(
          context,
          GroupMemberAddSelectPage(
            title: S.of(context).group_chat_text20,
            gid: widget.gid,
          ),
        ) /*.then((value) {
          if (value == true) {
            _bloc.getGroupMembers();
          }
        })*/
            ;
      });

  Widget _buildGroupInfoView(GroupInfo? info, int role) => Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 4,
              color: Color(0xFF000000).withOpacity(0.1),
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            _checkPermission(
              role: role,
              fc: () => NavigatorManager.push(
                context,
                GroupResultDetailPage(
                  gid: widget.gid,
                  isFromSearch: false,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 22.w,
            ),
            child: Row(
              crossAxisAlignment:
                  (null != info?.introduction && info!.introduction!.isNotEmpty)
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
              children: [
                ChatAvatarView(
                  size: 50.w,
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info?.groupName ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Visibility(
                      visible: null != info?.introduction &&
                          info!.introduction!.isNotEmpty,
                      child: Text(
                        info?.introduction ?? '',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Color(0xFF666666),
                        ),
                      ).intoPadding(padding: EdgeInsets.only(top: 6.h)),
                    ),
                  ],
                ).intoExpanded(),
              ],
            ),
          ),
        ),
      );

  Widget _buildItemView({
    required String label,
    bool showSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 4,
              color: Color(0xFF000000).withOpacity(0.1),
            )
          ],
        ),
        child: InkWell(
          onTap: onTap,
          splashColor: Color(0xFFE8F2FF),
          child: Container(
            height: 49.h,
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                showSwitch
                    ? SwitcherButton(
                        value: switchValue,
                        onChanged: onChanged,
                      )
                    : assetImage('ic_next', width: 10.w, height: 17.h),
              ],
            ),
          ),
        ),
      );

  Widget _buildMemberItemView({required GroupMembersInfo info}) {
    groupMemberInfoMap[info.userId!] = info;
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatAvatarView(
            size: 34.w,
            url: info.faceUrl,
          ),
          SizedBox(height: 6.h),
          Text(
            info.nickName ?? "",
            style: TextStyle(
              fontSize: 10.sp,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberBtn({required String icon, Function()? onTap}) =>
      Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onTap,
              child: assetImage(
                icon,
                width: 34.w,
                height: 34.w,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '',
              style: TextStyle(
                fontSize: 10.sp,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      );

  Widget _buildExitBtn(GroupInfo? info, int role) => Ink(
        color: Color(0xFF1B72EC),
        child: InkWell(
          onTap: () {
            if (role == GroupRole.owner && (info?.memberCount ?? 0) > 1) {
              showCommonDialog(
                context,
                title: S.of(context).group_chat_text34,
                leftText: S.of(context).cancel,
                rightText: S.of(context).confirm,
              ).then((confirm) {
                if (confirm == true) {
                  _groupTransfer(role).then((exit) {
                    if (exit == true) {
                      _bloc.quitGroup().then((value) {
                        if (widget.exitGroupBackMainPage) {
                          NavigatorManager.backMain(context);
                        } else {
                          Navigator.pop(context, true);
                        }
                      });
                    }
                  });
                }
              });
            } else {
              _bloc.quitGroup().then((value) {
                if (widget.exitGroupBackMainPage) {
                  NavigatorManager.backMain(context);
                } else {
                  Navigator.pop(context, true);
                }
              });
            }
          },
          child: Container(
            height: 52.h,
            alignment: Alignment.center,
            child: Text(
              S.of(context).group_chat_text18,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

  void _editAnnouncement(GroupInfo gInfo, int role) {
    _checkPermission(
      role: role,
      fc: () => NavigatorManager.push(
        context,
        _EditGroupAnnouncementPage(gInfo: gInfo),
      ),
    );
  }

  Future<dynamic> _checkPermission({
    required int role,
    required Future<dynamic> Function() fc,
  }) {
    if (role == GroupRole.member) {
      showCommonDialog(
        context,
        title: S.of(context).group_chat_text35,
        leftText: S.of(context).cancel,
        rightText: S.of(context).confirm,
      );
      return Future.value(false);
    }
    return fc();
  }

  Future<dynamic> _groupTransfer(int role) {
    return _checkPermission(
      role: role,
      fc: () => NavigatorManager.push(
        context,
        GroupTransferSelectPage(gid: widget.gid),
      ),
    );
  }

  void _editMyGroupNickName() {
    NavigatorManager.push(
      context,
      _ModifyMyNicknamePage(value: ''),
    );
  }
}

class _EditGroupAnnouncementPage extends StatefulWidget {
  final GroupInfo gInfo;

  const _EditGroupAnnouncementPage({Key? key, required this.gInfo})
      : super(key: key);

  @override
  _EditGroupAnnouncementPageState createState() =>
      _EditGroupAnnouncementPageState();
}

class _EditGroupAnnouncementPageState
    extends State<_EditGroupAnnouncementPage> {
  TextEditingController _controller = TextEditingController();
  late GroupBloc _groupBloc;

  @override
  void initState() {
    _controller.text = widget.gInfo.notification ?? '';
    _groupBloc = GroupBloc(gid: widget.gInfo.groupID)..context = context;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(
        context,
        title: S.of(context).group_chat_text11,
        right: Text(
          S.of(context).group_chat_text28,
          style: TextStyle(fontSize: 14.sp, color: Color(0xFFFFFFFF)),
        )
            .intoContainer(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
          margin: EdgeInsets.only(right: 13.w),
          decoration: BoxDecoration(
            color: Color(0xFF1B72EC),
            borderRadius: BorderRadius.circular(4),
          ),
        )
            .intoGesture(onTap: () {
          if (_controller.text.isNotEmpty) {
            _groupBloc
                .setGroupInfo(
                  gInfo: GroupInfo(
                    groupID: widget.gInfo.groupID,
                    notification: _controller.text,
                  ),
                )
                .then((value) => Navigator.pop(context));
          }
        }),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 7),
              child: TextField(
                controller: _controller,
                style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
                minLines: 5,
                maxLines: 11,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: S.of(context).group_chat_text29,
                  hintStyle: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModifyMyNicknamePage extends StatefulWidget {
  final String value;

  const _ModifyMyNicknamePage({Key? key, required this.value})
      : super(key: key);

  @override
  _ModifyMyNicknamePageState createState() => _ModifyMyNicknamePageState();
}

class _ModifyMyNicknamePageState extends State<_ModifyMyNicknamePage> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.value;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(
        context,
        title: S.of(context).group_chat_text30,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 56.h,
              margin: EdgeInsets.only(top: 15.h, left: 42.w, right: 42.w),
              // padding: EdgeInsets.only(left: 22.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: BorderDirectional(
                  top: BorderSide(
                    width: 1,
                    color: Color(0xFF333333).withOpacity(0.4),
                  ),
                  bottom: BorderSide(
                    width: 1,
                    color: Color(0xFF333333).withOpacity(0.4),
                  ),
                ),
              ),
              child: Row(
                children: [
                  ChatAvatarView(
                    size: 36.w,
                  ),
                  TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ).intoExpanded(),
                  assetImage('ic_clear')
                      .intoContainer()
                      .intoGesture(onTap: () => _controller.text = ""),
                ],
              ),
            ),
            SizedBox(
              height: 234.h,
            ),
            Text(
              S.of(context).group_chat_text31,
              style: TextStyle(fontSize: 14.sp, color: Color(0xFF666666)),
            ).intoPadding(
                padding: EdgeInsets.only(
              left: 34.w,
              right: 34.w,
            )),
            SizedBox(
              height: 68.h,
            ),
            Container(
              width: 149.w,
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFF1B72EC),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                S.of(context).group_chat_text28,
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
