import 'package:eechart/blocs/contact_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';

class SearchContactPage extends StatefulWidget {
  final ContactBloc contactBloc;

  SearchContactPage({Key? key, required this.contactBloc}) : super(key: key);

  @override
  _SearchContactPageState createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar(context, title: S.of(context).search_contact),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 22.w, right: 22.w, top: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Color(0xFFE8F2FF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                assetImage("ic_search", width: 18.h, height: 18.h),
                SizedBox(
                  width: 8.w,
                ),
                TextField(
                  controller: _controller,
                  style: TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ).intoExpanded(),
              ],
            ),
          ),
          // _buildItemView(context: context),
          // _buildItemView(context: context),
        ],
      ),
    );
  }

  Widget _buildItemView({required BuildContext context}) => Container(
        height: 70.h,
        padding: EdgeInsets.only(left: 22.w),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 42.h,
                height: 42.h,
                color: Colors.green,
              ),
            ),
            Container(
              height: 70.h,
              margin: EdgeInsets.only(left: 14.w),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(color: Color(0xFFE5EBFF), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '奥尼克公司',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ).intoExpanded(),
          ],
        ),
      );
}
