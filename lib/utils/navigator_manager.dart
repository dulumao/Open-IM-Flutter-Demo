//pushReplacementNamed 指把当前页面在栈中的位置替换成跳转的页面（替换导航器的当前路由，通过推送路由[routeName]），当新的页面进入后，之前的页面将执行dispose方法。
//pushReplacement同pushReplacementNamed
//popAndPushNamed指将当前页面pop，然后跳转到制定页面（将当前路由弹出导航器，并将命名路由推到它的位置。）
//pushNamedAndRemoveUntil指将制定的页面加入到路由中，然后将其他所有的页面全部pop, (Route<dynamic> route) => false将确保删除推送路线之前的所有路线。
//pushNamedAndRemoveUntil指将制定的页面加入到路由中，然后将之前的路径移除直到指定的页面为止（将具有给定名称的路由推到导航器上，然后删除所有路径前面的路由直到'predicate'返回true为止。）
//popUntil

import 'package:eechart/blocs/im_bloc.dart';
import 'package:eechart/blocs/login_bloc.dart';
import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/config.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/main.dart';
import 'package:eechart/pages/login/login.dart';
import 'package:eechart/pages/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class NavigatorManager {
  //
  static Future<T?> push<T>(
    BuildContext context,
    Widget dest, {
    bool needLogin = false,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return (needLogin && !isLogin())
              ? _loginPage()
              : _wrapWillPopScopeView(dest);
        },
      ),
    );
  }

  static Future<T?> pushReplacement<T>(
    BuildContext context,
    Widget dest, {
    bool needLogin = false,
    String? route,
  }) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: RouteSettings(name: route),
        builder: (BuildContext context) {
          return (needLogin && !isLogin())
              ? _loginPage()
              : _wrapWillPopScopeView(dest);
        },
      ),
    );
  }

  static void startMain() {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        settings: RouteSettings(name: 'main'),
        builder: (BuildContext context) => _mainPage(),
      ),
      (route) => false,
    );
  }

  static void logout(BuildContext context) {
    OpenIM.iMManager.logout().then((value) {
      print('======logout=======$value');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            settings: RouteSettings(name: 'login'),
            builder: (BuildContext context) => _loginPage(),
          ),
          (route) => false);
    });
  }

  static void backMain(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.settings.name == 'main');
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     settings: RouteSettings(name: 'main'),
    //     builder: (BuildContext context) => _mainPage(),
    //   ),
    //   (route) => route.settings.name == 'main',
    // );
  }

  static Widget _loginPage() {
    return _wrapLoadView(BlocProvider(child: LoginPage(), bloc: LoginBloc()));
  }

  static Widget _mainPage() {
    return _wrapLoadView(MainPage());
  }

  static Widget _wrapLoadView(Widget widget) {
    return widget;
  }

  // Android 点击返回虚拟键时
  static Widget _wrapWillPopScopeView(Widget widget) {
    return WillPopScope(
      child: widget,
      onWillPop: () async {
        return true;
      },
    );
  }

  static Future<T?> showPageDialog<T>(BuildContext context, Widget widget) {
    return Navigator.of(context).push<T>(_dialogRoute(widget: widget));
  }

  static PageRoute<T> _dialogRoute<T>({required Widget widget}) {
    return PageRouteBuilder<T>(
      opaque: false,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, _, __) => widget,
    );
  }
}
