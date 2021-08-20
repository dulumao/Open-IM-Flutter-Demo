import 'package:eechart/common/packages.dart';

class AtTextController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    assert(!value.composing.isValid ||
        !withComposing ||
        value.isComposingRangeValid);
    // If the composing range is out of range for the current text, ignore it to
    // preserve the tree integrity, otherwise in release mode a RangeError will
    // be thrown and this EditableText will be built with a broken subtree.
    print(
        'a========1=======text:$text     isComposingRangeValid:${value.isComposingRangeValid}     withComposing:$withComposing');

    // if (!value.isComposingRangeValid || !withComposing) {
    //   return TextSpan(style: style, text: text);
    // }
    final TextStyle composingStyle = style!.merge(
      const TextStyle(decoration: TextDecoration.underline),
    );
    List<TextSpan> children = [];
    text.splitMapJoin(
        // RegExp(r"\B@[a-zA-Z0-9]+\b"),
      RegExp(r"(@[\w|\W]+) "),
      onMatch: (Match m) {
        print('a===========match:${m.groupCount}    ${m.group(0)}');
        children.add(TextSpan(text:m.group(0),style: TextStyle(color: Colors.red) ));
        return "";
      },
      onNonMatch: (text) {
        print('a===========onNonMatch:${text}');
        children.add(TextSpan(text: text,style: style));
        return '';
      },
    );

    return TextSpan(style: style, /*text: text,*/children: children);
    /*return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: value.composing.textBefore(value.text)),
        TextSpan(
          style: composingStyle,
          text: value.composing.textInside(value.text),
        ),
        TextSpan(text: value.composing.textAfter(value.text)),
      ],
    );*/
  }
}
