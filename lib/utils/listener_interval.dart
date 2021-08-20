// import 'package:eechart/common/event_bus.dart';
//
// class ListenerInterval {
//   static DateTime? _lastTimeFriendApplicationEvent;
//   static DateTime? _lastTimeBlackListEvent;
//   static DateTime? _lastTimeFriendListEvent;
//   static DateTime? _lastTimeFriendInfoChangedEvent;
//
//   /// 2s
//   static final _interval = 2;
//
//   /// friend application 1
//   /// black list 2
//   /// friend list 3
//   /// friend info changed 4
//   static void _done(Function() run, {required int type}) {
//     DateTime now = DateTime.now();
//     if (type == 1) {
//       if (null == _lastTimeFriendApplicationEvent ||
//           now.difference(_lastTimeFriendApplicationEvent ?? now).inSeconds >
//               _interval) {
//         _lastTimeFriendApplicationEvent = now;
//         run();
//       }
//     } else if (type == 2) {
//       if (null == _lastTimeBlackListEvent ||
//           now.difference(_lastTimeBlackListEvent ?? now).inSeconds >
//               _interval) {
//         _lastTimeBlackListEvent = now;
//         run();
//       }
//     } else if (type == 3) {
//       if (null == _lastTimeFriendListEvent ||
//           now.difference(_lastTimeFriendListEvent ?? now).inSeconds >
//               _interval) {
//         _lastTimeFriendListEvent = now;
//         run();
//       }
//     } else if (type == 4) {
//       if (null == _lastTimeFriendInfoChangedEvent ||
//           now.difference(_lastTimeFriendInfoChangedEvent ?? now).inSeconds >
//               _interval) {
//         _lastTimeFriendInfoChangedEvent = now;
//         run();
//       }
//     }
//   }
//
//   /// friend application 1
//   /// black list 2
//   /// friend list 3
//   /// friend info changed 4
//   static notifyBlackListEvent(String u) {
//     _done(() => postBlackListEvent(u), type: 2);
//   }
//
//   static notifyFriendApplicationListEvent(String u) {
//     _done(() => postFriendApplicationListEvent(u), type: 1);
//   }
//
//   static notifyFriendInfoChangedEvent(String u) {
//     _done(() => postFriendInfoChangedEvent(u), type: 4);
//   }
//
//   static notifyFriendListEvent(String u) {
//     _done(() => postFriendListEvent(u), type: 3);
//   }
// }
