import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/common/packages.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:rxdart/rxdart.dart';

class QrReaderBloc extends BlocBase {
  // BehaviorSubject<List<UserInfo>> searchUserListCtrl = BehaviorSubject();

  Future<UserInfo?> getUsersInfo(String uid) {
    return OpenIM.iMManager.getUsersInfo([uid]).then((list) {
      if (list.isEmpty) {
        Fluttertoast.showToast(msg: 'The user not exist');
        return null;
      } else {
        return list[0];
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // searchUserListCtrl.close();
  }
}
