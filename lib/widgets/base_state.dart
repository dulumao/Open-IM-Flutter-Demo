import 'package:flutter/material.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    with LifecycleMixin<T> {
  var _initialized = false;

  @override
  void didChangeDependencies() {
    if (!_initialized) {
      _initialized = true;
      initData();
    }
    super.didChangeDependencies();
  }

  void initData() {}

  @override
  void onPause() {}

  @override
  void onResume() {}
}
