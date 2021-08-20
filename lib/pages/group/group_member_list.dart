import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/group/group_member_delete_select.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import 'group_member_add_select.dart';

class GroupMemberListPage extends StatefulWidget {
  const GroupMemberListPage({
    Key? key,
    required this.list,
    required this.gid,
    required this.role,
  }) : super(key: key);
  final List<GroupMembersInfo> list;
  final String gid;
  final int role;

  @override
  _GroupMemberListPageState createState() => _GroupMemberListPageState();
}

class _GroupMemberListPageState extends BaseState<GroupMemberListPage> {
  late GroupBloc _bloc;

  @override
  void initData() {
    _bloc = GroupBloc(gid: widget.gid)
      ..context = context
      ..getGroupMembers(list: widget.list);
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(context, title: S.of(context).group_chat_text19),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildSearchView(),
          StreamBuilder(
            stream: _bloc.groupMemberCtrl.stream,
            builder: (_, AsyncSnapshot<List<GroupMembersInfo>> hot) {
              var list = hot.data;
              var len = list?.length ?? 0;
              if (widget.role == GroupRole.member) {
                len = (len > 5 ? 5 : len) + 1;
              } else {
                len = (len > 5 ? 5 : len) + 2;
              }
              return GridView.builder(
                itemCount: len,
                // scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 16.h,
                  // childAspectRatio: 42 / 61,
                ),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: 20.h,
                  bottom: 20.h,
                  left: 14.w,
                  right: 14.w,
                ),
                itemBuilder: (_, index) {
                  if (widget.role == GroupRole.member) {
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
              );
            },
          ).intoExpanded(),
        ],
      ),
    );
  }

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

  Widget _buildMemberItemView({required GroupMembersInfo info}) => Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatAvatarView(size: 42.w, url: info.faceUrl),
            SizedBox(height: 2.h),
            Text(
              info.nickName ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      );

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
                width: 42.w,
                height: 42.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      );

  Widget _buildSearchView() => Row(
        children: [
          assetImage(
            "ic_search",
            width: 24.h,
            height: 24.h,
            color: Color(0xFF999999),
          ),
          SizedBox(width: 10.w),
          TextField(
            style: TextStyle(fontSize: 18.sp, color: Color(0xFF333333)),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: S.of(context).group_chat_text38,
              hintStyle: TextStyle(
                fontSize: 18.sp,
                color: Color(0xFF999999),
              ),
              contentPadding: EdgeInsets.all(0),
            ),
          ).intoExpanded(),
        ],
      ).intoContainer(
        padding: EdgeInsets.only(
          top: 18.h,
          bottom: 13.h,
          left: 22.w,
          right: 22.w,
        ),
      );
}
