import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/dialog_view.dart';
import 'package:eechart/widgets/touch_close_keyboard.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:sprintf/sprintf.dart';

class GroupTransferSelectPage extends StatefulWidget {
  final String gid;

  const GroupTransferSelectPage({
    Key? key,
    required this.gid,
  }) : super(key: key);

  @override
  _GroupTransferSelectPageState createState() =>
      _GroupTransferSelectPageState();
}

class _GroupTransferSelectPageState extends BaseState<GroupTransferSelectPage> {
  TextEditingController _controller = TextEditingController();
  late GroupBloc _groupBloc;

  @override
  void initData() {
    _groupBloc = GroupBloc(gid: widget.gid)
      ..context = context
      ..getGroupMembers();

    _controller.addListener(() {
      setState(() {
        _groupBloc.searchGroupMembers(_controller.text);
      });
    });
    super.initData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: backAppbar(context, title: S.of(context).group_chat_text12),
        body: Column(
          children: [
            _buildSearchView(),
            _controller.text.isEmpty
                ? Flexible(
                    child: StreamBuilder(
                      stream: _groupBloc.groupMemberCtrl.stream,
                      builder: (_, AsyncSnapshot<List<GroupMembersInfo>> hot) {
                        return ListView.builder(
                          itemCount: hot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            if (hot.data![index].userId ==
                                OpenIM.iMManager.uid) {
                              return Container();
                            }
                            return _buildItemView(
                              info: hot.data![index],
                            );
                          },
                        );
                      },
                    ),
                  )
                : StreamBuilder(
                    stream: _groupBloc.searchGroupMemberCtrl.stream,
                    builder: (_, AsyncSnapshot<List<GroupMembersInfo>> hot) {
                      return _buildSearchResultView(hot.data ?? []);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView({required GroupMembersInfo info}) => InkWell(
        onTap: () {
          showCommonDialog(
            context,
            title: sprintf(S.of(context).group_chat_text33, [info.nickName]),
            leftText: S.of(context).cancel,
            rightText: S.of(context).confirm,
          ).then((value) {
            if (value == true) {
              _groupBloc
                  .transferGroupOwner(uid: info.userId!)
                  .then((value) => Navigator.pop(context, true));
            }
          });
        },
        child: Container(
          height: 64.h,
          child: Row(
            children: [
              SizedBox(width: 20.w),
              ChatAvatarView(
                size: 44.w,
                url: info.faceUrl,
              ),
              Container(
                height: 64.h,
                margin: EdgeInsets.only(left: 14.w),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(color: Color(0xFFE0E8FF), width: 1.h),
                  ),
                ),
                child: Text(
                  info.nickName ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).intoExpanded(),
            ],
          ),
        ),
      );

  Widget _buildSearchView() => Container(
        margin:
            EdgeInsets.only(top: 7.h, bottom: 12.h, left: 22.w, right: 22.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        height: 48.h,
        decoration: BoxDecoration(
          color: Color(0xFFE8F2FF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            assetImage(
              "ic_search",
              width: 18.h,
              height: 18.h,
              color: Color(0xFF999999),
            ),
            SizedBox(width: 10.w),
            TextField(
              controller: _controller,
              style: TextStyle(fontSize: 18.sp, color: Color(0xFF333333)),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: S.of(context).group_chat_text38,
                hintStyle: TextStyle(
                  fontSize: 18.sp,
                  color: Color(0xFF999999),
                ),
              ),
            ).intoExpanded(),
          ],
        ),
      );

  Widget _buildSearchResultView(List<GroupMembersInfo> list) => Stack(
        children: [
          if (list.length > 0)
            Column(
              children: [
                Container(
                  color: Color(0xFF1B72EC).withOpacity(0.12),
                  alignment: Alignment.centerLeft,
                  height: 25.h,
                  padding: EdgeInsets.only(left: 22.w),
                  child: Text(
                    S.of(context).group_chat_text5,
                    style: TextStyle(fontSize: 14.sp, color: Color(0xFF1B72EC)),
                  ),
                ),
                ListView.builder(
                  itemExtent: 64.h,
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return _buildItemView(info: list[index]);
                  },
                ).intoExpanded(),
              ],
            ),
          if (list.length == 0)
            Container(
              margin: EdgeInsets.only(top: 30.h),
              child: Text(
                sprintf(S.of(context).group_chat_text6, [_controller.text]),
                style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
              ),
            ),
        ],
      );
}
