import 'package:azlistview/azlistview.dart';
import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/models/contact_info.dart';
import 'package:eechart/pages/chat/chat.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/img_radio.dart';
import 'package:eechart/widgets/touch_close_keyboard.dart';
import 'package:sprintf/sprintf.dart';

class GroupMemberAddSelectPage extends StatefulWidget {
  final String title;
  final String? gid;

  const GroupMemberAddSelectPage({
    Key? key,
    required this.title,
    this.gid,
  }) : super(key: key);

  @override
  _GroupMemberAddSelectPageState createState() =>
      _GroupMemberAddSelectPageState();
}

class _GroupMemberAddSelectPageState
    extends BaseState<GroupMemberAddSelectPage> {
  List<ContactInfo> _list = List.empty(growable: true);
  List<ContactInfo> _selectedList = List.empty(growable: true);
  List<ContactInfo> _searchList = List.empty(growable: true);
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _showSearchIcon = true;
  late GroupBloc _groupBloc;

  void getAllContactList() {
    if (contactList.length > topList.length) {
      for (int i = topList.length; i < contactList.length; i++) {
        _list.add(ContactInfo.fromJson(contactList[i].toJson()));
      }
    }
  }

  @override
  void initData() {
    _groupBloc = GroupBloc(gid: widget.gid ?? '')..context = context;
    _focusNode.addListener(() {
      setState(() {
        _showSearchIcon = !_focusNode.hasFocus;
      });
    });
    _controller.addListener(() {
      setState(() {
        if (_controller.text.isNotEmpty) {
          _searchList = _list
              .where((e) => e.nickname
                  .toUpperCase()
                  .contains(_controller.text.toUpperCase()))
              .toList();
        } else {
          _searchList.clear();
        }
      });
    });
    setState(() {
      getAllContactList();
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
        appBar: backAppbar(context, title: widget.title),
        body: Column(
          children: [
            _buildSearchView(),
            _controller.text.isEmpty
                ? AzListView(
                    data: _list,
                    itemCount: _list.length,
                    itemBuilder: (BuildContext context, int index) {
                      ContactInfo model = _list[index];
                      return _buildItemView(info: model);
                    },
                    // physics: BouncingScrollPhysics(),
                    susItemBuilder: (BuildContext context, int index) {
                      ContactInfo model = _list[index];
                      if ('↑' == model.getSuspensionTag()) {
                        return Container();
                      }
                      return _buildSubTitleItemView(
                          tag: model.getSuspensionTag());
                    },
                    indexBarData: SuspensionUtil.getTagIndexList(_list),
                    // indexBarData: ['↑', '☆', ...kIndexBarData],
                    indexBarOptions: IndexBarOptions(
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF1B72EC),
                        fontWeight: FontWeight.w600,
                      ),
                      needRebuild: true,
                      ignoreDragCancel: true,
                      downTextStyle:
                          TextStyle(fontSize: 12, color: Colors.white),
                      downItemDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      indexHintWidth: 120 / 2,
                      indexHintHeight: 100 / 2,
                      indexHintDecoration: BoxDecoration(
                          // image: DecorationImage(
                          //   image: AssetImage(getImgPath('ic_index_bar_bubble_gray')),
                          //   fit: BoxFit.contain,
                          // ),
                          ),
                      indexHintAlignment: Alignment.centerRight,
                      indexHintChildAlignment: Alignment(-0.25, 0.0),
                      indexHintOffset: Offset(-20, 0),
                    ),
                  ).intoExpanded()
                : _buildSearchResultView().intoExpanded(),
            _buildCompleteBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView({required ContactInfo info}) => Container(
        height: 64.h,
        child: Row(
          children: [
            SizedBox(width: 17.w),
            ImageRadio(checked: info.isChecked == true),
            SizedBox(width: 15.w),
            ChatAvatarView(
              size: 44.w,
              url: info.icon,
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
                info.nickname,
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
          info.isChecked = !(info.isChecked ?? false);
          if (info.isChecked == true) {
            _selectedList.add(info);
          } else {
            _selectedList.remove(info);
          }
        });
      });

  Widget _buildSubTitleItemView({required String tag}) => Container(
        height: 25.h,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 22.w),
        color: Color(0xFF1B72EC).withOpacity(0.12),
        alignment: Alignment.centerLeft,
        child: Text(
          '$tag',
          softWrap: false,
          style: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFF1B72EC),
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _buildSearchView() => Container(
        margin: EdgeInsets.only(top: 7.h, bottom: 12.h),
        // padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 3.h),
        height: 48.h,
        decoration: BoxDecoration(
          color: Color(0xFFE8F2FF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: 34.w * _selectedList.length,
              height: 34.w,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _selectedList
                    .map((e) => _buildCheckedAvatar(info: e))
                    .toList(),
              ),
            ),
            RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) {
                /*if (event.data is RawKeyEventDataAndroid) {
                  var data = event.data as RawKeyEventDataAndroid;
                  if (data.keyCode == 67) {
                    if (_controller.text.isEmpty && _selectedList.length > 0) {
                      setState(() {
                        _selectedList.removeLast().isChecked = false;
                      });
                    }
                  }
                } else if (event.data is RawKeyEventDataIos) {
                  var data = event.data as RawKeyEventDataIos;
                  if (data.keyCode == 67) {
                    if (_controller.text.isEmpty && _selectedList.length > 0) {
                      setState(() {
                        _selectedList.removeLast().isChecked = false;
                      });
                    }
                  }
                }*/
              },
              child: Row(
                children: [
                  Visibility(
                    visible: _selectedList.length == 0 && _showSearchIcon,
                    child: assetImage(
                      "ic_search",
                      width: 23.h,
                      height: 23.h,
                      color: Color(0xFF999999),
                    ).intoPadding(padding: EdgeInsets.only(left: 22.w)),
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
            ).intoExpanded(),
          ],
        ),
      );

  Widget _buildCheckedAvatar({required ContactInfo info}) => ChatAvatarView(
        size: 34.w,
        url: info.icon,
        onTap: () {
          setState(() {
            info.isChecked = false;
            _selectedList.remove(info);
          });
        },
      );

  Widget _buildCompleteBtn() => Container(
        height: 56.h,
        color: Color(0xFFE8F2FF),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                if (widget.gid == null) {
                  _groupBloc.createGroup(_selectedList).then((gid) {
                    NavigatorManager.push(context, ChatPage(gid: gid)).then(
                      (value) => Navigator.pop(context),
                    );
                  });
                } else {
                  _groupBloc
                      .inviteUserToGroup(list: _selectedList)
                      .then((value) => Navigator.pop(context, true));
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 40.h,
                margin: EdgeInsets.only(right: 15.w /*, left: 287.w*/),
                padding: EdgeInsets.only(left: 7.w, right: 7.w),
                decoration: BoxDecoration(
                  color: Color(0xFF1B72EC),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _selectedList.length > 0
                      ? '${S.of(context).group_chat_text4}（${_selectedList.length}）'
                      : S.of(context).group_chat_text4,
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              ),
            ),
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
                    S.of(context).group_chat_text5,
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
