import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/models/contact_info.dart';
import 'package:eechart/widgets/touch_close_keyboard.dart';

class RemarkSetPage extends StatelessWidget {
  final String uid;

  const RemarkSetPage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactBloc? bloc = BlocProvider.of<ContactBloc>(context);
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: backAppbar(context, title: S.of(context).remark_set_text1),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              child: Row(
                children: [
                  TextField(
                    controller: bloc?.remarkEditCtrl,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 2.w,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(
                        0xFF333333,
                      ),
                    ),
                  ).intoExpanded(),
                  Container(
                    // width: 46.w,
                    // height: 28.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF1B72EC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      S.of(context).remark_set_text2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ).intoGesture(
                      onTap: () => bloc
                          ?.setFriendInfo(uid: uid)
                          .then((value) => Navigator.pop(context)))
                ],
              ),
              margin: EdgeInsets.only(left: 22.w, right: 22.w, top: 42.h),
              padding: EdgeInsets.only(bottom: 6.h),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                    color: Color(0xFF999999),
                    width: 1,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
