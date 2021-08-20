// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:bip39/bip39.dart' as bip39;

void main() {
  String randomMnemonic = bip39.generateMnemonic();
  print(randomMnemonic);
  print(randomMnemonic.split(' '));
  print(bip39.validateMnemonic(randomMnemonic));
  String seed = bip39.mnemonicToSeedHex(
      "update elbow source spin squeeze horror world become oak assist bomb nuclear");
  print(seed);
  String mnemonic = bip39.entropyToMnemonic('00000000000000000000000000000000');
  print(mnemonic);
  bool isValid = bip39.validateMnemonic(mnemonic);
  print(isValid);
  isValid = bip39.validateMnemonic('basket actual');
  print(isValid);
  String entropy = bip39.mnemonicToEntropy(mnemonic);
  print(entropy);
  var list = [User('a'), User('b'), User('c')];

  var list2 = List.generate(list.length, (index) => list[index]);
  list2.shuffle();
  print('$list');
  print('$list2');

  List? list4;
  print('-------1${list4?.length}');
  if(list4!.length==1){
    print('-------2${list4.length}');
  }

}

class User{
  final String name;

  User(this.name);
  @override
  String toString() {
    // TODO: implement toString
    return '$name';
  }
}
