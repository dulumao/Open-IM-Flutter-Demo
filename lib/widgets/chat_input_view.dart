import 'dart:io';

import 'package:eechart/blocs/chat_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/map_web/map_webview_page.dart';
import 'package:eechart/utils/navigator_manager.dart';
import 'package:eechart/widgets/chat_voice_record_view.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:images_picker/images_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'at_special_text_span_builder.dart';

class ChatInputView extends StatelessWidget {
  final ChatBloc? bloc;

  ChatInputView({
    Key? key,
    this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildMsgInputField(context: context);
  }

  Widget _buildMsgInputField({required BuildContext context}) => Column(
    children: [
      Container(
        // height: 57.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Color(0xFFE8F2FF),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.12),
              offset: Offset(0, -1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            assetImage('ic_speak').intoGesture(
              onTap: () {
                bloc?.msgFocusNode.unfocus();
                Permissions.microphone(
                        () => recordVoice(context: context).then(
                          (value) {
                        if (null != value) bloc?.sendVoiceMsg(value);
                      },
                    ));
              },
            ),
            /* TextField(
                  focusNode: bloc?.msgFocusNode,
                  controller: bloc?.msgTextCtrl,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(bloc?.msgFocusNode);
                    bloc?.sendTextMsg();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                  ),
                )*/
            ExtendedTextField(
              specialTextSpanBuilder: AtSpecialTextSpanBuilder(
                callback: (text, actualText) {
                  bloc?.inputValueChanged(text, actualText);
                },
                enabledAtFc: bloc?.isGroupChat ?? false,
              ),
              focusNode: bloc?.msgFocusNode,
              controller: bloc?.msgTextCtrl,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(bloc?.msgFocusNode);
                bloc?.sendTextMsg();
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 3.h),
              ),
            )
                .intoContainer(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 3.w, right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    )
                    .intoExpanded(),
                assetImage('ic_add_blue').intoGesture(
                  onTap: () => bloc?.togglePlusToolbox(),
                ),
                Container(
                  width: 43.w,
                  height: 30.h,
                  margin: EdgeInsets.only(left: 8.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF1B72EC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    S.of(context).send,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ).intoGesture(onTap: () {
                  FocusScope.of(context).requestFocus(bloc?.msgFocusNode);
                  bloc?.sendTextMsg();
                }),
              ],
            ),
          ),
          StreamBuilder(
            stream: bloc?.plusKeyCtrl.stream,
            builder: (_, AsyncSnapshot<bool> hot) => Visibility(
              visible: hot.data ?? false,
              child: _buildTools(context: context, bloc: bloc),
            ),
          ),
        ],
      );

  Future<void> _pick(BuildContext context) async {
    // final Size size = MediaQuery.of(context).size;
    // final double scale = MediaQuery.of(context).devicePixelRatio;
    final AssetEntity? _entity = await CameraPicker.pickFromCamera(
      context,
      enableRecording: true,
    );
    bloc?.closePlusToolbox();
    bloc?.sendCameraMedia(_entity!);
    /* if (_entity != null && entity != _entity) {

      Uint8List? data = await _entity.thumbDataWithSize(
        (size.width * scale).toInt(),
        (size.height * scale).toInt(),
      );
    }*/
  }

  Widget _buildTools({
    required BuildContext context,
    ChatBloc? bloc,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h),
        child: Row(
          children: [
            _selectorOption('ic_camera', /*S.of(context).camera*/ '拍摄')
                .intoGesture(
              onTap: () {
                _pick(context);
                // Permissions.camera(() {
                //   ImagesPicker.openCamera(
                //     pickType: PickType.image,
                //     language: Language.English,
                //     // maxTime: 15,
                //   ).then((list) {
                //     bloc?.closePlusToolbox();
                //     bloc?.sendMediaMsg(list);
                //   });
                // });
              },
            ),
            Spacer(),
            _selectorOption('ic_album', S.of(context).album).intoGesture(
              onTap: () {
                Permissions.storage(() {
                  ImagesPicker.pick(
                    // count: 3,
                    pickType: PickType.all,
                    language: Language.English,
                    quality: 0.7, // only for android
                    maxSize: 1024 * 2, // only for ios (kb)
                  ).then((list) {
                    bloc?.closePlusToolbox();
                    bloc?.sendMediaMsg(list);
                  });
                });
              },
            ),
            Spacer(),
            _selectorOption('ic_file', S.of(context).file).intoGesture(
              onTap: () {
                FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['zip', 'pdf', 'doc', 'txt'],
                ).then((result) {
                  if (result != null) {
                    var single = result.files.single;
                    print('===========single:${single.size}');
                    print('===========single:${single.extension}');
                    print('===========single:${single.name}');
                    print('===========single:${single.path}');
                    File file = File(single.path!);
                    bloc?.sendFile(
                      filePath: single.path!,
                      fileName: single.name,
                      fileSize: single.size,
                    );
                  } else {
                    // User canceled the picker
                  }
                });
              },
            ),
            Spacer(),
            _selectorOption(null, '位置', iconData: Icons.location_on_outlined)
                .intoGesture(
              onTap: () {
                NavigatorManager.push(context, MapWebPage()).then((value) {
                  print('value:$value');
                  bloc?.closePlusToolbox();
                  if (value is LocationElem) {
                    bloc?.sendLocation(locationElem: value);
                  }
                });
              },
            ),
          ],
        ),
      );

  Widget _selectorOption(String? icon, String label, {IconData? iconData}) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (null != iconData)
            Icon(
              iconData,
              color: Color(0xFF1B72EC),
            ),
          if (null != icon)
            assetImage(
              icon,
              // width: 32.w,
              // height: 27.h,
              // fit: BoxFit.cover,
            ),
          SizedBox(
            height: 6.h,
          ),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF1B72EC),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          )
    ],
  );
}
