/*
import 'package:eechart/common/packages.dart';
import 'package:flutter/services.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.onSubmitted,
  }) : super(key: key);
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final RegExp _atRegExp = new RegExp(r"(@\w+) ");
  List<AtTextPosition> _atTextPosition = List.empty(growable: true);

  @override
  void initState() {
    widget.controller?.addListener(() {
      // final ms = _exp.allMatches(widget.controller!.text);
      // for (Match m in ms) {
      //   String atText = m.group(0) ?? '';
      //   int start = m.start;
      //   int end = m.end;
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.data is RawKeyEventDataAndroid) {
          var data = event.data as RawKeyEventDataAndroid;
          if (data.keyCode == 67) {
            _delete();
          }
        } else if (event.data is RawKeyEventDataIos) {
          var data = event.data as RawKeyEventDataIos;
          if (data.keyCode == 67) {
            _delete();
          }
        }
      },
      child: TextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 4,
        textInputAction: TextInputAction.send,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 3.h),
        ),
      ),
    );
  }
}

class AtTextPosition {
  final String value;
  final int start;
  final int end;

  AtTextPosition({
    required this.value,
    required this.start,
    required this.end,
  });
}
*/
