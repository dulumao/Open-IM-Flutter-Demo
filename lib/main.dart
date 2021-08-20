import 'dart:io';

import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/im_bloc.dart';
import 'package:eechart/blocs/login_bloc.dart';
import 'package:eechart/common/config.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  startForegroundService();
  Config.init(() async {
    runApp(
      BlocProvider(
        bloc: IMBloc(),
        child: MyApp(),
      ),
    );
  });
}

void startForegroundService() async {
  if (Platform.isAndroid) {
    var hasPermissions = await FlutterBackground.hasPermissions;
    if (!hasPermissions) {
      print('================hasPermissions:$hasPermissions');
    }
    try {
      final config = FlutterBackgroundAndroidConfig(
        notificationTitle: 'OpenIM',
        notificationText: '',
      );
      // Demonstrate calling initialize twice in a row is possible without causing problems.
      hasPermissions =
          await FlutterBackground.initialize(androidConfig: config);
    } catch (ex) {
      print(ex);
    }
    if (hasPermissions) {
      bool success = await FlutterBackground.enableBackgroundExecution();
      if (success) {
        print('================enableBackgroundExecution:$success');
      }
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () => MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: Color(0xFFFFFFFF),
          // primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: true,
        // locale: Locale('en'),
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          // https://github.com/flutter/flutter/issues/22624
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          locale = deviceLocale;
          print('deviceLocale: $deviceLocale');
        },
        home: BlocProvider(
          child: LoginPage(),
          bloc: LoginBloc(),
        ),
      ),
    );
  }
}

Locale? locale;