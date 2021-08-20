import 'package:eechart/blocs/group_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class GroupNotificationPage extends StatefulWidget {
  const GroupNotificationPage({Key? key}) : super(key: key);

  @override
  _GroupNotificationPageState createState() => _GroupNotificationPageState();
}

class _GroupNotificationPageState extends BaseState<GroupNotificationPage> {
  late GroupBloc _groupBloc;

  @override
  void initData() {
    _groupBloc = GroupBloc(gid: '')
      ..context = context
      ..getGroupApplicationList();
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(
        context,
        title: S.of(context).group_chat_text1,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _groupBloc.groupApplicationListCtrl.stream,
        builder: (_, AsyncSnapshot<List<GroupApplicationInfo>> hot) {
          return ListView.builder(
            itemCount: hot.data?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return _buildItemView(hot.data![index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildItemView(GroupApplicationInfo info) => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
            child: Row(
              children: [
                ChatAvatarView(
                  size: 44.w,
                  url: info.fromUserFaceURL,
                ),
                SizedBox(
                  width: 14.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.fromUserNickName ?? '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Apply to join',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Color(0xFF333333),
                        ),
                        children: [
                          TextSpan(
                            text: ' Computer group ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFF1B72EC),
                            ),
                          ),
                          TextSpan(
                            text: 'From number search',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFF333333),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ).intoExpanded(),
                SizedBox(
                  width: 39.w,
                ),
                if (info.handleStatus == 0)
                  Column(
                    children: [
                      _buildBtn(
                        text: S.of(context).agree,
                        textColor: Colors.white,
                        color: Color(0xFF1B72EC),
                        onTap: () {
                          _groupBloc.acceptGroupApplication(info: info);
                        },
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      _buildBtn(
                        text: S.of(context).refuse,
                        textColor: Color(0xFF333333),
                        color: Color(0xFFD8D8D8),
                        onTap: () {
                          _groupBloc.refuseGroupApplication(info: info);
                        },
                      ),
                    ],
                  ),
                if (info.handleStatus != 0)
                  Text(
                    info.handleResult == 0
                        ? S.of(context).group_chat_text39
                        : S.of(context).group_chat_text40,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF999999),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 80.w),
            height: 1,
            color: Color(0xFFE5EBFF),
          ),
        ],
      );

  Widget _buildBtn({
    required text,
    Function()? onTap,
    required textColor,
    required color,
  }) =>
      Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: 47.w,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: textColor,
              ),
            ),
          ),
        ),
      );
}
