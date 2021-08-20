import 'package:eechart/blocs/login_bloc.dart';
import 'package:eechart/blocs/register_bloc.dart';
import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/pages/login/register.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/touch_close_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:eechart/common/packages.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginBloc? _bloc = BlocProvider.of<LoginBloc>(context);
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 394.h,
                padding: EdgeInsets.only(top: 41.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFFFFFFF),
                      const Color(0xFFC6F1F9),
                    ],
                  ),
                ),
              ).intoAlign(alignment: Alignment.bottomCenter),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeaderBg(),
                  Text(
                    S.of(context).login_text1,
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Text(
                    S.of(context).login_text7,
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      [
                        Container(
                          width: 5.w,
                          height: 5.w,
                          margin: EdgeInsets.only(right: 7.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(1),
                            color: const Color(0xFF666666),
                          ),
                        ),
                        Text(
                          S.of(context).login_text2,
                          style: TextStyle(
                            color: const Color(0xFF333330),
                            fontSize: 14.sp,
                          ),
                        )
                      ].intoRow(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min),
                      SizedBox(height: 3.h),
                      [
                        Container(
                          width: 5.w,
                          height: 5.w,
                          margin: EdgeInsets.only(right: 7.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF666666),
                          ),
                        ),
                        Text(
                          S.of(context).login_text3,
                          style: TextStyle(
                            color: const Color(0xFF333330),
                            fontSize: 14.sp,
                          ),
                        )
                      ].intoRow(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min),
                    ],
                  ),
                  SizedBox(height: 70.h),
                  [
                    // SizedBox(height: 41.h),
                    TextField(
                      controller: _bloc?.textCtrl,
                      style: TextStyle(
                        fontSize: 12.sp,
                        // color: const Color(0xFF999999),
                      ),
                      decoration: InputDecoration(
                        hintText: S.of(context).login_text4,
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF999999),
                          fontWeight: FontWeight.w600,
                        ),
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            top: 6.h, bottom: 6.h, left: 61.w, right: 61.w),
                      ),
                    ).intoExpanded()
                  ].intoRow(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  // SizedBox(height: 6.h,),
                  Container(
                    color: const Color(0xFFD8D8D8),
                    height: 1.h,
                    margin: EdgeInsets.only(left: 38.w, right: 38.w),
                  ),
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
                          left: 116.w,
                          right: 116.w,
                          top: 53.h,
                          bottom: 16.h,
                        ),
                        height: 44.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: const Color(0xFF004CCB),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xb3004ccb).withOpacity(0.7),
                              offset: Offset(0, 4.h),
                              blurRadius: 13,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      )
                      .intoGesture(onTap: () => _bloc?.login()),
                 /* Text(
                    S.of(context).login_text6,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF1D6BED),
                      fontWeight: FontWeight.w600,
                    ),
                  ).intoContainer(alignment: Alignment.center).intoGesture(
                      onTap: () => NavigatorManager.push(
                          context,
                          BlocProvider(
                            bloc: RegisterBloc()..generateMnemonic(),
                            child: RegisterPage(),
                          ))),*/
                ],
              ),
            ],
          ).intoContainer(height: 812.h),
        ),
      ),
    );
  }

  Widget _buildHeaderBg() => Stack(
        children: [
          assetImage(
            'ic_login_ic1',
            width: 96.w, /* height: 111.h*/
          ),
          assetImage('ic_login_ic2', width: 13.w, height: 13.w).intoPadding(
            padding: EdgeInsets.only(
              left: 110.w,
              top: 44.h,
            ),
          ),
          assetImage('ic_login_ic3', width: 27.w, height: 27.w)
              .intoPadding(
                padding: EdgeInsets.only(
                  right: 58.w,
                  top: 51.h,
                ),
              )
              .intoAlign(alignment: Alignment.centerRight),
          assetImage(
            'ic_login_ic4',
            width: 35.w, /* height: 70.w*/
          )
              .intoPadding(
                padding: EdgeInsets.only(top: 76.h),
              )
              .intoAlign(alignment: Alignment.centerRight),
          assetImage(
            'ic_login_ic5',
            width: 139.w, /* height: 140.w*/
          )
              .intoPadding(
                padding: EdgeInsets.only(top: 129.h),
              )
              .intoAlign(alignment: Alignment.center),
          assetImage(
            'ic_login_ic6',
            width: 29.w, /* height: 44.w*/
          ).intoPadding(
            padding: EdgeInsets.only(top: 234.h),
          ),
        ],
      );
}
