import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';


class BlackListPage extends StatelessWidget {
  const BlackListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactBloc? bloc = BlocProvider.of<ContactBloc>(context);
    return Scaffold(
      appBar: backAppbar(
        context,
        title: S.of(context).black_list1,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: bloc?.blackListCtrl,
        builder: (_, AsyncSnapshot<List<UserInfo>> hot) => ListView.builder(
            itemCount: hot.data?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (_, index) => _buildItemView(
                  context: context,
                  info: hot.data![index],
                  bloc: bloc,
                )),
      ),
    );
  }

  Widget _buildItemView(
          {required BuildContext context,
          required UserInfo info,
          ContactBloc? bloc}) =>
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
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1B72EC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    margin: EdgeInsets.only(right: 21.w),
                    padding: EdgeInsets.only(
                      left: 9.w,
                      right: 9.w,
                      top: 3.h,
                      bottom: 5.h,
                    ),
                    child: Text(
                      S.of(context).black_list2,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ).intoGesture(
                      onTap: () => bloc?.deleteFromBlackList(info: info))
                ],
              ),
            ).intoExpanded(),
          ],
        ),
      );
}
