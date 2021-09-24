import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/config.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/utils/sp_util.dart';
import 'package:eechart/widgets/loading_view.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:uuid/uuid.dart';

var dio = Dio();

class LoginBloc extends BlocBase {
  final textCtrl = TextEditingController();
  final uuid = Uuid();
  late String account;
  final idList = ["18349115126", "13918588195", "17396220460", "18666662412"];
  final gid = 'b6d1f6d16481547c26b744fa701c6f0f';
  var platform;

  LoginBloc() {
    account = SpUtil.getString("account");
    platform = Platform.isAndroid ? IMPlatform.android : IMPlatform.ios;
    textCtrl.text = account;
    if (textCtrl.text.isEmpty) {
      var content = new Utf8Encoder().convert(uuid.v4());
      var digest = md5.convert(content);
      var value = digest.toString();
      textCtrl.text = value.substring(value.length ~/ 2);
    }
  }

  void login() async {
    try {
      if (textCtrl.text.isEmpty) return;
      LoadingView.show(context);
      String uid = "";
      String token = "";
      var resp;
      bool isRegistered = false;

      try {
        resp = await dio.post<Map<String, dynamic>>(Config.IP_REGISTER, data: {
          'secret': Config.secret,
          'platform': platform,
          'uid': textCtrl.text,
          'name': 'Ox${textCtrl.text}',
        });
        print('----------------注册成功');
        isRegistered = true;
        await _importData();
      } catch (e) {
        //{"errCode":500,"errMsg":"rpc error: code = Unknown desc = Error 1062: Duplicate entry '333333' for key 'PRIMARY'"}
        var error = e as DioError;
        print('e--:${error.response}');
        print('e--:${error.response.runtimeType}');
        print('e--:${error.response?.data}');
        print('e--:${error.response?.data.runtimeType}');
        print('e--:${error.response?.data['errMsg']}');
        String? errMsg = error.response?.data['errMsg'];
        var key = "Duplicate entry '${textCtrl.text}' for key 'PRIMARY";
        if (null != errMsg && errMsg.contains(key)) {
          //
          isRegistered = true;
        }
      }


      print('isRegistered:$isRegistered');
      if (isRegistered) {
        resp = await dio.post<Map<String, dynamic>>(Config.IP_LOGIN, data: {
          'secret': Config.secret,
          'platform': platform,
          'uid': textCtrl.text,
        });
        Map? result = resp.data!['data'];
        print('login data:$result');
        uid = result!['uid'];
        token = result['token'];

        if (uid.isNotEmpty && token.isNotEmpty) {
          SpUtil.putString('account', textCtrl.text);
          OpenIM.iMManager
              .login(uid: uid, token: token)
              .then((value) => NavigatorManager.startMain())
              .catchError((e) => _showError(e))
              .whenComplete(() => LoadingView.dismiss());
        }
      }
    } catch (e) {
      print('e:$e');
      // var error = e as DioError;
      // print('e--:${error.response}');
      // print('e--:${error.response.runtimeType}');
      // print('e--:${error.response?.data}');
      // print('e--:${error.response?.data.runtimeType}');
      // print('e--:${error.response?.data['errMsg']}');
      _showError(e);
    }
  }

  static Future _showError(dynamic e) {
    Fluttertoast.showToast(
      msg: 'login error:【 $e 】',
      toastLength: Toast.LENGTH_LONG,
    );
    return Future.error('');
  }

  _importData() async {
    ///////////////////////////////////忽略以下逻辑/////////////////////////////////
    var resp;
    var uid;
    var token;
    // 管理员登录
    resp = await dio.post<Map<String, dynamic>>(Config.IP_LOGIN, data: {
      'secret': Config.secret,
      'platform': platform,
      'uid': 'openIM123456',
    });
    Map? result = resp.data!['data'];
    uid = result!['uid'];
    token = result['token'];
    print('----------------管理员登录  $token');
    // 为用户导入好友
    try {
      resp = await dio.post(
        'http://1.14.194.38:10000/friend/import_friend',
        data: {
          "uidList": idList,
          "ownerUid": textCtrl.text,
          "operationID": "1111111111111",
        },
        options: Options(
          headers: {'token': token},
        ),
      );
    } catch (e) {
      print('e:$e');
    }
    print('----------------导入好友成功');
    // 把用户拉进组
    resp = await dio.post(
      'http://1.14.194.38:10000/group/invite_user_to_group',
      data: {
        "groupID": gid,
        "uidList": [textCtrl.text],
        "reason": "default op",
        "operationID": "1111111111111 "
      },
      options: Options(
        headers: {
          'token': token,
        },
      ),
    );
    print('----------------进组成功');
    ////////////////////////////////////////////////////////////////////////////
  }

  @override
  void dispose() {
    textCtrl.dispose();
  }
}
