import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/pages/chat/chat.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/touch_close_keyboard.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sprintf/sprintf.dart';

class AddFriendPage extends StatelessWidget {
  AddFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactBloc? bloc = BlocProvider.of<ContactBloc>(context);
    return Scaffold(
      appBar: backAppbar(context, title: S.of(context).add_friend_text1),
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
                    color: Color(0xFF666666),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    S.of(context).add_friend_text2,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ).intoGesture(
              onTap: () => NavigatorManager.push(
                context,
                BlocProvider(bloc: ContactBloc(), child: _SearchAllPage()),
              ).then((close) {
                if (close == true) {
                  Navigator.pop(context, true);
                }
              }),
            ),
            StreamBuilder(
              stream: bloc?.uidCtrl.stream,
              builder: (_, AsyncSnapshot<String> hot) => Column(
                children: [
                  Text(
                    sprintf(S.of(context).add_friend_text3, [hot.data]),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Color(
                        0xFF666666,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  QrImage(
                    data: hot.data ?? '',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAllPage extends StatelessWidget {
  const _SearchAllPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactBloc? bloc = BlocProvider.of<ContactBloc>(context);
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Container(
          color: Color(0xFF8ABFFF).withOpacity(0.2),
          child: SafeArea(
            child: Column(
              children: [
                _buildSearchBarView(context: context, bloc: bloc),
                Container(
                  color: Colors.white,
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder(
                        builder: (
                          _,
                          AsyncSnapshot<List<UserInfo>> hot,
                        ) {
                          if (hot.hasData) {
                            if (hot.data!.length > 0) {
                              return _buildResultView(
                                context: context,
                                info: hot.data![0],
                              ).intoGesture(
                                onTap: () => NavigatorManager.push(
                                  context,
                                  BlocProvider(
                                    bloc: ContactBloc()
                                      ..checkFriend(hot.data![0].uid),
                                    child: SelectResultPage(info: hot.data![0]),
                                  ),
                                ).then((close) {
                                  if (close == true)
                                    Navigator.pop(context, true);
                                }),
                              );
                            }
                            return _buildNoResultView(context: context);
                          }
                          return Container();
                        },
                        stream: bloc?.searchUserListCtrl.stream,
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

  Widget _buildSearchBarView(
          {required BuildContext context, ContactBloc? bloc}) =>
      Container(
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
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => bloc?.getUsersInfo(value),
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
                  ),
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

  Widget _buildResultView(
          {required BuildContext context, required UserInfo info}) =>
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
              info.uid,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF333333),
              ),
            )
          ],
        ),
      );

  Widget _buildNoResultView({required BuildContext context}) => Container(
        color: Color(0xFFE8F2FF),
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).add_friend_text5,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      );
}

class SelectResultPage extends StatelessWidget {
  final UserInfo info;

  const SelectResultPage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactBloc? bloc = BlocProvider.of<ContactBloc>(context);
    return Scaffold(
      appBar: backAppbar(context),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 41.h, left: 22.w, right: 22.w),
            decoration: BoxDecoration(
              color: Color(0xFFFAFCFF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.14),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 28.h,
                ),
                ChatAvatarView(size: 70.w, url: info.icon),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  info.name ?? '--',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  sprintf(S.of(context).add_friend_text8, [info.uid]),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF666666),
                  ),
                ),
                Container(
                  height: 40.h,
                  width: 127.w,
                  decoration: BoxDecoration(
                    color: Color(0xFF1B72EC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: EdgeInsets.only(top: 28.h, bottom: 38.h),
                  child: StreamBuilder(
                    stream: bloc?.checkFriendCtrl.stream,
                    builder: (_, AsyncSnapshot<UserInfo> hot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          assetImage(
                            hot.data?.flag == 1 ? 'ic_msg' : 'ic_add_friend1',
                            width: 14.w,
                            height: 14.w,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            hot.data?.flag == 1
                                ? S.of(context).add_friend_text7
                                : S.of(context).add_friend_text6,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ).intoGesture(onTap: () {
                        if (hot.data?.flag == 1) {
                          NavigatorManager.push(
                              context,
                              ChatPage(
                                uid: info.uid,
                                title: info.getShowName(),
                              )).then((value) => Navigator.pop(context, true));
                        } else {
                          bloc?.addFriend(uid: info.uid, reason: '');
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
