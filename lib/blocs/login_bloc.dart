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

  LoginBloc() {
    account = SpUtil.getString("account");
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
      var plat = Platform.isAndroid ? IMPlatform.android : IMPlatform.ios;
      try {
        resp = await dio.post<Map<String, dynamic>>(Config.IP_REGISTER, data: {
          'secret': Config.secret,
          'platform': plat,
          'uid': textCtrl.text,
          'name': 'Ox${textCtrl.text}',
        });
        //////////////
       /* resp = await dio.post<Map<String, dynamic>>(Config.IP_LOGIN, data: {
          'secret': Config.secret,
          'platform': plat,
          'uid': 'openIM123456',
        });
        Map? result = resp.data!['data'];
        uid = result!['uid'];
        token = result['token'];
        // 导入
        resp = await dio.post<Map<String, dynamic>>(
            'http://1.14.194.38:10000/friend/import_friend',
            data: {
              "uid": "21979710c3fe454d",
              "operationID": "1111111222",
              "ownerUid": "f732156059eeb5d0"
            },
            options: Options(headers: {
              'token': token,
            }));
        // 进组
        resp = await dio.post<Map<String, dynamic>>(
            'http://1.14.194.38:10000/group/invite_user_to_group',
            data: {
              "groupID": "f21f9f84c14f3a978352ff339f1a800a",
              "uidList": ["openIM123456", ""],
              "reason": "reason",
              "operationID": "1111111111111 "
            },
            options: Options(headers: {
              'token': token,
            }));*/
        ///////////////////////
        isRegistered = true;
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
        // Map? data = resp.data!['data'];
        // print('register data:$data');
        resp = await dio.post<Map<String, dynamic>>(Config.IP_LOGIN, data: {
          'secret': Config.secret,
          'platform': Platform.isAndroid ? IMPlatform.android : IMPlatform.ios,
          'uid': textCtrl.text,
        });
        Map? result = resp.data!['data'];
        print('login data:$result');
        uid = result!['uid'];
        token = result['token'];
      }

      if (uid.isNotEmpty && token.isNotEmpty) {
        SpUtil.putString('account', textCtrl.text);
        SpUtil.putString(textCtrl.text, uid);
        OpenIM.iMManager
            .login(uid: uid, token: token)
            .then((value) => SpUtil.putString("account", textCtrl.text))
            .then((value) => NavigatorManager.startMain())
            .catchError((e) => _showError(e))
        // .catchError((e) => OpenIM.iMManager.logout())
            .whenComplete(() => LoadingView.dismiss());
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

  @override
  void dispose() {
    textCtrl.dispose();
  }
}
