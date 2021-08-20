import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/dialog_view.dart';
import 'package:eechart/widgets/img_radio.dart';
import 'package:eechart/widgets/touch_close_keyboard.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:sprintf/sprintf.dart';

class GroupMemberDeleteSelectPage extends StatefulWidget {
  const GroupMemberDeleteSelectPage({Key? key, required this.gid})
      : super(key: key);
  final String gid;

  @override
  _GroupMemberDeleteSelectPageState createState() =>
      _GroupMemberDeleteSelectPageState();
}

class _GroupMemberDeleteSelectPageState
    extends BaseState<GroupMemberDeleteSelectPage> {
  TextEditingController _controller = TextEditingController();
  List<GroupMembersInfo> _searchList = List.empty(growable: true);
  List<GroupMembersInfo> _selectedList = List.empty(growable: true);
  List<GroupMembersInfo> _list = List.empty(growable: true);
  FocusNode _focusNode = FocusNode();
  late GroupBloc _groupBloc;

  @override
  void initData() {
    _groupBloc = GroupBloc(gid: widget.gid)
      ..context = context
      ..getGroupMembers()
      ..groupMemberCtrl.listen((value) {
        setState(() {
          _list = value;
        });
      });

    _controller.addListener(() {
      setState(() {
        if (_controller.text.isNotEmpty) {
          _searchList = _list.where((e) {
            return e.nickName!
                .toUpperCase()
                .contains(_controller.text.toUpperCase());
          }).toList();
        } else {
          _searchList.clear();
        }
      });
    });
    super.initData();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: backAppbar(
          context,
          title: _selectedList.length > 0
              ? '${S.of(context).group_chat_text19}（${_selectedList.length}）'
              : S.of(context).group_chat_text19,
          right: Ink(
            decoration: BoxDecoration(
              color: Color(0xFF1B72EC),
              borderRadius: BorderRadius.circular(4),
            ),
            child: InkWell(
              onTap: () {
                showCommonDialog(
                  context,
                  title: S.of(context).group_chat_text22,
                  leftText: S.of(context).cancel,
                  rightText: S.of(context).confirm,
                ).then((value) {
                  if (value == true) {
                    _groupBloc
                        .kickGroupMember(list: _selectedList)
                        .then((value) => Navigator.pop(context, true));
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Text(
                  S.of(context).delete,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ).intoPadding(padding: EdgeInsets.only(right: 18.w)),
        ),
        body: Column(
          children: [
            _buildSearchView(),
            _controller.text.isEmpty
                ? ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (BuildContext context, int index) {
                      GroupMembersInfo model = _list[index];
                      if (model.userId == OpenIM.iMManager.uid) {
                        return Container();
                      }
                      return _buildItemView(info: model);
                    },
                  ).intoExpanded()
                : _buildSearchResultView().intoExpanded(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView({required GroupMembersInfo info}) => Container(
        height: 64.h,
        child: Row(
          children: [
            SizedBox(width: 17.w),
            ImageRadio(checked: info.ext == true),
            SizedBox(width: 15.w),
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
      ).intoGesture(onTap: () {
        setState(() {
          info.ext = !(info.ext ?? false);
          if (info.ext == true) {
            _selectedList.add(info);
          } else {
            _selectedList.remove(info);
          }
        });
      });

  Widget _buildSearchView() => Container(
        margin: EdgeInsets.only(top: 7.h, bottom: 12.h),
        height: 48.h,
        color: Color(0xFFE8F2FF),
        child: Row(
          children: [
            SizedBox(width: 18.w),
            assetImage(
              "ic_search",
              width: 23.h,
              height: 23.h,
              color: Color(0xFF999999),
            ),
            SizedBox(width: 10.w),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
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

  Widget _buildSearchResultView() => Stack(
        children: [
          if (_searchList.length > 0)
            Column(
              children: [
                Container(
                  color: Color(0xFF1B72EC).withOpacity(0.12),
                  alignment: Alignment.centerLeft,
                  height: 25.h,
                  padding: EdgeInsets.only(left: 22.w),
                  child: Text(
                    S.of(context).group_chat_text21,
                    style: TextStyle(fontSize: 14.sp, color: Color(0xFF1B72EC)),
                  ),
                ),
                ListView.builder(
                  itemExtent: 64.h,
                  itemCount: _searchList.length,
                  itemBuilder: (_, index) {
                    return _buildItemView(info: _searchList[index]);
                  },
                ).intoExpanded(),
              ],
            ),
          if (_searchList.length == 0)
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
