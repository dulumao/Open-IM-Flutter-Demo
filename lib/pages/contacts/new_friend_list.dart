import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class NewFriendListPage extends StatelessWidget {
  const NewFriendListPage({Key? key, this.bloc}) : super(key: key);
  final ContactBloc? bloc;

  @override
  Widget build(BuildContext context) {
    // ContactBloc? bloc = BlocProvider.of<ContactBloc>(context);
    return Scaffold(
      appBar: backAppbar(
        context,
        title: S.of(context).new_friend,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: bloc?.friendApplicationListCtrl.stream,
        builder: (_, AsyncSnapshot<List<UserInfo>> hot) => ListView.builder(
          shrinkWrap: true,
          itemCount: hot.data?.length ?? 0,
          itemBuilder: (_, index) {
            return _buildItemView(
              context: context,
              info: hot.data![index],
              bloc: bloc,
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemView({
    required BuildContext context,
    required UserInfo info,
    ContactBloc? bloc,
  }) =>
      Container(
        height: 70.h,
        padding: EdgeInsets.only(left: 22.w),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 45.h,
                height: 45.h,
                color: Colors.green,
              ),
            ),
            Container(
              height: 70.h,
              margin: EdgeInsets.only(left: 11.w),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(color: Color(0xFFE5EBFF), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    info.getShowName(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: _buildButtonGroup(
                      context: context,
                      info: info,
                      bloc: bloc,
                    ),
                  ),
                ],
              ),
            ).intoExpanded(),
          ],
        ),
      );

  List<Widget> _buildButtonGroup(
      {required BuildContext context,
      required UserInfo info,
      ContactBloc? bloc}) {
    List<Widget> list = List.empty(growable: true);
    if (info.flag == 0) {
      list.addAll([
        _buildButton(
          text: S.of(context).new_friend_text4,
          bgColor: Color(0xFF1B72EC),
          txtColor: Colors.white,
        ).intoGesture(
          onTap: () =>
              bloc?.acceptFriendApplication(context: context, uid: info.uid),
        ),
        _buildButton(
          text: S.of(context).new_friend_text5,
          bgColor: Colors.red[400],
          txtColor: Colors.white,
        ).intoGesture(
          onTap: () =>
              bloc?.refuseFriendApplication(context: context, uid: info.uid),
        ),
      ]);
    } else if (info.flag == 1) {
      list.add(Text(
        S.of(context).new_friend_text2,
        style: TextStyle(
          fontSize: 14.sp,
          color: Color(0xFF666666),
          fontWeight: FontWeight.w600,
        ),
      ).intoPadding(
        padding: EdgeInsets.only(right: 23.w),
      ));
    } else if (info.flag == -1) {
      list.add(Text(
        S.of(context).new_friend_text3,
        style: TextStyle(
          fontSize: 14.sp,
          color: Color(0xFF666666),
          fontWeight: FontWeight.w600,
        ),
      ).intoPadding(
        padding: EdgeInsets.only(right: 23.w),
      ));
    }
    return list;
  }

  Widget _buildButton({required String text, Color? bgColor, Color? txtColor}) {
    //Color(0xFF1B72EC)
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.only(right: 21.w),
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 6.h,
        bottom: 8.h,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: txtColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/*class NewFriendListPage extends StatefulWidget {
  const NewFriendListPage({Key? key}) : super(key: key);

  @override
  _NewFriendListPageState createState() => _NewFriendListPageState();
}

class _NewFriendListPageState extends State<NewFriendListPage> {
  @override
  Widget build(BuildContext context) {
    ContactBloc? bloc = BlocProvider.of<ContactBloc>(context);
    return Scaffold(
      appBar: backAppbar(
        context,
        title: S.of(context).new_friend,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: bloc?.friendApplicationListCtrl.stream,
        builder: (_, AsyncSnapshot<List<UserInfo>> hot) => ListView.builder(
          shrinkWrap: true,
          itemCount: hot.data?.length ?? 0,
          itemBuilder: (_, index) {
            return _buildItemView(
              context: context,
              info: hot.data![index],
              bloc: bloc,
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemView({
    required BuildContext context,
    required UserInfo info,
    ContactBloc? bloc,
  }) =>
      Container(
        height: 70.h,
        padding: EdgeInsets.only(left: 22.w),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 45.h,
                height: 45.h,
                color: Colors.green,
              ),
            ),
            Container(
              height: 70.h,
              margin: EdgeInsets.only(left: 11.w),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(color: Color(0xFFE5EBFF), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    info.nickname,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: _buildButtonGroup(info: info, bloc: bloc),
                  )
                  */ /*info.flag == 0
                      ? Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1B72EC),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.only(right: 21.w),
                          padding: EdgeInsets.only(
                            left: 12.w,
                            right: 12.w,
                            top: 6.h,
                            bottom: 8.h,
                          ),
                          child: Text(
                            S.of(context).new_friend_text1,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ).intoGesture(
                          onTap: () => bloc
                              ?.addFriend(uid: info.uid, reason: '')
                              .then((value) {
                            // info.flag =
                          }),
                        )
                      : Text(
                          S.of(context).new_friend_text2,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w600,
                          ),
                        ).intoPadding(
                          padding: EdgeInsets.only(right: 23.w),
                        ),*/ /*
                ],
              ),
            ).intoExpanded(),
          ],
        ),
      );

  List<Widget> _buildButtonGroup({required UserInfo info, ContactBloc? bloc}) {
    List<Widget> list = List.empty(growable: true);
    if (info.flag == 0) {
      list.addAll([
        _buildButton(
          text: S.of(context).new_friend_text4,
          bgColor: Color(0xFF1B72EC),
          txtColor: Colors.white,
        ).intoGesture(
          onTap: () => bloc?.acceptFriendApplication(uid: info.uid),
        ),
        _buildButton(
          text: S.of(context).new_friend_text5,
          bgColor: Colors.red[400],
          txtColor: Colors.white,
        ).intoGesture(
          onTap: () => bloc?.refuseFriendApplication(uid: info.uid),
        ),
      ]);
    } else if (info.flag == 1) {
      list.add(Text(
        S.of(context).new_friend_text2,
        style: TextStyle(
          fontSize: 14.sp,
          color: Color(0xFF666666),
          fontWeight: FontWeight.w600,
        ),
      ).intoPadding(
        padding: EdgeInsets.only(right: 23.w),
      ));
    } else if (info.flag == 2) {
      list.add(Text(
        S.of(context).new_friend_text3,
        style: TextStyle(
          fontSize: 14.sp,
          color: Color(0xFF666666),
          fontWeight: FontWeight.w600,
        ),
      ).intoPadding(
        padding: EdgeInsets.only(right: 23.w),
      ));
    }
    return list;
  }

  Widget _buildButton({required String text, Color? bgColor, Color? txtColor}) {
    //Color(0xFF1B72EC)
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.only(right: 21.w),
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 6.h,
        bottom: 8.h,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: txtColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}*/
