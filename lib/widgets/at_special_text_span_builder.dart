import 'package:eechart/common/packages.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/foundation.dart';

typedef AtTextCallback = Function(String text, String actualText);

class AtSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  final AtTextCallback callback;
  final bool enabledAtFc;

  AtSpecialTextSpanBuilder({
    required this.callback,
    this.enabledAtFc = false,
  });

  @override
  TextSpan build(
    String data, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    StringBuffer buffer = StringBuffer();
    if (kIsWeb) {
      return TextSpan(text: data, style: textStyle);
    }
    if (!enabledAtFc) {
      return TextSpan(text: data, style: textStyle);
    }
    final List<InlineSpan> children = <InlineSpan>[];
    // data = data.replaceAll('@Oxglue....ause', '@张三1');
    data.splitMapJoin(
      RegExp(r"(@[^@]+\s)"),
      onMatch: (Match m) {
        late InlineSpan inlineSpan;
        String name = m.group(0)!;
        String uid = m.group(0)!.replaceAll("@", "").trim();
        if (groupMemberInfoMap.containsKey(uid)) {
          name = groupMemberInfoMap[uid]!.nickName!;
          inlineSpan = ExtendedWidgetSpan(
            child: Text(
              '@$name ',
              style: TextStyle(color: Colors.blue),
            ),
            style: TextStyle(color: Colors.blue),
            actualText: '${m.group(0)}',
            start: m.start,
          );
          buffer.write('@$name ');
        } else {
          /* inlineSpan = SpecialTextSpan(
            text: '${m.group(0)}',
            style: TextStyle(color: Colors.blue),
            start: m.start,
          );*/
          inlineSpan = TextSpan(text: '${m.group(0)}', style: textStyle);
          buffer.write('${m.group(0)}');
        }
        children.add(inlineSpan);
        return "";
      },
      onNonMatch: (text) {
        children.add(TextSpan(text: text, style: textStyle));
        buffer.write(text);
        return '';
      },
    );

    callback(buffer.toString(), data);
    return TextSpan(children: children, style: textStyle);
  }

  @override
  SpecialText? createSpecialText(
    String flag, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
    required int index,
  }) {
    return null;
  }
}
