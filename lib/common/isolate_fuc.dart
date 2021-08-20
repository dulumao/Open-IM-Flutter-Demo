// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:azlistview/azlistview.dart';
// import 'package:eechart/models/contact_info.dart';
// import 'package:eechart/utils/isolate_handler.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
// import 'package:flutter_openim_sdk/models/message.dart';
// import 'package:lpinyin/lpinyin.dart';
//
// // This function happens in the isolate.
// void getConversationList(Map<String, dynamic> args) {
//   IsolateHandler.send(
//       args,
//       (args) => FlutterOpenimSdk.iMManager.conversationManager
//           .getAllConversationList()
//           .then((list) => json.encode(list)));
// }
//
// void handleContactList(Map<String, dynamic> args) {
//   IsolateHandler.send(
//       args,
//       (args) =>
//           FlutterOpenimSdk.iMManager.friendshipManager.getFriendList().then(
//             (friendList) {
//               List<ContactInfo> topList = (args['topList'] as List)
//                   .map((e) => ContactInfo.fromJson(e))
//                   .toList();
//
//               var list =
//                   friendList.map((e) => ContactInfo.fromUserInfo(e)).toList();
//               list.retainWhere((u) => u.isInBlackList == 0);
//               for (int i = 0, length = list.length; i < length; i++) {
//                 String pinyin = PinyinHelper.getPinyinE(list[i].nickname);
//                 String tag = pinyin.substring(0, 1).toUpperCase();
//                 list[i].namePinyin = pinyin;
//                 if (RegExp("[A-Z]").hasMatch(tag)) {
//                   list[i].tagIndex = tag;
//                 } else {
//                   list[i].tagIndex = "#";
//                 }
//               }
//               // A-Z sort.
//               SuspensionUtil.sortListBySuspensionTag(list);
//               // show sus tag.
//               SuspensionUtil.setShowSuspensionStatus(list);
//               // add topList.
//               list.insertAll(0, topList);
//               return list.map((e) => e.toJson()).toList();
//             },
//           ));
// }
//
// // This function happens in the isolate.
// void getHistoryMessageList(Map<String, dynamic> args) {
//   IsolateHandler.send(
//       args,
//       (args) => FlutterOpenimSdk.iMManager.messageManager
//           .getHistoryMessageList(
//             userID: args['userID'],
//             startMsg: null == args['startMsg']
//                 ? null
//                 : Message.fromJson(args['startMsg']),
//             groupID: args['groupID'],
//             count: args['count'],
//           )
//           .then((list) => list.map((e) => e.toJson()).toList()));
// }
//
// // This function happens in the isolate.
// void sendMsg(Map<String, dynamic> args) {
//   // FlutterOpenimSdk.iMManager.messageManager.sendMessage(
//   //   message: Message.fromJson(args['msg']),
//   //   onlineUserOnly: args['onlineUserOnly'],
//   //   receiver: args['uid'],
//   //   groupID: args['groupID'],
//   // );
//   IsolateHandler.send(
//       args,
//       (args) => FlutterOpenimSdk.iMManager.messageManager.sendMessage(
//             message: Message.fromJson(args['msg']),
//             onlineUserOnly: args['onlineUserOnly'],
//             receiver: args['uid'],
//             groupID: args['groupID'],
//           ));
// }
//
// // This function happens in the isolate.
// void createImgMsg(Map<String, dynamic> args) {
//   IsolateHandler.send(
//       args,
//       (args) => FlutterOpenimSdk.iMManager.messageManager
//           .createImageMessage(imagePath: args['path'])
//           .then((msg) => msg.toJson()));
// }
//
// // This function happens in the isolate.
// void createVideoMsg(Map<String, dynamic> args) {
//   IsolateHandler.send(
//       args,
//       (args) => FlutterOpenimSdk.iMManager.messageManager
//           .createVideoMessage(
//               videoPath: args['videoPath'],
//               videoType: args['videoType'],
//               duration: args['duration'],
//               snapshotPath: args['snapshotPath'])
//           .then((msg) => msg.toJson()));
// }
//
// Future<File> copyFile(Map<String, dynamic> data) async {
//   File dest = File(data['dest']);
//   if (!dest.existsSync()) {
//     dest.createSync(recursive: true);
//   }
//   return File(data['source']).copySync(data['dest']);
// }
// /*Future<R> isolateLoad<R, P>(
//   FutureOr<R> Function(P argument) function,
//   P argument,
// ) async {
//   final lb = await loadBalancer;
//   return lb.run<R, P>(
//     function,
//     argument,
//   );
// }
//
// Future<LoadBalancer> loadBalancer = LoadBalancer.create(2, IsolateRunner.spawn);*/
//
// /*
// // This function happens in the isolate.
// void getHistoryMessageList(Map<String, dynamic> context) {
//   callPlugin(context, asyncDo: (msg) async {
//     var list =
//     await FlutterOpenimSdk.iMManager.messageManager.getHistoryMessageList(
//       userID: msg['userID'],
//       startMsg: msg['startMsg'],
//       groupID: msg['groupID'],
//       count: msg['count'],
//     );
//     return list.map((e) => e.toJson()).toList();
//   });
// }
// void startIsolate(
//   void Function(Map<String, dynamic>) function, {
//   required String isolateName,
//   required Map<String, dynamic> params,
//   required void Function(dynamic message)? callback,
// }) {
//   final isolates = IsolateHandler();
//   // Start the isolate at the `entryPoint` function. We will be dealing with
//   // string types here, so we will restrict communication to that type. If no type
//   // is given, the type will be dynamic instead.
//   isolates.spawn(function,
//       // Here we give a name to the isolate, by which we can access is later,
//       // for example when sending it data and when disposing of it.
//       name: isolateName,
//       // onReceive is executed every time data is received from the spawned
//       // isolate. We will let the setPath function deal with any incoming
//       // data.
//       onReceive: (dynamic message) {
//         callback!(message);
//         isolates.kill(isolateName);
//       },
//       // Executed once when spawned isolate is ready for communication. We will
//       // send the isolate a request to perform its task right away.
//       onInitialized: () => isolates.send(params, to: isolateName));
// }
//
// void callPlugin(
//   Map<String, dynamic> context, {
//   required Future<dynamic> Function(dynamic params) asyncDo,
// }) {
//   // Calling initialize from the entry point with the context is
//   // required if communication is desired. It returns a messenger which
//   // allows listening and sending information to the main isolate.
//   final messenger = HandledIsolate.initialize(context);
//   // Triggered every time data is received from the main isolate.
//   messenger.listen((msg) async {
//     // Use a plugin to get some new value to send back to the main isolate.
//     final result = await asyncDo(msg);
//     messenger.send(result);
//   });
// }*/

import 'package:eechart/common/event_bus.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

void sendMessage(Map<String, dynamic> args) {
  var message = Message.fromJson(args['msg']);
  OpenIM.iMManager.messageManager
      .sendMessage(
        message: message,
        onlineUserOnly: false,
        userID: args['uid'],
        groupID: args['gid'],
      )
      .then((v) => postMsgSendResultEvent(message.clientMsgID!, true))
      .catchError((e) => postMsgSendResultEvent(message.clientMsgID!, false));
}
