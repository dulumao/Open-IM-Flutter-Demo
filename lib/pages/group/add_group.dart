import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/pages/chat/chat.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/touch_close_keyboard.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:sprintf/sprintf.dart';

import 'group_data_modify.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class _AddGroupPageState extends BaseState<AddGroupPage> {

  @override
  void initData() {
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(context, title: S.of(context).group_chat_text7),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 41.h,
              margin: EdgeInsets.only(
                left: 22.w,
                right: 22.w,
                top: 25.h,
                bottom: 16.h,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFE8F2FF),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  assetImage(
                    'ic_search',
                    width: 18.h,
                    height: 18.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    S.of(context).group_chat_text9,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(
                        0xFF666666,
                      ),
                    ),
                  ),
                ],
              ),
            ).intoGesture(
              onTap: () => NavigatorManager.push(
                context,
                _SearchAllPage(),
              ).then((close) {
                if (close == true) {
                  Navigator.pop(context, true);
                }
              }),
            ),
            Text(
              sprintf(
                  S.of(context).add_friend_text3, [OpenIM.iMManager.uid]),
              style: TextStyle(
                fontSize: 15.sp,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAllPage extends StatefulWidget {
  const _SearchAllPage({Key? key}) : super(key: key);

  @override
  __SearchAllPageState createState() => __SearchAllPageState();
}

class __SearchAllPageState extends BaseState<_SearchAllPage> {
  TextEditingController _controller = TextEditingController();
  late GroupBloc _groupBloc;

  @override
  void initState() {
    _groupBloc = GroupBloc(gid: '')..context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Container(
          color: Color(0xFF8ABFFF).withOpacity(0.2),
          child: SafeArea(
            child: Column(
              children: [
                _buildSearchBarView(),
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder(
                        stream: _groupBloc.searchGroupCtrl.stream,
                        builder: (_, AsyncSnapshot<List<GroupInfo>> hot) {
                          if (hot.hasData && _controller.text.isNotEmpty) {
                            if (hot.data!.length > 0) {
                              return _buildResultView(
                                info: hot.data![0],
                              ).intoGesture(
                                onTap: () => NavigatorManager.push(
                                  context,
                                  GroupResultDetailPage(
                                    gid: hot.data![0].groupID,
                                    isFromSearch: true,
                                  ),
                                ).then((close) {
                                  if (close == true)
                                    Navigator.pop(context, true);
                                }),
                              );
                            }
                            return _buildNoResultView();
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ).intoExpanded(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBarView() => Container(
        padding: EdgeInsets.only(left: 22.w, top: 10.h, bottom: 12.h),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  assetImage('ic_search', width: 19.h, height: 19.h),
                  TextField(
                    autofocus: true,
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      _groupBloc.searchGroup(gid: _controller.text);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 12.w,
                      ),
                    ),
                  ).intoExpanded(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 12.w),
                      assetImage('ic_clear', width: 20.h, height: 20.h),
                      SizedBox(width: 12.w),
                    ],
                  ).intoGesture(onTap: () {
                    setState(() {
                      _controller.text = "";
                    });
                  }),
                ],
              ),
            ).intoExpanded(),
            Text(
              S.of(context).cancel,
              style: TextStyle(
                fontSize: 18.sp,
                color: Color(0xFF1B72EC),
                fontWeight: FontWeight.w600,
              ),
            )
                .intoContainer(
              height: 41.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: 17.w,
              ),
            )
                .intoGesture(onTap: () => Navigator.pop(context)),
          ],
        ),
      );

  Widget _buildResultView({
    required GroupInfo info,
  }) =>
      Container(
        margin: EdgeInsets.only(top: 16.h),
        color: Color(0xFFE8F2FF),
        height: 59.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Row(
          children: [
            assetImage('ic_search_result_ic1'),
            SizedBox(
              width: 10.w,
            ),
            Text(
              S.of(context).add_friend_text4,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF333333),
              ),
            ),
            Text(
              info.groupID,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF333333),
              ),
            )
          ],
        ),
      );

  Widget _buildNoResultView() => Container(
        color: Color(0xFFE8F2FF),
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).group_chat_text8,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      );
}

class GroupResultDetailPage extends StatefulWidget {
  final String gid;
  final bool isFromSearch;

  const GroupResultDetailPage({
    Key? key,
    required this.gid,
    required this.isFromSearch,
  }) : super(key: key);

  @override
  _GroupResultDetailPageState createState() => _GroupResultDetailPageState();
}

class _GroupResultDetailPageState extends BaseState<GroupResultDetailPage> {
  late GroupBloc _bloc;

  @override
  void initData() {
    _bloc = GroupBloc(gid: widget.gid)
      ..context = context
      ..isJoinedGroup()
      ..getGroupInfo();
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(context),
      backgroundColor: Color(0xFFE8F2FF),
      body: Container(
        margin: EdgeInsets.only(left: 22.w, right: 22.w, top: 25.h),
        padding: EdgeInsets.only(top: 44.h, left: 22.w, right: 22.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.1),
              offset: Offset(0, 0),
              blurRadius: 11,
              spreadRadius: 3,
            ),
          ],
        ),
        child: StreamBuilder(
          stream: _bloc.groupInfoCtrl.stream,
          builder: (_, AsyncSnapshot<GroupInfo> gInfoHot) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ChatAvatarView(
                    size: 52.w,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gInfoHot.data?.groupName ?? '',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          assetImage('ic_group_chat4'),
                          SizedBox(width: 6.h),
                          Text(
                            sprintf(
                              S.of(context).group_chat_text41,
                              [gInfoHot.data?.groupID],
                            ),
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ).intoGesture(onTap: () {
                            longPressCopy(
                                context, gInfoHot.data?.groupID ?? '');
                          }).intoExpanded(),
                        ],
                      ),
                    ],
                  ).intoExpanded(),
                ],
              ),
              Visibility(
                visible: null != gInfoHot.data?.introduction &&
                    gInfoHot.data!.introduction!.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  padding: EdgeInsets.only(
                    top: 20.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 20.w,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    gInfoHot.data?.introduction ?? '',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: _bloc.joinedGroupCheckCtrl.stream,
                builder: (_, AsyncSnapshot<bool> hot) => InkWell(
                  onTap: () {
                    if (!widget.isFromSearch) {
                      NavigatorManager.push(
                          context,
                          GroupDataModifyPage(
                            gInfo: gInfoHot.data!,
                          ));
                    } else {
                      if (hot.data == true) {
                        NavigatorManager.push(
                            context,
                            ChatPage(
                              gid: gInfoHot.data?.groupID,
                              title: gInfoHot.data?.groupName,
                            )).then((value) => Navigator.pop(context, true));
                      } else {
                        _bloc.joinGroup();
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1B72EC),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: EdgeInsets.only(top: 99.h, bottom: 65.h),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 22.w,
                    ),
                    child: Text(
                      widget.isFromSearch
                          ? (hot.data == false
                              ? S.of(context).group_chat_text7
                              : S.of(context).group_chat_text37)
                          : S.of(context).group_chat_text23,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
