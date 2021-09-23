import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/login_bloc.dart';
import 'package:eechart/common/event_bus.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/dedup_util.dart';
import 'package:eechart/utils/media_path.dart';
import 'package:eechart/utils/sp_util.dart';
import 'package:eechart/widgets/chat_download_progress_view.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:images_picker/images_picker.dart';
import 'package:media_info/media_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart' as wcp;

final Map<String, String> draftTextMap = {};
final MediaInfo mediaInfo = MediaInfo();

class ChatBloc extends BlocBase {
  List<Message> chatMsgList = List.empty(growable: true);
  var msgTextCtrl = TextEditingController();
  var msgFocusNode = FocusNode();
  var _plusToolbox = false;

  BehaviorSubject<List<Message>> chatMsgListCtrl = BehaviorSubject();
  BehaviorSubject<int> scrollListCtrl = BehaviorSubject();
  BehaviorSubject<bool> plusKeyCtrl = BehaviorSubject();
  PublishSubject<int> clickCtrl = PublishSubject();
  BehaviorSubject<bool> loadHistoryMsgFinishedCtrl = BehaviorSubject();
  BehaviorSubject<bool> typingCtrl = BehaviorSubject();
  BehaviorSubject<DownloadInfo> downloadCtrl = BehaviorSubject();
  List<String> unreadMsgIdList = List.empty(growable: true);

  final String? uid;
  final String? gid;

  bool get isSingleChat => null != uid && uid!.trim().isNotEmpty;

  bool get isGroupChat => null != gid && gid!.trim().isNotEmpty;
  var _atUserMap = <String, String>{};

  // var msgListener;

  late StreamSubscription _messageSubs;
  late StreamSubscription _revokeMessageSubs;
  late StreamSubscription _messageHaveReadSubs;

  String? _text;
  String? _actualText;
  Timer? _typingTimer;
  String? _typingText;
  Dedup _typingDedup = Dedup();

  ChatBloc({this.uid, this.gid}) {
    if (uid != null && uid!.trim().isNotEmpty) {
      msgTextCtrl.text = draftTextMap['single_$uid'] ?? '';
    } else if (gid != null && gid!.trim().isNotEmpty) {
      var text = draftTextMap['group_$gid'] ?? '';
      print('====================draftTextMap=======$text');
      if (text.trim().isNotEmpty) {
        Map map = json.decode(text);
        var textMap = map['text'];
        Map atMap = map['at'];
        msgTextCtrl.text = textMap.keys.first;
        _atUserMap.addAll(
          atMap.map((key, value) => MapEntry('$key', '$value')),
        );
      } else {
        msgTextCtrl.text = text;
      }
    }
    addListener();
  }

  bool isCurrentChat(MessageEvent event) {
    var senderId = event.message.sendID;
    var groupId = event.message.groupID;
    var sessionType = event.message.sessionType;
    var isCurSingleChat =
        sessionType == 1 && null != uid && "" != uid!.trim() && senderId == uid;
    var isCurGroupChat =
        sessionType == 2 && null != gid && "" != gid!.trim() && gid == groupId;
    return isCurSingleChat || isCurGroupChat;
  }

  void addListener() {
    msgFocusNode.addListener(() {
      typing(focus: msgFocusNode.hasFocus);
      if (msgFocusNode.hasFocus) {
        closePlusToolbox();
      }
    });
    msgTextCtrl.addListener(() {
      _typingDedup.run(fuc: () => typing(focus: true), diff: 2000);
      _atUserMap.removeWhere((key, value) => !msgTextCtrl.text.contains(key));
    });
    _messageSubs = subsStream<MessageEvent>((event) {
      if (isCurrentChat(event)) {
        if (event.message.contentType == MessageType.typing) {
          if (event.message.content == 'yes') {
            if (_typingTimer == null) {
              typingCtrl.addSafely(true);
              _typingText = msgTextCtrl.text;
              _typingTimer = Timer.periodic(Duration(seconds: 2), (timer) {
                if (_typingText != msgTextCtrl.text) {
                  _typingText = msgTextCtrl.text;
                  typingCtrl.addSafely(true);
                } else {
                  typingCtrl.addSafely(false);
                  _typingTimer?.cancel();
                  _typingTimer = null;
                }
              });
            }
          } else {
            typingCtrl.addSafely(false);
            _typingTimer?.cancel();
            _typingTimer = null;
          }
        } else {
          //新增
          if (!chatMsgList.contains(event.message)) {
            chatMsgList.add(event.message);
            chatMsgListCtrl.addSafely(chatMsgList);
            scrollListCtrl.addSafely(chatMsgList.length - 1);
          }
        }
      }
    });
    _revokeMessageSubs = subsStream<RevokeMessageEvent>((event) {
      var msg = Message(clientMsgID: event.msgId);
      //撤回
      print('========================撤回：${msg.clientMsgID}');
      print('========================撤回：${chatMsgList.contains(msg)}');
      if (chatMsgList.contains(msg)) {
        chatMsgList.remove(msg);
        chatMsgListCtrl.addSafely(chatMsgList);
        scrollListCtrl.addSafely(chatMsgList.length - 1);
      }
    });
    _messageHaveReadSubs = subsStream<MessageHaveReadEvent>((event) {
      print('=====================标记 0 ：${uid}');
      chatMsgList.forEach((e) {
       var info = event.list.firstWhere((element) => element.uid== uid);
       print('=====================标记 1 ：${info}');
        if (info.msgIDList?.contains(e.clientMsgID) == true) {
          print('=====================标记：${e.clientMsgID}');
          e.isRead = true;
        }
      });
      chatMsgListCtrl.addSafely(chatMsgList);
    });
    // msgListener = AdvancedMsgListenerImpl(uid, onNewMessage: (msg) {
    //   if (msg.sendID == uid) {
    //     if (!chatMsgList.contains(msg)) {
    //       chatMsgList.add(msg);
    //       chatMsgListCtrl.addSafely(chatMsgList);
    //       scrollListCtrl.addSafely(chatMsgList.length - 1);
    //     }
    //   }
    // }, onMessageRevoked: (msg) {
    //   chatMsgList.remove(msg);
    //   chatMsgListCtrl.addSafely(chatMsgList);
    // });

    // FlutterOpenimSdk.iMManager.messageManager
    //     .addAdvancedMsgListener(msgListener);
  }

  void initMsgList({
    Message? startMsg,
  }) async {
    OpenIM.iMManager.messageManager
        .getHistoryMessageList(
      userID: uid,
      startMsg: startMsg,
      groupID: gid,
      count: 12,
    )
        .then((list) {
      chatMsgList.addAll(list);
      chatMsgListCtrl.addSafely(chatMsgList);
      scrollListCtrl.addSafely(chatMsgList.length - 1);
    });
  }

  void loadHistoryMsgList({
    Message? startMsg,
  }) {
    if (chatMsgList.isEmpty) {
      loadHistoryMsgFinishedCtrl.addSafely(true);
      return;
    }
    OpenIM.iMManager.messageManager
        .getHistoryMessageList(
            userID: uid, startMsg: chatMsgList.first, groupID: gid, count: 12)
        .then((list) {
      chatMsgList.insertAll(0, list);
      chatMsgListCtrl.addSafely(chatMsgList);
      // scrollListCtrl.addSafely(list.length);
    }).whenComplete(() => loadHistoryMsgFinishedCtrl.addSafely(true));
  }

  void markSingleMessageHasRead() {
    if (null != uid && uid!.trim().isNotEmpty)
      OpenIM.iMManager.conversationManager.markSingleMessageHasRead(userID: uid!);
    else if (null != gid && gid!.trim().isNotEmpty)
      OpenIM.iMManager.conversationManager.markGroupMessageHasRead(groupID: gid!);
  }

  void sendTextMsg({
    String? text,
    String? receiver,
    String? groupID,
    bool onlineUserOnly = false,
  }) async {
    if (msgTextCtrl.text.isNotEmpty) {
      late Message message;
      if (_atUserMap.isNotEmpty) {
        message = await OpenIM.iMManager.messageManager.createTextAtMessage(
          // text: _text ?? msgTextCtrl.text,
          text: _actualText ?? msgTextCtrl.text,
          atUidList: _atUserMap.values.toList(),
        );
      } else {
        message = await OpenIM.iMManager.messageManager.createTextMessage(
          text: msgTextCtrl.text,
        );
      }
      msgTextCtrl.clear();
      _sendMsg(message);
    }
  }

  void sendMediaMsg(
    List<Media>? mediaList, {
    String? receiver,
    String? groupID,
    bool onlineUserOnly = false,
  }) async {
    if (null != mediaList) {
      for (var media in mediaList) {
        var value = await mediaInfo.getMediaInfo(media.path);
        String type = value['mimeType'];
        late Message msg;
        if (type.contains('image/')) {
          var height = value['height'];
          var width = value['width'];
          var destFile = await MediaPath.copyMedia(
            sourcePath: media.path,
            destDir: 'pic',
          );
          msg = await OpenIM.iMManager.messageManager.createImageMessage(
            imagePath: 'pic/${destFile['name']}',
          );

          /*var now = DateTime.now();
          msg = Message(
            clientMsgID: "${now.microsecondsSinceEpoch}",
            createTime: now.millisecond ~/ 1000,
            sendTime: now.millisecond ~/ 1000,
            sessionType: 0,
            msgFrom: 100,
            contentType: 102,
            sendID: loginUserInfo?.uid,
            senderNickName: loginUserInfo?.name,
            status: MessageStatus.sending,
            platformID: 1,
            pictureElem: PictureElem(
              sourcePath: media.path,
              sourcePicture: PictureInfo(
                type: type,
                size: media.size ~/ 1,
                width: width,
                height: height,
              ),
            ),
          );*/
        } else if (type.contains('video/')) {
          var height = value['height'];
          var width = value['width'];
          var frameRate = value['frameRate'];
          var durationMs = value['durationMs'];
          var numTracks = value['numTracks'];
          var destVideo = await MediaPath.copyMedia(
            sourcePath: media.path,
            destDir: 'video',
          );
          var thumbFile;
          if (null == media.thumbPath) {
            var thumbFile = await MediaPath.createThumbPath(media.path);
            await mediaInfo.generateThumbnail(
              media.path,
              thumbFile['path']!,
              width,
              height,
            );
          } else {
            thumbFile = await MediaPath.copyMedia(
              sourcePath: media.thumbPath!,
              destDir: 'pic',
            );
          }
          msg = await OpenIM.iMManager.messageManager.createVideoMessage(
              videoPath: 'video/${destVideo['name']}',
              videoType: type,
              duration: durationMs ~/ 1000,
              snapshotPath: 'pic/${thumbFile['name']}');
        }
        _sendMsg(msg);
      }
    }
  }

  void sendCameraMedia(wcp.AssetEntity assets) async {
    var msg;
    var path = (await assets.file)!.path;
    // var length = await (await assets.file)!.length();
    var type = assets.mimeType;
    var width = assets.width;
    var height = assets.height;
    var duration = assets.duration;
    // var thumbFile = await MediaPath.createThumbPath(path);
    // await mediaInfo.generateThumbnail(
    //   path,
    //   thumbFile['path']!,
    //   width,
    //   height,
    // );
    // var sw = 100.w;
    // var sh = sw * height / width;
    // var data = await assets.thumbDataWithSize(width, height);
    // final result = await ImageGallerySaver.saveImage(data!);
    // if (assets.type == wcp.AssetType.image) {
    //   msg = OpenIM.iMManager.messageManager.createImageMessageV2(
    //     imagePath: path,
    //     mineType: type!,
    //     size: length,
    //     width: assets.width,
    //     height: assets.height,
    //   );
    // } else if (assets.type == wcp.AssetType.video) {
    //   msg = OpenIM.iMManager.messageManager.createVideoMessageV2(
    //     videoPath: path,
    //     videoType: type!,
    //     videoSize: length,
    //     duration: assets.duration,
    //     snapshotPath: result['filePath']!,
    //     snapshotSize: data.length,
    //     snapshotWidth: width,
    //     snapshotHeight: height,
    //   );
    // }
    if (assets.type == wcp.AssetType.image) {
      msg = await OpenIM.iMManager.messageManager
          .createImageMessageFromFullPath(imagePath: path);
    } else if (assets.type == wcp.AssetType.video) {
      var data = await assets.thumbDataWithSize(width, height);
      final result = await ImageGallerySaver.saveImage(data!);
      String tPath = result['filePath']
          .toString()
          .substring(result['filePath'].indexOf('/storage'));

      print('=====path:$path');
      print('=====result:$tPath');
      msg = await OpenIM.iMManager.messageManager
          .createVideoMessageFromFullPath(
              videoPath: path,
              videoType: type!,
              duration: duration,
              snapshotPath: tPath);
    }
    log('sendMsg:${jsonEncode(msg)}');
    _sendMsg(msg);
  }

  void sendVoiceMsg(
    dynamic data, {
    String? receiver,
    String? groupID,
    bool onlineUserOnly = false,
  }) async {
    String path = data['path'];
    int index = path.lastIndexOf('voice/');
    Message message = await OpenIM.iMManager.messageManager.createSoundMessage(
      soundPath: path.substring(index),
      duration: data['time'],
    );
    _sendMsg(message);
  }

  void sendFile({
    required String filePath,
    required String fileName,
    required int fileSize,
  }) {
    var message = OpenIM.iMManager.messageManager.createFileMessageV2(
      filePath: filePath,
      fileName: fileName,
      fileSize: fileSize,
    );
    SpUtil.putString(message.clientMsgID!, filePath);
    _sendMsg(message);
  }

  void sendLocation({
    required LocationElem locationElem,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createLocationMessage(
      latitude: locationElem.latitude!,
      longitude: locationElem.longitude!,
      description: locationElem.description!,
    );
    _sendMsg(message);
  }

  void _sendMsg(Message message) async {
    // print('======================message:${json.encode(message)}');
    // debugPrint('debugPrint message :${json.encode(message)}',wrapWidth: 1024*10);
    log('debugPrint message :${json.encode(message)}');
    chatMsgList.add(message /*..ext = true*/); //标识未来完成
    chatMsgListCtrl.addSafely(chatMsgList);
    scrollListCtrl.addSafely(chatMsgList.length - 1);
    // FlutterIsolate.spawn<Map<String, dynamic>>(sendMessage, {
    //   'msg': message.toJson(),
    //   'uid': uid,
    //   'gid': gid,
    // }).then((isolate) => isolate.kill())
    OpenIM.iMManager.messageManager
        .sendMessage(
          message: message,
          onlineUserOnly: false,
          userID: uid,
          groupID: gid,
        )
        .then((value) {
          ///
        })
        .then((v) => postMsgSendResultEvent(message.clientMsgID!, true))
        .catchError((e) {
          print('==================e:$e');
          return Future.error(e);
        })
        .catchError((e) => postMsgSendResultEvent(message.clientMsgID!, false));
  }

  void deleteMsg({required Message message}) {
    OpenIM.iMManager.messageManager
        .deleteMessageFromLocalStorage(message: message)
        .then((value) {
      chatMsgList.remove(message);
      chatMsgListCtrl.addSafely(chatMsgList);
    });
  }

  void revokeMeg({required Message message}) {
    OpenIM.iMManager.messageManager
        .revokeMessage(message: message)
        .then((value) {
          //message.contentType = MessageType.revoke
      // chatMsgList.singleWhere((e) => e.clientMsgID == message.clientMsgID);
      message.contentType = MessageType.revoke;
      chatMsgListCtrl.addSafely(chatMsgList);
    });
  }

  void addAtUser(List<UserInfo> list) {
    var cursor = msgTextCtrl.selection.base.offset;
    if (cursor < 0) cursor = 0;
    print('===================cursor:$cursor');
    var start = msgTextCtrl.text.substring(0, cursor);
    print('===================start:$start');
    var end = msgTextCtrl.text.substring(cursor);
    print('===================end:$end');
    var _list = <String>[];
    for (UserInfo u in list) {
      var key = '@${u.uid} ';
      if (!_atUserMap.containsKey(key)) {
        _list.add(key);
      }
      // _list.add(key);
      _atUserMap[key] = u.uid;
    }

    StringBuffer buffer = StringBuffer();
    for (var id in _list) {
      buffer.write(id);
    }

    msgTextCtrl.text = '$start${buffer.toString()}$end';
    msgTextCtrl.selection = TextSelection.fromPosition(TextPosition(
      offset: '$start${buffer.toString()}'.length,
    ));
  }

  void inputValueChanged(text, actualText) {
    this._text = text;
    this._actualText = actualText;
  }

  String getDartText() {
    if (isGroupChat) {
      if (null != _text && _text!.isNotEmpty) {
        return json.encode({
          'text': {_actualText: _text},
          'at': _atUserMap,
        });
      }
    }
    return msgTextCtrl.text;
  }

  void markC2CMessageAsRead(Message message) {
    if (message.isRead == false && message.sendID != OpenIM.iMManager.uid) {
      print('-----unread-----${message.clientMsgID!}   ${message.content}');
      OpenIM.iMManager.messageManager.markC2CMessageAsRead(
        userID: uid!,
        messageIDList: [message.clientMsgID!],
      ).then((value) => message.isRead = true);
    }
  }

  void typing({bool focus = false}) {
    OpenIM.iMManager.messageManager.typingStatusUpdate(
      userID: uid!,
      typing: focus,
    );
  }

  void download({required Message message}) async {
    var dir;
    if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    } else if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory())?.path;
    }
    print('=======dir:$dir');
    var fileName;
    var url;
    if (message.contentType == MessageType.file) {
      var file = message.fileElem;
      fileName = file!.fileName;
      url = file.sourceUrl;
    } else if (message.contentType == MessageType.picture) {
      var pic = message.pictureElem;
      int start = pic!.sourcePath!.lastIndexOf('/');
      fileName = pic.sourcePath!.substring(start + 1);
      url = pic.sourcePicture!.url;
    } else if (message.contentType == MessageType.video) {
      var video = message.videoElem;
      int start = video!.videoPath!.lastIndexOf('/');
      fileName = video.videoPath!.substring(start + 1);
      url = video.videoUrl!;
    }
    if (null != dir && null == fileName && url == null) return;
    String path = '$dir/download/$fileName';
    File destFile = File(path);
    if (!(await destFile.exists())) {
      await destFile.create(recursive: true);
    }
    var info = DownloadInfo(message.clientMsgID!, 0);
    var response = await dio.download(
      url,
      path,
      onReceiveProgress: (int count, int total) {
        var progress = ((count / total) * 100) ~/ 1;
        print('------------onReceiveProgress---------$progress');
        downloadCtrl.addSafely(info..progress = progress);
        if (progress == 100) {
          SpUtil.putString(message.clientMsgID!, path);
          ImageGallerySaver.saveFile(path);
        }
      },
    );
  }

  @override
  void dispose() {
    // FlutterOpenimSdk.iMManager.messageManager
    //     .removeAdvancedMsgListener(msgListener);
    chatMsgList.clear();
    chatMsgListCtrl.close();
    scrollListCtrl.close();
    plusKeyCtrl.close();
    clickCtrl.close();
    loadHistoryMsgFinishedCtrl.close();
    typingCtrl.close();
    downloadCtrl.close();
    msgTextCtrl.dispose();
    msgFocusNode.dispose();
    _messageSubs.cancel();
    _revokeMessageSubs.cancel();
    _messageHaveReadSubs.cancel();
  }

  int get index => chatMsgList.length;

  void togglePlusToolbox() {
    if (_plusToolbox)
      closePlusToolbox();
    else
      openPlusToolbox();
  }

  void openPlusToolbox() {
    msgFocusNode.unfocus();
    _plusToolbox = true;
    plusKeyCtrl.addSafely(true);
  }

  void closePlusToolbox() {
    _plusToolbox = false;
    plusKeyCtrl.addSafely(false);
  }
}
