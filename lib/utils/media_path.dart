import 'dart:io';

import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/sp_util.dart';

late String imCachePath;

class MediaPath {
  static Future<String?> getSmallPicPath({
    String? sourcePath,
    required int minWidth,
    required int minHeight,
  }) async {
    String? path;
    if (null != sourcePath) {
      path = SpUtil.getString(sourcePath);
      if (path.isEmpty) {
        var sourceFile = File(sourcePath);
        if ((await sourceFile.exists())) {
          var compressFile = await compressImage(
            sourceFile,
            targetPath: (await createNewPath(sourcePath, flag: 's'))['path']!,
            minHeight: minHeight,
            minWidth: minWidth,
          );
          path = compressFile?.path;
          if (null != path) SpUtil.putString(sourcePath, path);
        }
      }
    }
    return path;
  }

  static Future<Map<String, String>> createNewPath(
    String sourcePath, {
    String flag = "",
    String destDir = 'pic',
  }) async {
    int start = sourcePath.lastIndexOf('/');
    // String ext = sourcePath.substring(start);
    String name = '${flag}_${sourcePath.substring(start + 1)}';
    // String picName = '${_getNowDateMs()}$ext';
    String picPath = '$imCachePath/$destDir/$name';
    File destFile = File(picPath);
    if (!(await destFile.exists())) {
      await destFile.create(recursive: true);
    }
    return {"path": picPath, "name": name};
  }

  static Future<Map<String, String>> copyMedia({
    required String sourcePath,
    String destDir = 'pic',
  }) async {
    var destFile = await MediaPath.createNewPath(sourcePath, destDir: destDir);
    String path = destFile['path']!;
    String name = destFile['name']!;
    if ((await File(path).length()) == 0) {
      await File(sourcePath).copy(path);
    }
    return destFile;
  }

  static Future<Map<String, String>> createThumbPath(
    String sourcePath, {
    String flag = "",
    String destDir = 'pic',
  }) async {
    int start = sourcePath.lastIndexOf('/');
    int end = sourcePath.lastIndexOf('.');
    String name = '${flag}_${sourcePath.substring(start + 1, end)}';
    String picPath = '$imCachePath/$destDir/$name.jpg';
    File destFile = File(picPath);
    if (!(await destFile.exists())) {
      await destFile.create(recursive: true);
    }
    return {"path": picPath, "name": name};
  }

  /// get Now Date Milliseconds.
  static int _getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
