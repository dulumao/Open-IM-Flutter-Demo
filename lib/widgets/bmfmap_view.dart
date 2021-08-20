// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
// import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
// import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
// import 'package:flutter_bmflocation/flutter_baidu_location.dart';
// import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
// import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
//
// class BMFMapView extends StatefulWidget {
//   const BMFMapView({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _BMFMapViewState createState() => _BMFMapViewState();
// }
//
// class _BMFMapViewState extends State<BMFMapView> {
//   ///---------------- location fc start--------------
//   Map<String, Object>? _locationResult;
//   BaiduLocation? _baiduLocation; // 定位结果
//   StreamSubscription<Map<String, Object>>? _locationListener;
//   LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();
//
//   @override
//   void initState() {
//     /// 动态申请定位权限
//     _locationPlugin.requestPermission();
//
//     if (Platform.isIOS) {
//       /// 设置ios端ak, android端ak可以直接在清单文件中配置
//       LocationFlutterPlugin.setApiKey("百度地图开放平台申请的ios端ak");
//     }
//
//     _locationListener = _locationPlugin.onResultCallback().listen((result) {
//       if (!mounted) return;
//       setState(() {
//         _locationResult = result;
//         try {
//           // 将原生端返回的定位结果信息存储在定位结果类中
//           _baiduLocation = BaiduLocation.fromMap(result);
//           _coordinate = BMFCoordinate(
//               _baiduLocation!.latitude!, _baiduLocation!.longitude!);
//           _updateUserLocation();
//         } catch (e) {
//           print(e);
//         }
//       });
//     });
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     if (null != _locationListener) {
//       _locationListener!.cancel(); // 停止定位
//     }
//   }
//
//   /// 设置android端和ios端定位参数
//   void _setLocOption() {
//     /// android 端设置定位参数
//     BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
//     androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
//     androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
//     androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
//     androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
//     androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
//     androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
//     androidOption.setOpenGps(true); // 设置是否需要使用gps
//     androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
//     androidOption.setScanspan(1000); // 设置发起定位请求时间间隔
//
//     Map androidMap = androidOption.getMap();
//
//     /// ios 端设置定位参数
//     BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
//     iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
//     iosOption.setBMKLocationCoordinateType(
//         "BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
//     iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
//     iosOption.setLocationTimeout(10); // 设置位置获取超时时间
//     iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
//     iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
//     iosOption.setDistanceFilter(100); // 设置定位最小更新距离
//     iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
//     iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停
//
//     Map iosMap = iosOption.getMap();
//
//     _locationPlugin.prepareLoc(androidMap, iosMap);
//   }
//
//   /// 启动定位
//   void _startLocation() {
//     _setLocOption();
//     _locationPlugin.startLocation();
//   }
//
//   /// 停止定位
//   void _stopLocation() {
//     _locationPlugin.stopLocation();
//   }
//
//   ///---------------- location fc end--------------
//   ///
//   ///
//   ///--------------- Map fuc start------------------
//   BMFMapController? _bmfmapController;
//
//   /// 定位模式状态
//   bool _showUserLocation = true;
//
//   /// 我的位置
//   BMFUserLocation? _userLocation;
//
//   /// 定位模式
//   BMFUserTrackingMode _userTrackingMode = BMFUserTrackingMode.Follow;
//
//   /// 坐标
//   BMFCoordinate? _coordinate;
//
//   /// 设置地图参数
//   BMFMapOptions _createMapOptions() {
//     BMFMapOptions mapOptions = BMFMapOptions(
//       center: _coordinate,
//       zoomLevel: 18,
//       maxZoomLevel: 18,
//       minZoomLevel: 15,
//       mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
//     );
//     return mapOptions;
//   }
//
//   /// 创建完成回调
//   void _onBMFMapCreated(BMFMapController controller) {
//     /// 地图加载回调
//     _bmfmapController?.setMapDidLoadCallback(callback: () {
//       print('mapDidLoad-地图加载完成');
//
//       if (_showUserLocation) {
//         _bmfmapController?.showUserLocation(true);
//         _updateUserLocation();
//         _bmfmapController?.setUserTrackingMode(_userTrackingMode);
//       }
//     });
//   }
//
//   void _setUserLocationMode(BMFUserTrackingMode userTrackingMode) {
//     this._userTrackingMode = userTrackingMode;
//
//     if (!_showUserLocation) {
//       return;
//     }
//
//     _bmfmapController?.setUserTrackingMode(userTrackingMode,
//         enableDirection: false);
//
//     if (BMFUserTrackingMode.Follow == userTrackingMode ||
//         BMFUserTrackingMode.Heading == userTrackingMode) {
//       _bmfmapController?.setNewMapStatus(
//           mapStatus: BMFMapStatus(fOverlooking: 0));
//     }
//   }
//
//   /// 更新位置
//   void _updateUserLocation() {
//     if (null == _coordinate || null == _bmfmapController) return;
//     BMFLocation location = BMFLocation(
//         coordinate: _coordinate!,
//         altitude: 0,
//         horizontalAccuracy: 5,
//         verticalAccuracy: -1.0,
//         speed: -1.0,
//         course: -1.0);
//     var userLocation = BMFUserLocation(location: location);
//     _userLocation = userLocation;
//     _bmfmapController?.updateLocationData(_userLocation!);
//   }
//
//   /// 创建地图
//   Container _generateMap() {
//     return Container(
//       child: BMFMapWidget(
//         onBMFMapCreated: (controller) {
//           _onBMFMapCreated(controller);
//         },
//         mapOptions: _createMapOptions(),
//       ),
//     );
//   }
//
//   /// 地图controller
//   Uint8List? _image;
//
//   void takeSnapshort() async {
//     Uint8List? image = await _bmfmapController?.takeSnapshot();
//     setState(() {
//       _image = image;
//     });
//   }
//
//   void takeSnapshortWitdhRect() async {
//     BMFMapRect mapRect = BMFMapRect(BMFPoint(10, 10), BMFSize(200, 200));
//     Uint8List? image = await _bmfmapController?.takeSnapshotWithRect(mapRect);
//     setState(() {
//       _image = image;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (null == _coordinate)
//       return Container(
//         child: CircularProgressIndicator(),
//       );
//     return _generateMap();
//   }
// }
