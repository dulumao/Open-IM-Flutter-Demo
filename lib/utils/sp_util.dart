import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/**
 * @Author: thl
 * @GitHub: https://github.com/Sky24n
 * @Email: 863764940@qq.com
 * @Email: sky24no@gmail.com
 * @Date: 2018/9/8
 * @Description: Sp Util.
 */

/// SharedPreferences Util.
class SpUtil {
  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  static void putString(String key, String value) {
    _prefs.setString(key, value);
  }

  static T? getObj<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map? getObject(String key) {
    String? _data = _prefs.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object.
  static Future<bool> putObject(String key, Object? value) {
    return _prefs.setString(key, value == null ? "" : json.encode(value));
  }
}
