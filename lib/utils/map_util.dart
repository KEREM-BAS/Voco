import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'validators.dart';

class MapUtil {
  static String getString(Map<String, dynamic> json, String key, {String? retryKey}) {
    if (willBeAdded(json, key)) {
      try {
        return json[key] as String;
      } catch (e) {
        return json[key].toString();
      }
    } else if (retryKey != null && willBeAdded(json, retryKey)) {
      try {
        return json[retryKey] as String;
      } catch (e) {
        return json[retryKey].toString();
      }
    }
    return '';
  }

  static int getInt(Map<String, dynamic> json, String key) {
    if (willBeAdded(json, key)) {
      return json[key] as int;
    }
    return 0;
  }

  static bool getBool(Map<String, dynamic> json, String key) {
    if (willBeAdded(json, key)) {
      return json[key] as bool;
    }
    return false;
  }

  static DateTime getDateTime(Map<String, dynamic> json, String key) {
    if (willBeAdded(json, key)) {
      try {
        return DateFormat('dd.MM.yyyy').parse(json[key]);
      } catch (e) {
        try {
          return DateTime.parse(json[key]);
        } catch (e) {
          debugPrint('MapUtil.getDateTime() : $e');
        }
      }
    }
    return DateTime.now();
  }

  static double getDouble(Map<String, dynamic> json, String key) {
    if (willBeAdded(json, key)) {
      if (json[key] is String) {
        try {
          return double.parse(json[key]);
        } catch (e) {
          return 0.0;
        }
      }
      return (json[key] * 1.0) as double;
    }
    return 0.0;
  }

  static bool willBeAdded(Map<String, dynamic> json, String key) {
    return json.containsKey(key) && json[key] != null;
  }

  static void add(Map<String, dynamic> data, String key, dynamic value, {bool includeNull = false}) {
    if (Validators.isNotEmptyOrNull(value) || includeNull) {
      if (value is DateTime) {
        /// 2023-05-08T07:14:20.183
        data[key] = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(value);
      } else {
        data[key] = value;
      }
    }
  }
}
