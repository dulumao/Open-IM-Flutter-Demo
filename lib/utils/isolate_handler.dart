// import 'dart:isolate';
//
// import 'package:flutter_isolate/flutter_isolate.dart';
//
// final _isolates = <String, FlutterIsolate>{};
//
// class IsolateHandler {
//   static final String _tag = 'isolate error';
//
//   static send(Map<String, dynamic> args, Future channel(args)) async {
//     late SendPort port;
//     try {
//       port = args['sendPort'];
//       var result = await channel(args);
//       port.send({'code': 0, 'errorMsg': null, 'data': result});
//     } catch (e) {
//       print('isolate error:$e');
//       port.send({'code': -1, 'errorMsg': e, 'data': null});
//     }
//   }
//
//   static /*Future<FlutterIsolate>*/ spawn(
//     void entryPoint(Map<String, dynamic> args),
//     Map<String, dynamic> args, {
//     required Function(dynamic) onData,
//     Function(dynamic)? onError,
//   }) async {
//     late FlutterIsolate isolate;
//     final port = ReceivePort();
//     port.listen((result) {
//       print('isolate finished ');
//       isolate.kill();
//       var code = result['code'];
//       if (code == 0) {
//         onData(result['data']);
//       } else {
//         if (null != onError) onError(result['errorMsg']);
//       }
//     });
//     isolate = await FlutterIsolate.spawn<Map<String, dynamic>>(
//       entryPoint,
//       _buildArgs(args, port.sendPort),
//     );
//   }
//
//   static Map<String, dynamic> _buildArgs(
//     Map<String, dynamic> args,
//     SendPort sendPort,
//   ) {
//     args['sendPort'] = sendPort;
//     return args;
//   }
// }
