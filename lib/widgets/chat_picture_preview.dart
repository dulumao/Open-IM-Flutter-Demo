import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eechart/common/packages.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class PicturePreview extends StatefulWidget {
  PicturePreview({
    Key? key,
    this.url,
    this.path,
    required this.tag,
  }) : super(key: key);
  final String? url;
  final String? path;
  final String tag;

  @override
  _PicturePreviewState createState() => _PicturePreviewState();
}

class _PicturePreviewState extends State<PicturePreview> {
  ImageProvider? _provider;

  @override
  void initState() {
    if (null != widget.url && widget.url!.isNotEmpty) {
      _provider = CachedNetworkImageProvider(widget.url ?? '');
    } else if (null != widget.path) {
      _provider = FileImage(File(widget.path ?? ''));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        child: PhotoView(
          onTapDown: (context, details, value) => Navigator.pop(context),
          imageProvider: _provider,
          // disableGestures: false,
          // gaplessPlayback: true,
          // enableRotation: true,
          heroAttributes: PhotoViewHeroAttributes(tag: widget.tag),
          // customSize: Size(200.w, 400.h),
          loadingBuilder: (BuildContext context, ImageChunkEvent? event) {
            return Container(
              height: 20.0,
              width: 20.0,
              child: CupertinoActivityIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                assetImage('ic_pic_load_error'),
                SizedBox(
                  height: 19.h,
                ),
                Text(
                  S.of(context).pic_load_error,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                )
              ],
            );
          },
        ),
      ),
    ) /*.intoGesture(onTap: () => Navigator.pop(context))*/;
  }
}
