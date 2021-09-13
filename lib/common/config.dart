import 'dart:io';

import 'package:eechart/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Config {
  // static late final String cachePath;

  //初始化全局信息
  static Future init(VoidCallback runApp) async {
    WidgetsFlutterBinding.ensureInitialized();

    // cachePath = (await getTemporaryDirectory()).path;
    await SpUtil.init();

    runApp();
    // runApp();
    // 设置屏幕方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );
    }
  }

  /// 秘钥
  static const secret = 'tuoyun';

  static const HOST = '//1.14.194.38';

  /// 登录地址
  static const IP_LOGIN = 'http:$HOST:10000/auth/user_token';

  /// 注册地址
  static const IP_REGISTER = 'http:$HOST:10000/auth/user_register';

  /// sdk配置的api地址
  static const IP_API = 'http:$HOST:10000';

  /// sdk配置的web socket地址
  static const IP_WS = 'ws:$HOST:17778';
}
