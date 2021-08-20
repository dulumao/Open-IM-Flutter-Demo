import 'package:flutter/material.dart';

abstract class BlocBase {
  late BuildContext context;

  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key? key,
    required this.bloc,
    required this.child,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  // 该方法用于在Dart中获取模板类型
  // static Type _typeof<T>() => T;

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static T? of<T extends BlocBase>(BuildContext context) {
    // final type = _typeof<BlocProvider<T>>();
    // final provider = context.ancestorWidgetOfExactType(type) as BlocProvider<T>;
    final provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider?.bloc;
  }

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    widget.bloc.context = context;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    widget.bloc.context = context;
    return widget.child;
  }
}
