import 'dart:io';

import 'package:eechart/common/packages.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

String imageResStr(var name) => "assets/images/$name.webp";

bool isLogin() => true;

void longPressCopy(BuildContext context, String data) {
  Clipboard.setData(ClipboardData(text: data));
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: S.of(context).copy_success,
    gravity: ToastGravity.CENTER,
  );
}

///  compress file and get file.
Future<File?> compressImage(
  File? file, {
  required String targetPath,
  required int minWidth,
  required int minHeight,
}) async {
  if (null == file) return null;
  var path = file.path;
  var name = path.substring(path.lastIndexOf("/"));
  // var ext = name.substring(name.lastIndexOf("."));
  CompressFormat format = CompressFormat.jpeg;
  if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
    format = CompressFormat.jpeg;
  } else if (name.endsWith(".png")) {
    format = CompressFormat.png;
  } else if (name.endsWith(".heic")) {
    format = CompressFormat.heic;
  } else if (name.endsWith(".webp")) {
    format = CompressFormat.webp;
  }

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 60,
    minWidth: minWidth,
    minHeight: minHeight,
    format: format,
  );
  return result;
}

//fileExt 文件后缀名
String? getMediaType(final String fileExt) {
  switch (fileExt.toLowerCase()) {
    case ".jpg":
    case ".jpeg":
    case ".jpe":
      return "image/jpeg";
    case ".png":
      return "image/png";
    case ".bmp":
      return "image/bmp";
    case ".gif":
      return "image/gif";
    case ".json":
      return "application/json";
    case ".svg":
    case ".svgz":
      return "image/svg+xml";
    case ".mp3":
      return "audio/mpeg";
    case ".mp4":
      return "video/mp4";
    case ".mov":
      return "video/mov";
    case ".htm":
    case ".html":
      return "text/html";
    case ".css":
      return "text/css";
    case ".csv":
      return "text/csv";
    case ".txt":
    case ".text":
    case ".conf":
    case ".def":
    case ".log":
    case ".in":
      return "text/plain";
  }
  return null;
}
