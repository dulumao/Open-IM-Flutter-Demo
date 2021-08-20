import 'package:eechart/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:eechart/common/packages.dart';

class RegisterBloc extends BlocBase {
  final mnemonicStrCtrl = BehaviorSubject<String>();
  final mnemonicArrayCtrl = BehaviorSubject<List<String>>();

  void generateMnemonic() {
    print('---------------generateRandomMnemonic-----------');
    var _mnemonicStr = bip39.generateMnemonic();
    mnemonicStrCtrl.add(_mnemonicStr);
    mnemonicArrayCtrl.addSafely(_mnemonicStr.split(' '));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mnemonicStrCtrl.close();
    mnemonicArrayCtrl.close();
  }
}
