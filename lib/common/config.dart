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

  /// api地址
  static const IP_API = 'https://open-im.rentsoft.cn';
  /// websocket地址
  static const IP_WS = 'wss://open-im.rentsoft.cn/wss';
  /// token置换接口地址
  static const IP_LOGIN = 'https://open-im.rentsoft.cn/eechat/user/login';
}
