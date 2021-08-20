import 'package:eechart/common/packages.dart';

class DialogView extends StatelessWidget {
  const DialogView({
    Key? key,
    required this.title,
    required this.leftText,
    required this.rightText,
  }) : super(key: key);
  final String title;
  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.transparent,
      color: Color(0xFF333333).withOpacity(0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 58.w, right: 58.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xFF333333),
                  ),
                ).intoPadding(
                  padding: EdgeInsets.only(
                    left: 29.w,
                    right: 29.w,
                    top: 18,
                    bottom: 17,
                  ),
                ),
                Container(
                  color: Color(0xFF9979797).withOpacity(0.5),
                  height: 0.5.h,
                ),
                Row(
                  children: [
                    Text(
                      leftText,
                      style:
                          TextStyle(fontSize: 16.sp, color: Color(0xFF333333)),
                    )
                        .intoContainer(
                          alignment: Alignment.center,
                          height: 48.h,
                        )
                        .intoGesture(
                          onTap: () => Navigator.pop(context, false),
                        )
                        .intoExpanded(),
                    Container(
                        color: Color(0xFF9979797).withOpacity(0.5),
                        width: 0.5.h,
                        height: 50.h),
                    Text(
                      rightText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xFF1B72EC),
                      ),
                    )
                        .intoContainer(
                          alignment: Alignment.center,
                          color: Color(0xFFE8F2FF),
                          height: 50.h,
                        )
                        .intoGesture(
                          onTap: () => Navigator.pop(context, true),
                        )
                        .intoExpanded(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool?> showCommonDialog(
  BuildContext context, {
  required String title,
  required String leftText,
  required String rightText,
  Function()? onConfirm,
}) =>
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (BuildContext context) => DialogView(
        title: title,
        leftText: leftText,
        rightText: rightText,
      ),
    );
