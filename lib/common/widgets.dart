import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/contacts/add_friend.dart';
import 'package:eechart/pages/group/add_group.dart';
import 'package:eechart/pages/group/group_member_add_select.dart';
import 'package:eechart/pages/mine/qr_scanner.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/copy_custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';

Widget assetImage(String res,
    {double? width, double? height, BoxFit? fit, Color? color}) {
  return Image.asset(
    imageResStr(res),
    width: width,
    height: height,
    fit: fit,
    color: color,
  );
}

AppBar backAppbar(
  BuildContext context, {
  dynamic data,
  String? title,
  Widget? right,
  Widget? center,
  Function()? onBack,
  Color? backgroundColor,
  Color? backBtnColor,
}) =>
    appbar(
      context,
      back: true,
      right: right,
      data: data,
      onBack: onBack,
      backgroundColor: backgroundColor,
      backBtnColor: backBtnColor,
      center: center ??
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: 18.sp,
              color: Color(0xFF333333),
              // fontWeight: FontWeight.w600,
            ),
          ),
    );

AppBar eechartAppbar(
  BuildContext context, {
  String? title,
  Widget? right,
  Function()? onBack,
  Color? backgroundColor,
  Color? backBtnColor,
}) =>
    appbar(
      context,
      back: false,
      right: right,
      onBack: onBack,
      backgroundColor: backgroundColor,
      backBtnColor: backBtnColor,
      left: Text(
        title ?? S.of(context).tab1,
        style: TextStyle(
          fontSize: 22.sp,
          color: Color(0xFF1B72EC),
          fontWeight: FontWeight.w600,
        ),
      ).intoPadding(padding: EdgeInsets.only(left: 22.w)),
    );

AppBar appbar(
  BuildContext context, {
  dynamic data,
  bool back = true,
  Widget? left,
  Widget? center,
  Widget? right,
  Color? backgroundColor,
  Color? backBtnColor,
  Function()? onBack,
}) {
  return AppBar(
    shadowColor: Color(0xFF000000).withOpacity(0.3),
    // elevation: 4,
    titleSpacing: 0,
    backgroundColor: backgroundColor ?? Colors.white,
    toolbarHeight: 56.h,
    leading: null,
    automaticallyImplyLeading: false,
    title: Container(
      height: 56.h,
      // decoration: BoxDecoration(
      //   color: Color(0xFFFFFFFF),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Color(0xFF000000).withOpacity(0.15),
      //       offset: Offset(0, 1),
      //       blurRadius: 4,
      //       spreadRadius: 0,
      //     ),
      //   ],
      // ),

      child: Stack(
        children: [
          Visibility(
            visible: back,
            child: assetImage('ic_back',
                    width: 12.w, height: 21.h, color: backBtnColor)
                .intoContainer(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                )
                .intoGesture(
                  onTap: onBack ?? () => Navigator.pop(context, data),
                ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: left,
          ),
          Align(
            alignment: Alignment.center,
            child: center,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: right,
          )
        ],
      ),
      // padding: EdgeInsets.symmetric(horizontal: 22.w),
    ),
  );
}

Widget buildMsgRefreshHeader() => CustomHeader(
      // refreshStyle: RefreshStyle.Follow,
      builder: (context, mode) {
        if (mode == RefreshStatus.refreshing)
          return Container(
            height: 60.0,
            child: Container(
              height: 20.0,
              width: 20.0,
              child: CupertinoActivityIndicator(),
            ),
          );
        return Container();
      },
    );

Widget buildMsgLoadFooter() => CustomFooter(
      loadStyle: LoadStyle.ShowAlways,
      builder: (context, mode) {
        if (mode == LoadStatus.loading) {
          return Container(
            height: 60.0,
            child: Container(
              height: 20.0,
              width: 20.0,
              child: CupertinoActivityIndicator(),
            ),
          );
        }
        return Container();
      },
    );

Widget buildRedDot({required int count}) => Visibility(
      visible: count > 0,
      child: Container(
        width: 16.w,
        height: 16.w,
        alignment: Alignment.center,
        // constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w,maxWidth: 22.w),
        decoration: BoxDecoration(
          color: Color(0xFFF44038),
          shape: BoxShape.circle,
        ),
        child: Text(
          '${count > 99 ? '...' : count}',
          style: TextStyle(
            fontSize: 12.sp,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

Widget buildPop({
  required BuildContext context,
  CustomPopupMenuController? ctrl,
}) =>
    CopyCustomPopupMenu(
      controller: ctrl,
      barrierColor: Colors.transparent,
      arrowColor: Color(0xFF1B72EC),
      verticalMargin: 0,
      // horizontalMargin: 0,
      child: assetImage(
        'ic_add',
        width: 24.h,
        height: 24.h,
        color: Color(0xFF333333),
      ).intoPadding(
        padding: EdgeInsets.only(right: 10.w, left: 10.w),
      ),
      menuBuilder: () => _buildPopBgView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPopItemView(
              iconWidget: assetImage(
                'ic_add_friend',
                width: 18.w,
                height: 18.h,
              ),
              text: S.of(context).add_friend_text1,
              onTap: () {
                ctrl?.hideMenu();
                NavigatorManager.push(
                  context,
                  BlocProvider(
                    bloc: ContactBloc()..getUid(),
                    child: AddFriendPage(),
                  ),
                );
              },
            ),
            _buildPopItemView(
              iconWidget: assetImage(
                'ic_group_chat3',
                width: 18.w,
                height: 18.h,
              ),
              text: S.of(context).group_chat_text2,
              onTap: () {
                ctrl?.hideMenu();
                NavigatorManager.push(
                  context,
                  GroupMemberAddSelectPage(
                    title: S.of(context).group_chat_text2,
                  ),
                );
              },
            ),
            _buildPopItemView(
              iconWidget: assetImage(
                'ic_group_chat2',
                width: 18.w,
                height: 18.h,
              ),
              text: S.of(context).group_chat_text3,
              onTap: () {
                ctrl?.hideMenu();
                NavigatorManager.push(context, AddGroupPage());
              },
            ),
            _buildPopItemView(
              iconWidget: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 18.w,
              ),
              text: S.of(context).scan,
              onTap: () {
                ctrl?.hideMenu();
                Permissions.camera(() {
                  NavigatorManager.push(context, QrCodeScanPage()).then((u) {
                    if (u is UserInfo) {
                      NavigatorManager.push(
                        context,
                        BlocProvider(
                          bloc: ContactBloc()..checkFriend(u.uid),
                          child: SelectResultPage(info: u),
                        ),
                      );
                    }
                  });
                });
              },
            ),
          ],
        ),
      ),
      pressType: PressType.singleClick,
    );

Widget _buildPopBgView({Widget? child}) => Container(
      child: child,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Color(0xFF1B72EC),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.5),
            offset: Offset(0, 2.h),
            blurRadius: 6,
            spreadRadius: 0,
          )
        ],
      ),
    );

Widget _buildPopItemView(
        {required Widget iconWidget,
        required String text,
        Function()? onTap}) =>
    GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 35.h,
        // width: 140.w,
        // color: Colors.black,
        constraints: BoxConstraints(
          minWidth:
              (locale?.countryCode?.contains('en') ?? false) ? 170.w : 120.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            SizedBox(
              width: 14.w,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

Widget buildSearchView({
  TextEditingController? controller,
}) =>
    [
      assetImage(
        "ic_search",
        width: 18.h,
        height: 18.h,
        color: Color(0xFF333333),
      ),
      SizedBox(
        width: 8.w,
      ),
      TextField(
        controller: controller,
        style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
      ).intoExpanded(),
    ].intoRow().intoContainer(
          margin: EdgeInsets.only(left: 22.w, right: 22.w, top: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: Color(0xFFE8F2FF),
            borderRadius: BorderRadius.circular(4),
          ),
        );