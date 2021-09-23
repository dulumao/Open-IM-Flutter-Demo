import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/blocs/mine_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/pages/mine/black_list.dart';
import 'package:eechart/pages/mine/set_nickname.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:sprintf/sprintf.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  late MineBloc _bloc;

  @override
  void initState() {
    _bloc = MineBloc()..getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SingleChildScrollView(
          child: Container(
            height: (812 - 44).h,
            color: Color(0xFFE8F2FF),
            child: StreamBuilder(
              stream: _bloc.userInfoCtrl.stream,
              builder: (_, AsyncSnapshot<UserInfo> hot) => Column(
                children: [
                  _buildHeaderView(context: context, info: hot.data),
                  SizedBox(
                    height: 24.h,
                  ),
                  _buildItemView(
                    icon: 'ic_mine_ic1',
                    text: S.of(context).mine_text1,
                  ).intoGesture(onTap: () {

                  }),
                  _buildItemView(
                    icon: 'ic_mine_ic2',
                    text: S.of(context).mine_text2,
                  ).intoGesture(
                    onTap: () => NavigatorManager.push(
                            context,
                            BlocProvider(
                                bloc: MineBloc()
                                  ..initNicknameCtrl(hot.data?.name ?? ''),
                                child:
                                    SetNicknamePage(uid: hot.data?.uid ?? '')))
                        .then((value) {
                      if (value == true) {
                        _bloc.getUserInfo();
                      }
                    }),
                  ),
                  _buildItemView(
                    icon: 'ic_mine_ic3',
                    text: S.of(context).mine_text3,
                  ).intoGesture(
                    onTap: () => NavigatorManager.push(
                        context,
                        BlocProvider(
                            child: BlackListPage(),
                            bloc: ContactBloc()..getBlackList())),
                  ),
                  Spacer(),
                  _buildExitView(context),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          NavigatorManager.logout(context);
          return true;
        });
  }

  Widget _buildItemView({
    required String icon,
    required String text,
  }) =>
      Container(
        height: 62.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: BorderDirectional(
            bottom: BorderSide(color: Color(0xFFD8D8D8), width: 1),
          ),
        ),
        child: Row(
          children: [
            assetImage(
              icon,
              width: 25.h,
              height: 25.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      );

  Widget _buildHeaderView({required BuildContext context, UserInfo? info}) =>
      Container(
        color: Colors.white,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 30.h, left: 22.w),
        height: 151.h,
        child: Row(
          children: [
            ChatAvatarView(size: 58.w, url: info?.icon),
            SizedBox(width: 31.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info?.getShowName() ?? '',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  sprintf(S.of(context).mine_text5, [info?.uid ?? '']),
                  // overflow: TextOverflow.clip,
                  // softWrap: true,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF666666),
                  ),
                ).intoGesture(
                  onTap: () => longPressCopy(context, info?.uid ?? ''),
                )
              ],
            ).intoExpanded(),
            /* Container(
              padding: EdgeInsets.only(right: 22.w),
              child: Icon(Icons.qr_code),
            ).intoGesture(onTap: () {
              NavigatorManager.push(context, QrCodeScanPage());
            }),*/
          ],
        ),
      );

  Widget _buildExitView(BuildContext context) => Container(
    height: 56.h,
    color: Colors.white,
    margin: EdgeInsets.only(bottom: 89.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        assetImage(
          'ic_mine_ic4',
          width: 20.h,
          height: 20.h,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          S.of(context).mine_text4,
          style: TextStyle(
            fontSize: 18.sp,
            color: Color(0xFF1B72EC),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ).intoGesture(onTap: () => NavigatorManager.logout(context));
}
