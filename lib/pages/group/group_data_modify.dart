import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class GroupDataModifyPage extends StatefulWidget {
  final GroupInfo gInfo;

  const GroupDataModifyPage({Key? key, required this.gInfo}) : super(key: key);

  @override
  _GroupDataModifyPageState createState() => _GroupDataModifyPageState();
}

class _GroupDataModifyPageState extends BaseState<GroupDataModifyPage> {
  late GroupBloc _bloc;

  @override
  void initData() {
    // _bloc = GroupBloc(gid: '')..context = context;
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(context, title: S.of(context).group_chat_text23),
      backgroundColor: Color(0xFFE8F2FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            _buildItemView(
              label: S.of(context).group_chat_text24,
              onTap: () {
                NavigatorManager.push(
                  context,
                  _EditGroupNamePage(gInfo: widget.gInfo),
                ).then((value) {
                  if (value = true) {
                    setState(() {});
                  }
                });
              },
            ),
            _buildItemView(
              label: S.of(context).group_chat_text25,
            ),
            _buildItemView(
              label: S.of(context).group_chat_text26,
              onTap: () {
                NavigatorManager.push(
                  context,
                  _EditGroupIntroductionPage(gInfo: widget.gInfo),
                ).then((value) {
                  if (value = true) {
                    setState(() {});
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
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
                assetImage('ic_next', width: 10.w, height: 17.h),
              ],
            ),
          ),
        ),
      );
}

class _EditGroupNamePage extends StatefulWidget {
  final GroupInfo gInfo;

  const _EditGroupNamePage({Key? key, required this.gInfo}) : super(key: key);

  @override
  __EditGroupNamePageState createState() => __EditGroupNamePageState();
}

class __EditGroupNamePageState extends State<_EditGroupNamePage> {
  TextEditingController _controller = TextEditingController();
  late GroupBloc _groupBloc;

  @override
  void initState() {
    _groupBloc = GroupBloc(gid: widget.gInfo.groupID)..context = context;
    _controller.text = widget.gInfo.groupName ?? '';
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
        title: S.of(context).group_chat_text27,
        right: Text(
          S.of(context).submit,
          style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
        ).intoContainer(padding: EdgeInsets.only(right: 22.w)).intoGesture(
            onTap: () {
          if (_controller.text.isNotEmpty) {
            _groupBloc
                .setGroupInfo(
              gInfo: GroupInfo(
                groupID: widget.gInfo.groupID,
                groupName: _controller.text,
              ),
            )
                .then((value) {
              widget.gInfo.groupName = _controller.text;
              Navigator.pop(context, true);
            });
          }
        }),
      ),
      backgroundColor: Color(0xFFE8F2FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 56.h,
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.only(left: 22.w),
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
                  TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ).intoExpanded(),
                  assetImage('ic_clear')
                      .intoContainer(
                          padding: EdgeInsets.symmetric(horizontal: 22.w))
                      .intoGesture(onTap: () => _controller.text = ""),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EditGroupIntroductionPage extends StatefulWidget {
  final GroupInfo gInfo;

  const _EditGroupIntroductionPage({Key? key, required this.gInfo})
      : super(key: key);

  @override
  __EditGroupIntroductionPageState createState() =>
      __EditGroupIntroductionPageState();
}

class __EditGroupIntroductionPageState
    extends State<_EditGroupIntroductionPage> {
  TextEditingController _controller = TextEditingController();
  late GroupBloc _groupBloc;

  @override
  void initState() {
    _groupBloc = GroupBloc(gid: widget.gInfo.groupID)..context = context;
    _controller.text = widget.gInfo.introduction ?? '';
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
        title: S.of(context).group_chat_text32,
        right: Text(
          S.of(context).submit,
          style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
        ).intoContainer(padding: EdgeInsets.only(right: 22.w)).intoGesture(
            onTap: () {
          if (_controller.text.isNotEmpty) {
            _groupBloc
                .setGroupInfo(
              gInfo: GroupInfo(
                groupID: widget.gInfo.groupID,
                introduction: _controller.text,
              ),
            )
                .then((value) {
              widget.gInfo.introduction = _controller.text;
              Navigator.pop(context, true);
            });
          }
        }),
      ),
      backgroundColor: Color(0xFFE8F2FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 306.h,
              margin: EdgeInsets.only(top: 10.h,left: 22.w,right: 22.w),
              padding: EdgeInsets.only(left: 22.w),
              decoration: BoxDecoration(
                color: Colors.white,
               borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
                    maxLines: 30,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ).intoExpanded(),
                /*  assetImage('ic_clear')
                      .intoContainer(
                          padding: EdgeInsets.symmetric(horizontal: 22.w))
                      .intoGesture(onTap: () => _controller.text = ""),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}