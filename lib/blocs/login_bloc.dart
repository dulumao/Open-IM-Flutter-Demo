import 'dart:io';

import 'package:chinese_idioms/chinese_idioms.dart';
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

  LoginBloc() {
    textCtrl.text = SpUtil.getString("account");
    if (textCtrl.text.isEmpty) {
      // var _mnemonicStr = bip39.generateMnemonic();
      // textCtrl.text = _mnemonicStr;
      textCtrl.text = generateIdioms().first;
    }
  }

  void login() async {
    try {
      if (textCtrl.text.isEmpty) return;
      LoadingView.show(context);
      /*  OpenImToken? imToken = SpUtil.getObj(
        textCtrl.text,
            (v) => OpenImToken.fromJson(v.cast()),
      );*/

      String uid = /*imToken?.uid ?? ''*/ '';
      String token = /*imToken?.token ?? ''*/ '';
      if (uid.isEmpty && token.isEmpty) {
        var resp =
            await dio.post<Map<String, dynamic>>(Config.IP_REGISTER, data: {
          'secret': Config.secret,
          'platform': Platform.isAndroid ? IMPlatform.android : IMPlatform.ios,
          'uid': uuid.v4(),
          'name': textCtrl.text,
        });
        Map? data = resp.data!['data'];
        print('register data:$data');
        resp = await dio.post<Map<String, dynamic>>(Config.IP_LOGIN, data: {
          'secret': Config.secret,
          'platform': Platform.isAndroid ? IMPlatform.android : IMPlatform.ios,
          'uid': data!['uid'],
        });
        Map? result = resp.data!['data'];
        print('login data:$result');
        uid = result!['uid'];
        token = result['token'];

        /*var resp = await dio.post<Map<String, dynamic>>(
          Config.IP_LOGIN,
          //'http://47.112.160.66:20000/user/login',
          data: {
            'account': textCtrl.text,
            'password': '123456',
            'operationID': '1',
            'platform': 1,
          },
        );
        print('===============resp:$resp');
        var user = LoginResult.fromJson(resp.data ?? {}).data;
        uid = user?.openImToken?.uid ?? '';
        token = user?.openImToken?.token ?? '';*/
      }
      if (uid.isNotEmpty && token.isNotEmpty)
        OpenIM.iMManager
            .login(uid: uid, token: token)
            .then((value) => SpUtil.putString("account", textCtrl.text))
            .then((value) => NavigatorManager.startMain())
            .catchError((e) => _showError(e))
        // .catchError((e) => OpenIM.iMManager.logout())
            .whenComplete(() => LoadingView.dismiss());
    } catch (e) {
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
