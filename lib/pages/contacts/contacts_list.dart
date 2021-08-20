
import 'package:azlistview/azlistview.dart';
import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/models/contact_info.dart';
import 'package:eechart/pages/chat/chat.dart';
import 'package:eechart/pages/contacts/new_friend_list.dart';
import 'package:eechart/pages/contacts/search_contact.dart';
import 'package:eechart/pages/group/group_list.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/base_state.dart';
import 'package:eechart/widgets/chat_avatar_view.dart';
import 'package:eechart/widgets/copy_custom_pop_up_menu.dart';

import '../group/group_notification.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({Key? key}) : super(key: key);

  @override
  _ContactsListPagePageState createState() => _ContactsListPagePageState();
}

class _ContactsListPagePageState extends BaseState<ContactsListPage> {
  final _popupCtrl = CustomPopupMenuController();
  late ContactBloc _contactBloc;

  @override
  void initData() async {
    topList
      ..clear()
      ..addAll([
        ContactInfo(
          uid: '123',
          name: S.of(context).new_friend,
          tagIndex: '↑',
          iconAssetPath: 'ic_new_friend',
        ),
        ContactInfo(
          uid: '124',
          name: S.of(context).group_chat_text1,
          tagIndex: '↑',
          iconAssetPath: 'ic_new_group',
        ),
        ContactInfo(
          uid: '125',
          name: S.of(context).group_chat_text36,
          tagIndex: '↑',
          iconAssetPath: 'ic_group_list',
        ),
      ]);
    _contactBloc = ContactBloc()
      ..context = context
      ..getContactList()
      ..getFriendApplicationList()
      ..getGroupApplicationList();

    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: eechartAppbar(
        context,
        title: S.of(context).tab2,
        right: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            assetImage('ic_search',
                    width: 24.h, height: 24.h, color: Color(0xFF333333))
                .intoPadding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                )
                .intoGesture(
                  onTap: () => NavigatorManager.push(
                    context,
                    SearchContactPage(contactBloc: _contactBloc),
                  ),
                ),
            buildPop(context: context, ctrl: _popupCtrl),
            SizedBox(width: 12.w),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _contactBloc.contactListCtrl.stream,
        builder: (_, AsyncSnapshot<List<ContactInfo>> snapshot) {
          List<ContactInfo> contactList = snapshot.data ?? [];
          return AzListView(
            data: contactList,
            itemCount: contactList.length,
            itemBuilder: (BuildContext context, int index) {
              ContactInfo model = contactList[index];
              bool isTop = model.tagIndex == '↑';
              if (isTop) {
                return getTopItemView(context, model, index);
              }
              return getContactItemView(context, model);
            },
            // physics: BouncingScrollPhysics(),
            susItemBuilder: (BuildContext context, int index) {
              ContactInfo model = contactList[index];
              if ('↑' == model.getSuspensionTag()) {
                return Container();
              }
              return getSusTitleView(context, model.getSuspensionTag());
            },
            indexBarData: SuspensionUtil.getTagIndexList(contactList),
            // indexBarData: ['↑', '☆', ...kIndexBarData],
            indexBarOptions: IndexBarOptions(
              textStyle: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF1B72EC),
                fontWeight: FontWeight.w600,
              ),
              needRebuild: true,
              ignoreDragCancel: true,
              downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
              downItemDecoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
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
          );
        },
      ),
    );
  }

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  Widget getSusTitleView(BuildContext context, String tag) {
    return Container(
      height: 23.h,
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
    ).intoContainer(color: Colors.white);
  }

  Widget getTopItemView(BuildContext context, ContactInfo model, int index) {
    return Container(
      padding: EdgeInsets.only(
          left: 22.w,
          right: 12.w,
          top: index == 0 ? 11.h : 14.h,
          bottom: index == 0 ? 0 : 16.h),
      color: Colors.white,
      // height: 60.h,
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 44.w,
              height: 44.w,
              child: assetImage(model.iconAssetPath ?? ''),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Text(
            model.comment ?? model.name ?? model.uid,
            style: TextStyle(
              fontSize: 18.sp,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          if (model.name == S.of(context).new_friend)
            StreamBuilder(
              builder: (_, AsyncSnapshot<int> hot) {
                return buildRedDot(count: hot.data ?? 0);
              },
              stream: _contactBloc.friendApplicationNumCtrl.stream,
            ),
          if (model.name == S.of(context).group_chat_text1)
            StreamBuilder(
              builder: (_, AsyncSnapshot<int> hot) {
                return buildRedDot(count: hot.data ?? 0);
              },
              stream: _contactBloc.groupApplicationNumCtrl.stream,
            ),
        ],
      ),
    ).intoGesture(onTap: () {
      if (model.name == S.of(context).new_friend) {
        NavigatorManager.push(
          context,
          NewFriendListPage(bloc: _contactBloc..getFriendApplicationList()),
        );
      } else if (model.name == S.of(context).group_chat_text1) {
        NavigatorManager.push(
          context,
          GroupNotificationPage(),
        );
      } else if (model.name == S.of(context).group_chat_text36) {
        NavigatorManager.push(
          context,
          GroupListPage(),
        );
      }
    });
  }

  Widget getContactItemView(BuildContext context, ContactInfo model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 22.w,
            right: 12.w,
          ),
          color: Colors.white,
          height: 64.h,
          child: Row(
            children: [
              ChatAvatarView(size: 44.w, url: model.icon),
              SizedBox(width: 14.w),
              Text(
                model.comment ?? model.name ?? model.uid,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Color(0xFFE0E8FF),
          margin: EdgeInsets.only(left: 80.w),
          height: 1,
        )
      ],
    ).intoGesture(onTap: () {
      NavigatorManager.push(
        context,
        ChatPage(
          uid: model.uid,
          title: model.nickname,
        ),
      );
    });
  }
}
