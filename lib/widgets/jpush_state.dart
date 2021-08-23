import 'package:eechart/common/packages.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

abstract class JpushState<T extends StatefulWidget> extends State<T> {
  String? debugLable = 'Unknown';
  final JPush jpush = new JPush();

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        setState(() {
          debugLable = "flutter onReceiveNotification: $message";
        });
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "ed5aac0bd3909ba34bb97705", //你自己应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  sendLocalNotification() {
    // 三秒后出发本地推送
    var fireDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 3000);
    var localNotification = LocalNotification(
        id: 234,
        title: 'fadsfa',
        buildId: 1,
        content: 'fdas',
        fireTime: fireDate,
        subtitle: 'fasf',
        badge: 5,
        extra: {"fa": "0"});
    jpush.sendLocalNotification(localNotification).then((res) {
      setState(() {
        debugLable = res;
      });
    });
  }

  getLaunchAppNotification() {
    jpush.getLaunchAppNotification().then((map) {
      print("flutter getLaunchAppNotification:$map");
      setState(() {
        debugLable = "getLaunchAppNotification success: $map";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "getLaunchAppNotification error: $error";
      });
    });
  }

  setTags() {
    jpush.setTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      setState(() {
        debugLable = "set tags success: $map $tags";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "set tags error: $error";
      });
    });
  }

  addTag() {
    jpush.addTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      setState(() {
        debugLable = "addTags success: $map $tags";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "addTags error: $error";
      });
    });
  }

  deleteTags() {
    jpush.deleteTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      setState(() {
        debugLable = "deleteTags success: $map $tags";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "deleteTags error: $error";
      });
    });
  }

  getAllTags() {
    jpush.getAllTags().then((map) {
      setState(() {
        debugLable = "getAllTags success: $map";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "getAllTags error: $error";
      });
    });
  }

  cleanTags() {
    jpush.cleanTags().then((map) {
      var tags = map['tags'];
      setState(() {
        debugLable = "cleanTags success: $map $tags";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "cleanTags error: $error";
      });
    });
  }

  setAlias() {
    jpush.setAlias("thealias11").then((map) {
      setState(() {
        debugLable = "setAlias success: $map";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "setAlias error: $error";
      });
    });
  }

  deleteAlias() {
    jpush.deleteAlias().then((map) {
      setState(() {
        debugLable = "deleteAlias success: $map";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "deleteAlias error: $error";
      });
    });
  }

  stopPush() {
    jpush.stopPush();
  }

  resumePush() {
    jpush.resumePush();
  }

  clearAllNotifications() {
    jpush.clearAllNotifications();
  }

  setBadge() {
    jpush.setBadge(66).then((map) {
      setState(() {
        debugLable = "setBadge success: $map";
      });
    }).catchError((error) {
      setState(() {
        debugLable = "setBadge error: $error";
      });
    });
  }

  isNotificationEnabled() {
    jpush.isNotificationEnabled().then((bool value) {
      setState(() {
        debugLable = "通知授权是否打开: $value";
      });
    }).catchError((onError) {
      setState(() {
        debugLable = "通知授权是否打开: ${onError.toString()}";
      });
    });
  }

  openSettingsForNotification() {
    jpush.openSettingsForNotification();
  }
}
