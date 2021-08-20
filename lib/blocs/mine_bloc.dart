import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/packages.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:rxdart/rxdart.dart';

class MineBloc extends BlocBase {
  BehaviorSubject<UserInfo> userInfoCtrl = BehaviorSubject();

  TextEditingController nicknameCtrl = TextEditingController();

  void getUserInfo() async {
    // String? uid = await OpenIM.iMManager.getLoginUid();
    // OpenIM.iMManager.getUsersInfo([uid ?? '']).then((list) {
    //   if (list.length > 0) {
    //     userInfoCtrl.addSafely(list[0]);
    //   }
    // });
    OpenIM.iMManager.getLoginUserInfo().then((value) {
      loginUserInfo = value;
      userInfoCtrl.addSafely(value);
    });
  }

  void initNicknameCtrl(String name) {
    nicknameCtrl.text = name;
  }

  Future<String?> setSelfInfo(String uid) {
    if (nicknameCtrl.text.isEmpty) return Future.error('nickname is empty');
    return OpenIM.iMManager
        .setSelfInfo(UserInfo(uid: uid, name: nicknameCtrl.text));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userInfoCtrl.close();
    nicknameCtrl.dispose();
  }
}
