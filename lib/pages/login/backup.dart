import 'package:dotted_border/dotted_border.dart';
import 'package:eechart/blocs/backup_bloc.dart';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BackupBloc? _bloc = BlocProvider.of<BackupBloc>(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            assetImage('ic_backup_ic1', height: 125.h).intoAlign(
              alignment: Alignment.topRight,
            ),
            [
              assetImage('ic_register_ic2', /*width: 18.w, */ height: 25.h)
                  .intoGesture(
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(width: 8.w),
              Text(
                S.of(context).backup_text1,
                style: TextStyle(
                  color: Color(0xFF1D6BED),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
            ]
                .intoRow()
                .intoPadding(padding: EdgeInsets.only(left: 24.w, top: 62.h)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                [
                  Text(
                    S.of(context).backup_text2,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16.sp,
                    ),
                  ).intoPadding(
                    padding: EdgeInsets.only(left: 24.w /*, top: 12.h*/),
                  ).intoExpanded(),
                ].intoRow(mainAxisAlignment: MainAxisAlignment.start),
                Container(
                  // height: 269.h,
                  width: 327.w,
                  margin: EdgeInsets.only(
                      /*left: 24.w, right: 24.w, */
                      top: 23.h),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0XFF0054DF).withOpacity(0.3),
                        offset: Offset(0, 2.h),
                        blurRadius: 13,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: StreamBuilder(
                      stream: _bloc?.sourceCtrl,
                      builder: (_, AsyncSnapshot<List<String>> snapshot) =>
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 122 / 28,
                              crossAxisSpacing: 49.w,
                              mainAxisSpacing: 13.h,
                            ),
                            padding: EdgeInsets.only(
                              left: 18.w,
                              right: 18.w,
                              top: 16.h,
                              bottom: 20.h,
                            ),
                            itemCount: 12,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(
                                    '${index + 1}.',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xFF333333)),
                                  ).intoContainer(width: 22.w),
                                  DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(4),
                                    // padding: EdgeInsets.all(6),
                                    color: Color(0xFF999999),
                                    child: Text(
                                      snapshot.data?[index] ?? '',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xFF333333)),
                                    ).intoContainer(
                                      height: 28.h,
                                      alignment: Alignment.center,
                                    ),
                                  )
                                      .intoGesture(
                                          onTap: () => _bloc?.clearValue(index))
                                      .intoExpanded()
                                ],
                              ) /*.intoContainer(height: 28.h)*/;
                            },
                          )),
                ),
                StreamBuilder(
                    stream: _bloc?.shuffleCtrl,
                    builder: (_, AsyncSnapshot<List<ShuffleItem>> snapshot) =>
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 84 / 29,
                            crossAxisSpacing: 31.w,
                            mainAxisSpacing: 9.h,
                          ),
                          padding: EdgeInsets.only(
                            left: 31.w,
                            right: 31.w,
                            top: 43.h,
                            bottom: 24.h,
                          ),
                          itemCount: snapshot.data?.length ?? 0,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              height: 29.h,
                              width: 84.w,
                              child: Text(
                                '${snapshot.data?[index].value}',
                                style: TextStyle(
                                  color: Color(0xFf333333),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color:
                                    !(snapshot.data?[index].isSelected ?? false)
                                        ? Color(0xFFFFFFFF)
                                        : Color(0xFFDFE4FF),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF004AC6).withOpacity(0.46),
                                    offset: Offset(0, 1.h),
                                    blurRadius: 7,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                            ).intoGesture(onTap: () {
                              if (!(snapshot.data?[index].isSelected ??
                                  false)) {
                                _bloc?.setValue(snapshot.data?[index]);
                              }
                            });
                          },
                        )),
                Stack(
                  children: [
                    assetImage('ic_backup_ic2', width: 345.w),
                    Text(
                      S.of(context).login_text5,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        .intoContainer(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            left: 115.w,
                            right: 115.w,
                            top: 21.h,
                          ),
                          height: 46.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: const Color(0xFF1D6BED),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1D6BED).withOpacity(0.6),
                                offset: Offset(0, 4),
                                blurRadius: 13,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        )
                        .intoGesture(onTap: () => _bloc?.login()),
                  ],
                ),
              ],
            ).intoPadding(
              padding: EdgeInsets.only(
                top: 95.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
