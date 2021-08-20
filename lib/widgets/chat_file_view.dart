import 'dart:io';

import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/sp_util.dart';
import 'package:eechart/widgets/chat_send_progress_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:open_file/open_file.dart';
import 'package:sprintf/sprintf.dart';

class ChatFileView extends StatefulWidget {
  const ChatFileView({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  _ChatFileViewState createState() => _ChatFileViewState();
}

class _ChatFileViewState extends State<ChatFileView> {
  late FileElem file;
  late String filePath;

  @override
  void initState() {
    file = widget.message.fileElem!;
    super.initState();
  }

  Future<String?> _getPath() async {
    try {
      /*if (null != file.filePath) {
        var f = File(file.filePath!);
        if (await f.exists()) {
          return file.filePath!;
        }
      } else {*/
        String path = SpUtil.getString(widget.message.clientMsgID!);
        var f = File(path);
        if (await f.exists()) {
          return path;
        }
   /*   }*/
    } catch (e) {
      print('$e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? path = await _getPath();
        if (null != path) {
          Permissions.storage((){
            // OpenFile.open(path);
          });
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 158.w,
        // height: 70.h,
        child: Stack(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.fileName!,
                      style:
                          TextStyle(fontSize: 12.sp, color: Color(0xFF333333)),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Text(
                      byteToMB(file.fileSize ?? 0),
                      style:
                          TextStyle(fontSize: 10.sp, color: Color(0xFF777777)),
                    )
                  ],
                ).intoExpanded(),
                SizedBox(
                  width: 10.w,
                ),
                assetImage('ic_file'),
              ],
            ),
            Visibility(
              child: ChatSendProgressView(
                width: 158.w,
                height: 52.h,
                message: widget.message,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 将字节数转化为MB
  String byteToMB(int size) {
    int kb = 1024;
    int mb = kb * 1024;
    int gb = mb * 1024;
    if (size >= gb) {
      return sprintf("%.1f GB", [size / gb]);
    } else if (size >= mb) {
      double f = size / mb;
      return sprintf(f > 100 ? "%.0f MB" : "%.1f MB", [f]);
    } else if (size > kb) {
      double f = size / kb;
      return sprintf(f > 100 ? "%.0f KB" : "%.1f KB", [f]);
    } else {
      return sprintf("%d B", [size]);
    }
  }
}
