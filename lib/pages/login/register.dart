import 'package:eechart/blocs/backup_bloc.dart';
import 'package:eechart/blocs/register_bloc.dart';
import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/pages/login/backup.dart';
import 'package:eechart/utils/navigator_manager.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  Widget _buildDescView({
    required BuildContext context,
    required String desc,
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5.h,
            height: 5.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1D6BED),
            ),
            margin: EdgeInsets.only(right: 7.w, top: 6.h),
          ),
          Text(
            desc,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14.sp,
            ),
          ).intoExpanded(),
        ],
      );

  Widget _buildItemView({required String value}) => Container(
        alignment: Alignment.center,
        height: 30.h,
        width: 130.w,
        child: Text(
          value,
          style: TextStyle(
            color: Color(0xFf333333),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF0045B9).withOpacity(0.46),
              offset: Offset(0, 2.h),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    RegisterBloc? _bloc = BlocProvider.of<RegisterBloc>(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Stack(
        children: [
          assetImage('ic_register_ic1', height: 114.h).intoAlign(
            alignment: Alignment.topRight,
          ),
          assetImage('ic_register_ic3', height: 171.h).intoAlign(
            alignment: Alignment.bottomLeft,
          ),
          [
            assetImage(
              'ic_register_ic2',
              width: 18.w,
              height: 32.h,
            ).intoGesture(onTap: () => Navigator.pop(context)),
            SizedBox(width: 10.w),
            Text(
              S.of(context).register_text1,
              style: TextStyle(
                color: Color(0xFF1D6BED),
                fontSize: 28.sp,
                fontWeight: FontWeight.w600,
              ),
            )
          ]
              .intoRow()
              .intoPadding(padding: EdgeInsets.only(left: 24.w, top: 72.h)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDescView(
                  context: context, desc: S.of(context).register_text2),
              SizedBox(height: 6.h),
              _buildDescView(
                  context: context, desc: S.of(context).register_text3),
              SizedBox(height: 6.h),
              _buildDescView(
                  context: context, desc: S.of(context).register_text4),
              StreamBuilder(
                stream: _bloc?.mnemonicArrayCtrl.stream,
                builder: (_, AsyncSnapshot<List<String>> snapshot) =>
                    GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 130 / 30,
                    crossAxisSpacing: 45.w,
                    mainAxisSpacing: 14.h,
                  ),
                  padding: EdgeInsets.only(
                    left: 8.w,
                    right: 8.w,
                    top: 19.h,
                    bottom: 32.h,
                  ),
                  itemCount: snapshot.data?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildItemView(value: snapshot.data![index]);
                  },
                ),
              ),
              StreamBuilder(
                stream: _bloc?.mnemonicStrCtrl.stream,
                builder: (_, AsyncSnapshot<String> sp) => [
                  Text(
                    S.of(context).register_text5,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    sp.data ?? '',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.sp,
                    ),
                  ),
                ]
                    .intoColumn(crossAxisAlignment: CrossAxisAlignment.start)
                    .intoContainer(
                      padding: EdgeInsets.only(
                        left: 8.w,
                        right: 8.w,
                        top: 10.h,
                        bottom: 10.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Color(0xFFED1D1D),
                          width: 1,
                        ),
                      ),
                    )
                    .intoGesture(
                      onTap: () => longPressCopy(context, sp.data ?? ''),
                    ),
              ),
              StreamBuilder(
                  stream: _bloc?.mnemonicArrayCtrl.stream,
                  builder: (_, AsyncSnapshot<List<String>> snapshot) => Text(
                        S.of(context).register_text6,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                          .intoContainer(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                left: 91.w, right: 72.w, top: 66.h),
                            height: 44.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: const Color(0xFF004CCB),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xb3004ccb).withOpacity(0.6),
                                  offset: Offset(0, 4.h),
                                  blurRadius: 13,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                          )
                          .intoGesture(
                              onTap: () => NavigatorManager.push(
                                  context,
                                  BlocProvider(
                                      bloc: BackupBloc(snapshot.data ?? []),
                                      child: BackupPage())))),
            ],
          ).intoPadding(
            padding: EdgeInsets.only(
              top: 120.h,
              left: 24.w,
              right: 24.w,
            ),
          ),
        ],
      ),
    );
  }
}
