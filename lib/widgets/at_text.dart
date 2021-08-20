import 'package:eechart/common/packages.dart';

class AtText extends StatelessWidget {
  final String text;
  final ValueChanged<String>? onClick;
  final TextAlign textAlign;

  const AtText({
    Key? key,
    required this.text,
    this.onClick,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> children = <InlineSpan>[];
    text.splitMapJoin(
      RegExp(r"(@[^@]+\s)"),
      onMatch: (Match m) {
        late InlineSpan inlineSpan;
        String uid = m.group(0)!.replaceAll("@", "").trim();
        if (groupMemberInfoMap.containsKey(uid)) {
          var name = groupMemberInfoMap[uid]!.nickName!;
          inlineSpan = WidgetSpan(
            child: GestureDetector(
              onTap: () {
                print('click:$uid');
                if (null != onClick) onClick!(uid);
              },
              behavior: HitTestBehavior.translucent,
              child: Text(
                '@$name ',
                style: TextStyle(color: Color(0xFF1B72EC), fontSize: 14.sp),
              ),
            ),
          );
        } else {
          inlineSpan = TextSpan(
            text: '${m.group(0)}',
            style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
          );
        }
        children.add(inlineSpan);
        return m.group(0)!;
      },
      onNonMatch: (text) {
        children.add(TextSpan(
          text: text,
          style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
        ));
        return text;
      },
    );
    return RichText(
      textAlign: textAlign,
      text: TextSpan(children: children),
    );
  }
}
