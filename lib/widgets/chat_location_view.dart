import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/map_web/maps_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';

class ChatLocationView extends StatelessWidget {
  ChatLocationView({Key? key, required this.message}) : super(key: key);
  final Message message;
  final JsonDecoder _decoder = JsonDecoder();
  late double _latitude;
  late double _longitude;
  late String _title;
  int zoom = 15;

  @override
  Widget build(BuildContext context) {
    var loc = message.locationElem;
    if (null == loc) return Container();
    try {
      var map = _decoder.convert(loc.description!);
      var url = map['url'];
      var name = map['name'];
      var addr = map['addr'];

      _latitude = loc.latitude!;
      _longitude = loc.longitude!;
      _title = name;
      return InkWell(
        onTap: () {
          MapsSheet.show(
            context: context,
            onMapTap: (map) {
              map.showMarker(
                coords: Coords(_latitude, _longitude),
                title: _title,
                // zoom: zoom,
              );
            },
          );
        },
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200.w,
                // height: 120.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white
                      ),
                    ),
                    Text(
                      addr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.sp,
                          color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
              CachedNetworkImage(
                width: 200.w,
                height: 120.h,
                imageUrl: url,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('$e');
    }
    return Container();
  }
}
