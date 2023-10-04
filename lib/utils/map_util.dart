import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:voco/utils/validators.dart';

class MapUtil {
  static String getString(Map<String, dynamic> map, String key, {String defaultValue: ''}) {
    if (willBeAdded(map, key)) {
      try {
        return map[key] as String;
      } catch (e) {
        return map[key].toString();
      }
    }
    return defaultValue;
  }

  static int getInt(Map<String, dynamic> map, String key) {
    if (willBeAdded(map, key)) {
      try {
        return int.parse(map[key]);
      } catch (e) {
        return map[key] as int;
      }
    }
    return 0;
  }

  static bool getBool(Map<String, dynamic> map, String key) {
    if (willBeAdded(map, key)) {
      return map[key] as bool;
    }
    return false;
  }

  static DateTime getDateTime(Map<String, dynamic> map, String key) {
    if (willBeAdded(map, key)) {
      try {
        return DateFormat('dd.MM.yyyy').parse(map[key]);
      } catch (e) {
        try {
          return DateTime.parse(map[key]);
        } catch (e) {
          debugPrint('MapUtil.getDateTime() : $e');
        }
      }
    }
    return DateTime.now();
  }

  static double getDouble(Map<String, dynamic> map, String key) {
    if (willBeAdded(map, key)) {
      if (map[key] is String) {
        try {
          return double.parse(map[key]);
        } catch (e) {
          return 0.0;
        }
      }
      return map[key] as double;
    }
    return 0.0;
  }

  static bool willBeAdded(Map<String, dynamic> map, String key) {
    return map.containsKey(key) && map[key] != null;
  }

  static void add(Map<String, dynamic> data, String key, dynamic value) {
    if (Validators.isNotEmptyOrNull(value)) {
      data[key] = value;
    }
  }
}
