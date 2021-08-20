import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/chat/chat.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({Key? key}) : super(key: key);

  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends BaseState<GroupListPage> {
  late GroupBloc _bloc;
  TextEditingController _controller = TextEditingController();

  @override
  void initData() {
    _bloc = GroupBloc(gid: '')
      ..context = context
      ..getJoinedGroupList();
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(context, title: S.of(context).group_chat_text36),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _bloc.joinedGrouListCtrl.stream,
        builder: (_, AsyncSnapshot<List<GroupInfo>> hot) {
          return Column(
            children: [
              buildSearchView(controller: _controller),
              Flexible(
                child: ListView.builder(
                  itemCount: hot.data?.length ?? 0,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        NavigatorManager.push(
                          context,
                          ChatPage(
                            uid: null,
                            gid: hot.data![index].groupID,
                            title: hot.data![index].groupName ?? '',
                            exitGroupBackMainPage: false,
                          ),
                        );
                      },
                      child: _buildItem(
                        groupName: hot.data![index].groupName ?? '',
                        groupAvatar: hot.data![index].faceUrl,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem({String? groupAvatar, required String groupName}) => [
        SizedBox(width: 22.w),
        ChatAvatarView(
          url: groupAvatar,
          size: 42.w,
        ),
        SizedBox(width: 14.w),
        Text(
          groupName,
          style: TextStyle(
            fontSize: 16.sp,
            color: Color(0xFF333333),
          ),
        )
            .intoContainer(
              height: 70.h,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 22.w),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(color: Color(0xFFE5EBFF), width: 1),
                ),
              ),
            )
            .intoExpanded(),
      ].intoRow();
}
