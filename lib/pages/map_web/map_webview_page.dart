import 'dart:collection';
import 'dart:convert';

// import 'dart:convert';
import 'dart:io';

// import 'dart:typed_data';

import 'package:eechart/common/packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:sprintf/sprintf.dart';
// import 'package:path_provider/path_provider.dart';

class MapWebPage extends StatefulWidget {
  @override
  _MapWebPageState createState() => new _MapWebPageState();
}

class _MapWebPageState extends State<MapWebPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        domStorageEnabled: true,
        geolocationEnabled: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;

  // late ContextMenu contextMenu;
  String url = "";
  double progress = 0;

  // final urlController = TextEditingController();

  LocationElem? _locationElem;

  final mapUrl =
      "https://apis.map.qq.com/tools/locpicker?search=1&type=0&backurl=http://callback&key=TMNBZ-3CGC6-C6SSL-EJA3B-E2P5Q-V7F6Q&referer=myapp";

  @override
  void initState() {
    super.initState();

    /* contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });*/

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppbar(context,
            right: InkWell(
              onTap: () {
                Navigator.pop(context, _locationElem);
              },
              child: Container(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )),
        body: SafeArea(
            child: Column(children: <Widget>[
          /* TextField(
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            controller: urlController,
            keyboardType: TextInputType.url,
            onSubmitted: (value) {
              var url = Uri.parse(value);
              if (url.scheme.isEmpty) {
                url = Uri.parse("https://www.google.com/search?q=" + value);
              }
              webViewController?.loadUrl(urlRequest: URLRequest(url: url));
            },
          ),*/
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  // contextMenu: contextMenu,
                  initialUrlRequest: URLRequest(url: Uri.parse(mapUrl)),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    /*setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });*/
                  },
                  androidOnGeolocationPermissionsShowPrompt:
                      (InAppWebViewController controller, String origin) async {
                    return GeolocationPermissionShowPromptResponse(
                        origin: origin, allow: true, retain: true);
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;
                    if (uri.toString().startsWith("http://callback")) {
                      try {
                        print('${uri.queryParameters}');
                        var _result = <String, String>{};
                        _result.addAll(uri.queryParameters);
                        var lat = _result['latng'];
                        //latitude, longitude
                        var list = lat!.split(",");
                        _result['latitude'] = list[0];
                        _result['longitude'] = list[1];
                        _result['url'] = sprintf(
                          mapImageUrl,
                          [lat, lat],
                        );
                        _locationElem = LocationElem(
                          latitude: double.tryParse(_result['latitude']!),
                          longitude: double.tryParse(_result['longitude']!),
                          description: jsonEncode(_result),
                        );
                      } catch (e) {
                        print('e:$e');
                      }
                      return NavigationActionPolicy.CANCEL;
                    }
                    /*if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      */ /*if (await canLaunch(url)) {
                            // Launch the App
                            await launch(
                              url,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }*/ /*
                    }*/
                    print('--------------------$uri');
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    /* setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });*/
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    /* setState(() {
                      this.progress = progress / 100;
                      urlController.text = this.url;
                    });*/
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    /* setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });*/
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                // progress < 1.0
                //     ? LinearProgressIndicator(value: progress)
                //     : Container(),
              ],
            ),
          ),
          /*ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  webViewController?.goBack();
                },
              ),
              ElevatedButton(
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  webViewController?.goForward();
                },
              ),
              ElevatedButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  webViewController?.reload();
                },
              ),
            ],
          ),*/
        ])));
  }
}

final mapImageUrl =
    "https://apis.map.qq.com/ws/staticmap/v2/?center=%s&zoom=18&size=600*300&maptype=roadmap&markers=size:large|color:0xFFCCFF|label:k|%s&key=TMNBZ-3CGC6-C6SSL-EJA3B-E2P5Q-V7F6Q";
