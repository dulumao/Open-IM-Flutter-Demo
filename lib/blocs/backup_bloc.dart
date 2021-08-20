import 'package:eechart/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:collection/collection.dart';
import 'package:eechart/common/packages.dart';

class BackupBloc extends BlocBase {
  final List<String> _mnemonicList;
  final sourceCtrl = BehaviorSubject<List<String>>();
  final shuffleCtrl = BehaviorSubject<List<ShuffleItem>>();
  late List<ShuffleItem> _shuffleList;
  final List<String> _source = ["", "", "", "", "", "", "", "", "", "", "", ""];

  BackupBloc(this._mnemonicList) {
    _shuffleMnemonic();
  }

  void validateMnemonic(List<String> mnemonicList) {
    // var buffer = StringBuffer();
    // for (var i = 0; i < mnemonicList.length; i++) {
    //   buffer.write(mnemonicList[i]);
    //   if (i != mnemonicList.length - 1) {
    //     buffer.write(' ');
    //   }
    // }
    // var validate = bip39.validateMnemonic(buffer.toString());
  }

  void _shuffleMnemonic() {
    _shuffleList = List.generate(
      _mnemonicList.length,
      (index) => ShuffleItem(_mnemonicList[index], false),
    )..shuffle();
    shuffleCtrl.addSafely(_shuffleList);
  }

  void setValue(ShuffleItem? value) {
    if (null == value) return;
    var j = 0;
    for (int i = 0; i < _source.length; i++) {
      if (_source[i].isEmpty) {
        j = i;
        break;
      }
    }
    value.isSelected = true;
    _source[j] = value.value;
    sourceCtrl.addSafely(_source);
    shuffleCtrl.addSafely(_shuffleList);
  }

  void clearValue(int index) {
    var temp = _source[index];
    _source[index] = "";
    for (var item in _shuffleList) {
      if (item.value == temp) {
        item.isSelected = false;
        break;
      }
    }
    sourceCtrl.addSafely(_source);
    shuffleCtrl.addSafely(_shuffleList);
  }

  void login() {}

  @override
  void dispose() {
    // TODO: implement dispose
    sourceCtrl.close();
    shuffleCtrl.close();
  }
}

class ShuffleItem {
  String value;

  ShuffleItem(this.value, this.isSelected);

  bool isSelected = false;
}
