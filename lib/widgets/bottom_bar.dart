import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/bottom_bar_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';

class BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int>? onTap;

  BottomBar({Key? key, required this.index, this.onTap}) : super(key: key);

  final _iconSel = ['ic_tab1_sel', 'ic_tab2_sel', 'ic_tab3_sel'];
  final _iconNor = ['ic_tab1_nor', 'ic_tab2_nor', 'ic_tab3_nor'];

  bool _isSelected(i) => index == i;

  Widget _buildTabItem(BuildContext context, int i, int count) => Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              assetImage(
                _isSelected(i) ? _iconSel[i] : _iconNor[i],
                width: 24.w,
                height: 25.h,
              ),
              SizedBox(height: 2.h),
              Text(
                i == 0
                    ? S.of(context).tab1
                    : (i == 1 ? S.of(context).tab2 : S.of(context).tab3),
                style: TextStyle(fontSize: 10.sp, color: Color(0xFF1B72EC)),
              )
            ],
          ).intoAlign(alignment: Alignment.center),
          buildRedDot(count: count)
              .intoContainer(margin: EdgeInsets.only(right: 40.w))
              .intoAlign(
                alignment: Alignment.topRight,
              ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    BottomBarBloc? bloc = BlocProvider.of<BottomBarBloc>(context);
    return Container(
      height: 60.h,
      // padding: EdgeInsets.only(top: 6.h, bottom: 3.h),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.12),
            offset: Offset(0, -1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          StreamBuilder(
            stream: bloc?.unreadMsgCountCtrl.stream,
            builder: (_, AsyncSnapshot<int> hot) {
              return _buildTabItem(context, 0, hot.data ?? 0);
            },
          ).intoGesture(onTap: () => onTap!(0)).intoExpanded(),
          StreamBuilder(
            stream: bloc?.groupApplicationNumCtrl.stream,
            builder: (_, AsyncSnapshot<int> groupApplicationNumHot) {
              int groupCount = groupApplicationNumHot.data ?? 0;
              return StreamBuilder(
                stream: bloc?.friendApplicationCountCtrl.stream,
                builder: (_, AsyncSnapshot<int> friendApplicationNumHot) {
                  int friendCount = friendApplicationNumHot.data ?? 0;
                  return _buildTabItem(context, 1, groupCount + friendCount);
                },
              );
            },
          ).intoGesture(onTap: () => onTap!(1)).intoExpanded(),
          _buildTabItem(context, 2, 0)
              .intoGesture(onTap: () => onTap!(2))
              .intoExpanded(),
        ],
      ),
    );
  }
}
