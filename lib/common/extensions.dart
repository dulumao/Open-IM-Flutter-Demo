import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// widget 扩展
extension WidgetExt on Widget {
  //
  GestureDetector intoGesture({
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
  }) {
    return GestureDetector(
      child: this,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.translucent,
    );
  }

  Padding intoPadding({required EdgeInsetsGeometry padding}) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Container intoContainer({
    //复制Container构造函数的所有参数（除了child字段）
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
  }) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      child: this,
    );
  }

  Expanded intoExpanded({int flex = 1}) {
    return Expanded(child: this, flex: flex);
  }

  Align intoAlign({
    Key? key,
    AlignmentGeometry alignment = Alignment.center,
    double? widthFactor,
    double? heightFactor,
  }) {
    return Align(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }
}

// String 扩展
extension StringExt on String {
  double toDouble() => double.parse(this);

  int toInt() => int.parse(this);

// Decimal toDecimal() => Decimal.parse(this);
}

//bool extension
extension BoolExt on bool {
  bool not() => !this;

  bool and(bool val) => this && val;

  bool or(bool val) => this || val;
}

// 泛型扩展
extension AllExt<T> on T {
  T apply(f(T e)) {
    f(this);
    return this;
  }

  R let<R>(R f(T e)) {
    return f(this);
  }
}

extension ListExt<T> on List<T> {
  List<Widget> buildWidgetList(
      {required Widget Function(int index, T) builder}) {
    return this.map<Widget>((item) {
      return builder(this.indexOf(item), item);
    }).toList();
  }
}

extension WidgetListExt<T extends Widget> on List<T> {
  Column intoColumn({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) {
    return Column(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: this,
    );
  }

  Row intoRow({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) {
    return Row(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: this,
    );
  }
//添加其它多child的widget容器
//如:Column、ListView等...
}

// extension IntExt on int {
//   String formatDateMs({String format = "yyyy-MM-dd HH:mm:ss"}) {
//     return DateUtil.formatDateMs(this, format: format);
//   }
// }
//
extension SubjectExt<T> on Subject<T> {
  T addSafely(T data) {
    if (!isClosed) sink.add(data);
    // if (!isClosed) add(data);
    return data;
  }
}

/// 解决当输入框内容全为字母且长度超过63不能继续输入的bug
///
extension TextEdCtrlExt on TextEditingController {
  void fixed63Length() {
    addListener(() {
      if (text.length == 63 && Platform.isAndroid) {
        text += " ";
        selection = TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: text.length - 1,
          ),
        );
      }
    });
  }
}
